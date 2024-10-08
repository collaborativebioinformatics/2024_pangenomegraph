#This is the script for the Hackathon
#I am working on grouping the ARO IDs by the categories they may belong to
#Date is Aug29, 2024
#I will most likely be using dplyr and tidyr cos this is just a lot of dataframe
restructuring and grouping
#install the packages
#install.packages("dplyr")
library(dplyr)
#install.packages("tidyr")
library(tidyr)
#load the dataset
getwd()
setwd("/Users/aanuoluwa/Downloads/")
#install.packages("readxl")
library(readxl)
original_data <- read_excel("aro_index.xlsx", sheet = "Sheet1")
dim(original_data) #[1] 5184   12
colnames(original_data)
#[1] "ARO Accession"
#[4] "Model ID"
#[7] "Protein Accession"
#[10] "Drug Class"
length(unique(original_data$`ARO Accession`)) #[1] 5179
#full dataframe is 5184 and unique ARO Accession is 5179 so some are duplicated
duplicated_acessions <- original_data[duplicated(original_data$`ARO Accession`)
                                      | duplicated(original_data$`ARO Accession`,
fromLast = TRUE), ]
print(duplicated_acessions)
#So from here I saw that the ARO accessions are duplicated but the model sequence ID
is not
#ARO:3002118 ; ARO:3003170; ARO:3003900; ARO:3003893; ARO:3000506
length(unique(original_data$`Model Sequence ID )) #[1] 5184
#so through, the Model Sequence ID is not duplicated
#but we are mostly interested in ARO ID anyways
#so the first thing to do is to identify the important columns
# "AMR Gene Family" ; "Drug Class"; "Resistance Mechanism"
#First separate the AMR Gene Family with semicolon into multiple rows
"CVTERM ID"
"Model Name"
"DNA Accession"
"Model Sequence ID"
"ARO Name"
"AMR Gene Family"
"Resistance Mechanism" "CARD Short Name"
 original_data_fixed_by_amr <- original_data %>%
  separate_rows(`AMR Gene Family`, sep = ";")
dim(original_data_fixed_by_amr) #[1] 6191   12
#Now separate the  Drug Class with semicolon into multiple rows
original_data_fixed_by_drug <- original_data_fixed_by_amr %>%
  separate_rows(`Drug Class`, sep = ";")
dim(original_data_fixed_by_drug) #[1] 13743    12
#Now separate the  Drug Class with semicolon into multiple rows
original_data_fixed_by_resistance <- original_data_fixed_by_drug %>%
  separate_rows(`Resistance Mechanism`, sep = ";")
dim(original_data_fixed_by_resistance) #[1] 14305    12
#so now I can start exploring the data
#group by AMR Gene Family ---------
length(unique(original_data_fixed_by_resistance$`AMR Gene Family`)) #[1] 503
grouped_amr <- original_data_fixed_by_resistance %>%
  group_by(`AMR Gene Family`) %>%
  summarise(AROs = list(`ARO Accession`))
#get the count of this
grouped_amr_count <- original_data_fixed_by_resistance %>%
  group_by(`AMR Gene Family`) %>%
  summarise(Count_of_AROs = n_distinct(`ARO Accession`))
grouped_amr_count
#group by Drug Class ---------
length(unique(original_data_fixed_by_resistance$`Drug Class`)) #[1] 49
grouped_drug <- original_data_fixed_by_resistance %>%
  group_by(`Drug Class`) %>%
  summarise(AROs = list(`ARO Accession`))
#get the count of this
grouped_drug_count <- original_data_fixed_by_resistance %>%
  group_by(`Drug Class`) %>%
  summarise(Count_of_AROs = n_distinct(`ARO Accession`))
grouped_drug_count
#group by Resistance Mechanism ---------
length(unique(original_data_fixed_by_resistance$`Resistance Mechanism`)) #[1] 8
grouped_resistance <- original_data_fixed_by_resistance %>%
  group_by(`Resistance Mechanism`) %>%
  summarise(AROs = list(`ARO Accession`))
#get the count of this
grouped_resistance_count <- original_data_fixed_by_resistance %>%
  group_by(`Resistance Mechanism`) %>%
  summarise(Count_of_AROs = n_distinct(`ARO Accession`))
grouped_resistance_count

#ploting-------
#In summary there are 503 unique AMR gene families, 49 drug classes and 8 resistance
mechanisms
#I think we should plot drug classes and resistance mechanisms instead
#install.packages("ggplot2")
library(ggplot2)
#plot drug classes
ggplot(grouped_drug_count, aes(x = `Drug Class`, y = Count_of_AROs)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Count of ARO Accessions by Drug Classes",
       x = "Drug Classes",
       y = "Count of ARO Accessions") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.margin = margin(t = 50, r = 50, b = 50, l = 50)
)+
scale_y_continuous(expand = c(0, 0))
#plot resistance mechanisms
ggplot(grouped_resistance_count, aes(x = `Resistance Mechanism`, y = Count_of_AROs))
+
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Count of ARO Accessions by Resistance Mechanisms",
       x = "Resistance Mechanisms",
       y = "Count of ARO Accessions") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 14),
        plot.margin = margin(t = 50, r = 50, b = 50, l = 50)
)+
scale_y_continuous(expand = c(0, 0))
