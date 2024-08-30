#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 --input <align_list.txt> --download <download_address> --upload <upload_address>"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --input) align_list="$2"; shift ;;
        --download) download_address="$2"; shift ;;
        --upload) upload_address="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Check if all required arguments are provided
if [ -z "$align_list" ] || [ -z "$download_address" ] || [ -z "$upload_address" ]; then
    usage
fi

# Define the chunk size
chunk_size=14

# Generate a default output prefix based on the current date and time
output_prefix=$(date +"output_%Y%m%d_%H%M%S")

# Get the total number of files in align_list.txt
total_files=$(wc -l < "$align_list")

# Loop through the file list in chunks
for ((j=0; j<total_files; j+=chunk_size)); do

    # Download the files in the current chunk
    sed -n "$((j+1)),$((j+chunk_size))p" "$align_list" | while read -r line; do
        dx download "$download_address/$line"
    done

    # Decompress the downloaded files using parallel
    parallel --progress -j 7 zstd -dk ::: *all_minimap2.txt.zst
    wait

    # List the decompressed files
    ls *all_minimap2.txt > align_list_decomp.txt
    wait

    # Process each decompressed file using the integrated filter_parse_script.sh logic
    parallel --progress -j +0 '
    input_sam={}
    output_csv="${input_sam%.txt}.csv"
    echo "SRR,ARO_ID,Alignment_Length,Identity" > "$output_csv"
    awk "BEGIN {OFS=\",\"}
         !/^@/ {
             split(\$1, srr_parts, \"_\");
             srr_number = srr_parts[1];
             match(\$3, /ARO:[0-9]+/);
             aro_id = substr(\$3, RSTART, RLENGTH);
             cigar = \$6;
             match_len = 0;
             while (match(cigar, /[0-9]+[MIDNSHP=X]/)) {
                 len = substr(cigar, RSTART, RLENGTH);
                 type = substr(len, length(len), 1);
                 if (type == \"M\") {
                     match_len += int(substr(len, 1, length(len) - 1));
                 }
                 cigar = substr(cigar, RSTART + RLENGTH);
             }
             nm_tag = 0;
             for (i = 12; i <= NF; i++) {
                 if (\$i ~ /^NM:i:/) {
                     nm_tag = substr(\$i, 6);
                     break;
                 }
             }
             if (match_len > 0) {
                 identity = (1 - nm_tag / match_len) * 100;
             } else {
                 identity = 0;
             }
             if (match_len > 100 && \$3 ~ /^card_nucl\\.gb/ && identity >= 80) {
                 print srr_number, aro_id, match_len, identity;
             }
         }" "$input_sam" >> "$output_csv"
    echo "Processing complete. Results saved to $output_csv."
    ' ::: `cat align_list_decomp.txt`
    wait

    # Upload the resulting CSV files back to the DNAnexus server
    parallel --progress -j 4 dx upload --destination "$upload_address/" {} ::: *.all_minimap2.csv
    wait

    # Clean up: Remove the decompressed files, original .zst files, and generated CSV files
    rm *all_minimap2.txt *all_minimap2.txt.zst *.all_minimap2.csv

done

# Python section to merge tables
#!/bin/python3

### IMPORTS
import pandas as pd
import glob
import os

from sys import argv, stderr, exit

def merge_tables(path_minimap_csv:str, path_sra_metadata:str, path_aro_table:str, outfilename:str) -> None:

    # Importing only columns to be used for SRA metadata
    metadata_columns = ["acc", "organism", "biosample", "biosamplemodel_sam", "collection_date_sam", "geo_loc_name_country_calc", "geo_loc_name_country_continent_calc"]
    metadata_table = pd.read_csv(path_sra_metadata, sep=",", usecols=metadata_columns)
    # Fixing datetime for 'collection_date_sam' column and dropping NaT
    metadata_table["collection_date_sam"] = pd.to_datetime(metadata_table["collection_date_sam"].str[1:-1], errors='coerce')
    # Dropping NaT values
    metadata_table.dropna(subset=["collection_date_sam"], inplace=True)

    # Generating dataframe from minimap2 hits csvs
    csv_files = glob.glob(os.path.join(path_minimap_csv, "*.csv"))
    df = pd.concat((pd.read_csv(f) for f in csv_files), ignore_index=True)
    df.rename(columns={"SRR": "acc"}, inplace=True)

    # Importing only columns to be used for CARD metadata
    card_columns = ["ARO Accession", "Drug Class", "Resistance Mechanism"]
    card_table = pd.read_csv(path_aro_table, sep="\t", usecols=card_columns)
    card_table.rename(columns={"ARO Accession": "ARO_ID"}, inplace=True)

    # Joining the 3 tables into 1 and exporting as csv
    df = df.merge(metadata_table, on='acc', how='left').merge(card_table,on='ARO_ID')

    compression_opts = dict(method='zip',
                        archive_name=outfilename+'.csv')  

    df.to_csv(outfilename+'.zip', index=False,
          compression=compression_opts) 


if __name__ == "__main__":
    if (len(argv)) < 4:
        print("USAGE: \
              ./joint_tables.py <path_to_minimap2_csv_folder> <path_to_sra_metadata> <path_to_aro_table>", file=stderr)
        exit(1)

    merge_tables(*argv[1:4], "output")