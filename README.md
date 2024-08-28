# 2024_pangenomegraph


## BCM hackathon project
## August 2024

# Analyzing Antimicrobial Resistance Genes in NCBI Sequence Read Archive

Antimicrobial resistance (AMR) is a growing global health concern, driven by the overuse and misuse of antibiotics. Detecting and monitoring the presence of AMR genes in various environments is crucial for understanding the spread of resistance and informing public health strategies. The Logan database of assembled contigs and unitigs, derived from a massive freeze of the NCBI Sequence Read Archive (SRA), offers a unique and comprehensive resource for studying genetic material across a wide array of samples (Chikhi et al., 2024).

In this project, we will align the genes of CARD (Comprehensive Antibiotic Resistance Database) (Alcock et al., 2023) to the Logan database to identify and catalog AMR genes present in the dataset. By leveraging the highly efficient unitigs and contigs of Logan, we aim to detect AMR genes with high accuracy and sensitivity, despite the inherent complexities and challenges of working with such a large-scale dataset (Bradley et al., 2019)[see section “Antibiotic resistance genes in the ENA”]. This work will provide valuable insights into the distribution and prevalence of AMR genes across a vast range of environments and host organisms.

## Summary of Procedures
- Data Preparation
  - Download (subset) unitigs/contigs from the Logan database.
  - Obtain the CARD database containing curated sequences of known AMR genes (link, file) [Daniel to github]
  - Download the metadata (data/location) of SRA accessions [Kristen]
  - Parse the metadata of SRA accessions 
- Alignment and Detection
  - Align the sequences from the CARD database to the Logan unitigs/contigs using appropriate bioinformatics tools using minimap2 (Li, 2018) and Diamond (Buchfink et al., 2015)[work in progress]. []
  - Identify and annotate matches, focusing on high-confidence alignments that suggest the presence of AMR genes.
- Post-Processing
  - Filter and curate the results to remove low-confidence hits (alignment length, alignment identity using NM tag)
  - Finding literature for AMR genes in SRA 
  - Specific biological question [Hassan]


## Summarize the findings in terms of the presence, distribution, and frequency of different AMR genes across the samples including metadata.
  - Interpret the results considering the limitations of the approach.

## Possible Future Directions
- Annotation and Visualization:
  - Develop scripts or pipelines to annotate AMR genes in the Logan dataset.
  - Create visualizations (e.g., heatmaps, phylogenetic trees, geographic plots) to represent the distribution of AMR genes across samples.
- Statistical Analysis:
  - Perform statistical tests to compare the prevalence of AMR genes across different environments or hosts.
  - Investigate correlations between the presence of AMR genes and metadata (e.g., sample origin, sequencing platform).

This project will not only contribute to the understanding of AMR gene distribution but also provide participants with hands-on experience in handling large-scale genomic datasets and applying bioinformatics tools in a real-world context.

## Extra information
- The Logan database: 
  - https://github.com/IndexThePlanet/Logan
  - The Logan database is a comprehensive collection of DNA and RNA sequences assembled from the entire NCBI Sequence Read Archive, offering an efficient and condensed representation of vast genomic data through unitigs and contigs.

- The CARD database: 
  - https://card.mcmaster.ca/
  - The CARD (Comprehensive Antibiotic Resistance Database) is a curated repository of sequences and associated data for known antimicrobial resistance genes, providing a critical resource for the identification and study of resistance mechanisms in various organisms.

For parsing CARD files, this code from this paper might be helpful. 
aro_metadata.tsv  & nucleotide_fasta_protein_homolog_model.fasta
Alignment results 
Instructions from Rayan here  

## References
Alcock, B. P., Huynh, W., Chalil, R., Smith, K. W., Raphenya, A. R., Wlodarski, M. A., Edalatmand, A., Petkau, A., Syed, S. A., Tsang, K. K., Baker, S. J. C., Dave, M., McCarthy, M. C., Mukiri, K. M., Nasir, J. A., Golbon, B., Imtiaz, H., Jiang, X., Kaur, K., … McArthur, A. G. (2023). CARD 2023: expanded curation, support for machine learning, and resistome prediction at the Comprehensive Antibiotic Resistance Database. Nucleic Acids Research, 51(D1), D690–D699.
Bradley, P., den Bakker, H. C., Rocha, E. P. C., McVean, G., & Iqbal, Z. (2019). Ultrafast search of all deposited bacterial and viral genomic data. Nature Biotechnology, 37(2), 152–159.
Buchfink, B., Xie, C., & Huson, D. H. (2015). Fast and sensitive protein alignment using DIAMOND. Nature Methods, 12(1), 59–60.
Chikhi, R., Raffestin, B., Korobeynikov, A., Edgar, R., & Babaian, A. (2024). Logan: Planetary-Scale Genome Assembly Surveys Life’s Diversity. In bioRxiv (p. 2024.07.30.605881). https://doi.org/10.1101/2024.07.30.605881
Li, H. (2018). Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics , 34(18), 3094–3100.


Team members:



Useful links

Zoom link for the group meetings:   https://jhubluejays.zoom.us/my/majidian 

Zoom link for the hackathon  https://dnanexus.zoom.us/j/98866720215?pwd=MUl0WnBmYUQyc1dHU3l3cGpuNHAyQT09 

Hackathon schedule: https://docs.google.com/document/d/1d9ZsMiFST9YFqCRGv23OA6V5S-iCwPbQXfJrdJWx5xc/edit#heading=h.ljuyhf5x89pp

GitHub page https://github.com/collaborativebioinformatics/2024_pangenomegraph

DNA nexus command line help page https://documentation.dnanexus.com/getting-started/cli-quickstart 

Hackathon paper 
https://docs.google.com/document/d/1VdB_qICMPKzlhnhZvWOAz54-u7s7aa_H2NSEp32tgx4/edit 



name
role
task


E-mail (gmail)
Github
dnaNexus
Daniel
colead
Sysadmin


danielp.agustinho@gmail.com
DanielPAagustinho
DanielPA
Sina
colead




sina.majidian@gmail.com
sinamajidian
smajidian
Abohassan


Flowchart/ writer1


abolhassanbahari@gmail.com
AbolhassanBahari
abolhassan
Kristen






kristendcurry@gmail.com
kdc10
kristendcurry
Aanuoluwa






aanuoluwadekoya@gmail.com
aanuoluwaduro
aanuoluwaduro
Christian












Jen-Yu


writer2


jenyuw@uci.edu
jyw-atgithub
jenyuwang
Rayan
 










Narges






nargessangaranip@gmail.com
nargessangaranipour
NargesSangaraniPour


roles to be distributed: Sysadmin DNAnexus /Github/ , Flowchart,  presenter_day1, writer1, writer2



ToDo list: (day1 )

Higher priority on top
Prepare flowchart [Hassan]
Add people to the DNA nexus [Daniel]
Downloading Alignment to the DNA nexus [ ? ]  
 


Filtering alignment (think of packages, command line) [Jen-Yen] 
Work on the metadata of SRA accessions [Kristen]
Literature on AMR genes and SRA [Hassan]

Add people to the github 




Updates: 






