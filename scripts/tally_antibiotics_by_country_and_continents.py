#!/usr/bin/env python

# Creates pivot tables of antibiotics resistance by country and continent. 

import pandas as pd

COL_SPECIES = 0
COL_COUNTRY = 8
COL_CONTINENT = 9
COL_ANTIBIOTIC = 10

infile = "all_aeruginosa.csv"

df = pd.read_csv(infile, sep=",", header=None)

df['all_antibiotics'] = df[COL_ANTIBIOTIC].str.split(";")
df = df.explode('all_antibiotics')

tab_country = df.pivot_table(index=COL_COUNTRY, columns='all_antibiotics', aggfunc='size',
                             fill_value=0)

tab_continent = df.pivot_table(index=COL_CONTINENT, columns='all_antibiotics', aggfunc='size',
                               fill_value=0)

tab_country_norm = tab_country.div(tab_country.sum(axis=1), axis=0).round(3)
tab_continent_norm = tab_continent.div(tab_continent.sum(axis=1), axis=0).round(3)

tab_country.to_csv("antibiotics_by_country.tsv", sep="\t")
tab_continent.to_csv("antibiotics_genes_by_continent.tsv", sep="\t")
tab_country_norm.to_csv("antibiotics_by_country_norm_by_rowsums.tsv", sep="\t")
tab_continent_norm.to_csv("antibiotics_genes_by_continent_norm_by_rowsums.tsv", sep="\t")
