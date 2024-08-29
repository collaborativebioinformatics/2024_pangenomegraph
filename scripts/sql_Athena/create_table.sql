CREATE EXTERNAL TABLE IF NOT EXISTS `srametadata`.`Table1` (
  `acc` string,
  `assay_type` string,
  `center_name` string,
  `consent` string,
  `experiment` string,
  `sample_name` string,
  `instrument` string,
  `librarylayout` string,
  `libraryselection` string,
  `librarysource` string,
  `platform` string,
  `sample_acc` string,
  `biosample` string,
  `organism` string,
  `sra_study` string,
  `releasedate` date,
  `bioproject` string,
  `mbytes` int,
  `loaddate` timestamp,
  `avgspotlen` int,
  `mbases` int,
  `insertsize` int,
  `library_name` string,
  `biosamplemodel_sam` array < string >,
  `collection_date_sam` array < string >,
  `geo_loc_name_country_calc` string,
  `geo_loc_name_country_continent_calc` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION 's3://sra-pub-metadata-us-east-1/sra/metadata/'
TBLPROPERTIES ('classification' = 'parquet');
