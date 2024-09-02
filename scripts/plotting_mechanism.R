#install.packages(c("ggplot2", "tidyverse", "RColorBrewer", "khroma"))
#install.packages("dplyr")
library("dplyr")
library("ggplot2")
library("RColorBrewer")
library("khroma")
# toy file: SRR0_SRR11.csv
t=read.csv("SRR0_SRR11.csv",header=TRUE)
t_ec= t %>% filter_all(all_vars(!is.na(.))) %>% filter(organism=="Escherichia coli") %>% select(organism, collection_date_sam,Resistance.Mechanism) %>%
mutate(year=as.numeric(substr(collection_date_sam,1,4))) 
#levels(t_ec$Resistance.Mechanism)

t_ec_ata= t_ec %>% filter(grepl("antibiotic target alteration",Resistance.Mechanism)) %>% count(year) %>% mutate(mechanism="antibiotic target alteration")
t_ec_ae= t_ec %>% filter(grepl("antibiotic efflux",Resistance.Mechanism)) %>% count(year)%>% mutate(mechanism="antibiotic efflux")
t_ec_rpa= t_ec %>% filter(grepl("reduced permeability to antibiotic",Resistance.Mechanism)) %>% count(year)%>% mutate(mechanism="reduced permeability to antibiotic")
t_ec_ra= t_ec %>% filter(grepl("resistance by absence",Resistance.Mechanism)) %>% count(year) %>% mutate(mechanism="resistance by absence")
t_ec_atr= t_ec %>% filter(grepl("antibiotic target replacement",Resistance.Mechanism)) %>% count(year) %>% mutate(mechanism="antibiotic target replacement")
t_ec_rhdna= t_ec %>% filter(grepl("resistance by host-dependent nutrient acquisition",Resistance.Mechanism)) %>% count(year) %>% mutate(mechanism="resistance by host-dependent nutrient acquisition")
t_ec_all= bind_rows(t_ec_ata,t_ec_ae,t_ec_rpa,t_ec_ra,t_ec_atr,t_ec_rhdna)%>% group_by(year)  %>% mutate(year_sum=sum(n))%>% mutate(percent=n/year_sum*100) 

p1=ggplot(t_ec_all, aes(x=year, y=percent, color=mechanism)) 
p1=p1+geom_line(linewidth=1.1)+ scale_colour_bright()+ggtitle("E. coli Resistance Mechanisms Over Time")+ylab("Percentage of Resistance Mechanism")+xlab("Year")
ggsave("ecoli_mechanism.png", plot=p1, width=9, height=6, dpi=300, units = "in")


m_list=c("antibiotic target alteration","antibiotic efflux","reduced permeability to antibiotic","resistance by absence","antibiotic target replacement","resistance by host-dependent nutrient acquisition")
organism_list=c("Escherichia coli","Pseudomonas aeruginosa","Acinetobacter baumannii","Klebsiella pneumoniae")
#organism_list=c("Pseudomonas aeruginosa")

t_sp_all <- data.frame() # Initialize t_sp_all variable
for (j in organism_list) {
    t_sp = t %>% filter_all(all_vars(!is.na(.))) %>% filter(organism == j) %>% select(organism, collection_date_sam,Resistance.Mechanism) %>% mutate(year=as.numeric(substr(collection_date_sam,1,4)))
    #print(head(t_sp))
    #print(levels(t_sp$Resistance.Mechanism))
    for (i in m_list) {
        print(j)
        t_sp_rm= t_sp %>% filter(grepl(i,Resistance.Mechanism)) %>% count(year) %>% mutate(mechanism=i) %>% mutate(organism=j)
        t_sp_all= bind_rows(t_sp_all, t_sp_rm)%>% group_by(year) %>% mutate(year_sum=sum(n))%>% mutate(percent=n/year_sum*100) %>% filter(year>=2010)
    }
    print(t_sp_all,n=100)
    p=ggplot(t_sp_all, aes(x=year, y=percent, color=mechanism))
    p=p+geom_line(linewidth=1.1)+ scale_colour_bright()+ggtitle(paste(j,"Resistance Mechanisms Over Time"))+ylab("Percentage")+xlab("Year")+scale_x_continuous(breaks =2010:2020) + ylim(0,80) +scale_y_continuous(breaks = seq(0, 80, by = 10))
    ggsave(paste(gsub(" ","",j),"_mechanism.png",sep=""), plot=p, width=9, height=6, dpi=300, units = "in")
    t_sp_all <- data.frame() # Reset t_sp_all variable
}
