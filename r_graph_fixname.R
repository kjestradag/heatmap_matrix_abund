
library(grid)
library(gridExtra)
library(readr)
library(tidyverse)
library(reshape2)
library(dplyr)
library(plyr)

setwd("/scratch/Project_ClDiaz_tax/heatmap_16s/16s_heatmap")
setwd("/scratch/Project_ClDiaz_tax/heatmap_ITS/its_heatmap")

# construyendo tabla de datos de la clasificación taxonómica con la que haremos los heatmaps
#

# $ count2percent.pl genus_matrix.txt
# genus_matrix.txt:
# SampleID	M9_16S	M2_16S	M1_16S	M3_16S
# Bacteria;Acidobacteria;Acidobacteria;Order_Incertae_Sedis;Family_Incertae_Sedis;Bryobacter	0	1	0	0
# Bacteria;Actinobacteria;Actinobacteria;Actinomycetales;Actinomycetaceae;Actinobaculum	1	0	0	0
# ...

# $ sort -k2nr perc_genus_matrix.txt > sorted_perc_genus_matrix.txt
# 
# $ sed -i "1 s/^/$(tail -1 sorted_perc_genus_matrix.txt)\n/;$ d" sorted_perc_genus_matrix.txt
# 
# $ cut -d';' -f6 sorted_perc_genus_matrix.txt > sorted_perc_genus_matrix_onlygender.txt
# 
# $ awk '{if ($2>0.2 || $2>0.2 || $3>0.2 || $4>0.2) print $0}' sorted_perc_genus_matrix_onlygender.txt > sorted_perc_genus_matrix_onlygender_fil.txt;sed -i '1 d' sorted_perc_genus_matrix_onlygender_fil.txt

# graficar (primero llenar la tabla: ejemplos abajo)
CV_mine <- ggplot(consensus_table.m, aes(variable, Genus)) + geom_tile(aes(fill = rescale), colour = "white", size=0.25) + 
  #scale_fill_gradientn("Relat.abundance", colours = c("#FCF8F8","#77ab59", "#234d20")) +
  scale_fill_gradientn("Relat.abundance", colours = c("#FFFFFF","#234d20", "#000000")) +
  scale_y_discrete(limits= unique(consensus_table.m$Genus)) +
  # mas temas en: https://ggplot2.tidyverse.org/reference/ggtheme.html
  theme_minimal(base_size = 10) + 
  labs(x = "Samples", y = NULL) +
  scale_x_discrete(expand = c(0, 0)) +
  theme(
    axis.text.y = element_text(color = "grey10", size = 10), 
    axis.text.x = element_text(vjust = 0.5, color = "grey10", size = 14),
    legend.text = element_text(color = "grey10", size = 14),
    # quitar escala de leyenda
    # legend.text = element_blank(),
    legend.title = element_text(color = "grey10", size = 15),
    # quitar titulo de leyenda
    # legend.title = element_blank(),
    # quita la leyenda
    # legend.position = "none"
  ) 
CV_mine

#############################

#### 16s species
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_16s/16s_species_matrix_perc_sort_only_fil1.txt", sep="\t", header = F)
cnames <- c("Genus","CF3","PH2","PH1","BA","CF1","CF2","HF")
colnames(consensus_table) <- cnames

# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,5,8,6,7,2,4,3)]
# dar orden alfabetico a las columnas
# consensus_table <- consensus_table[ , order(names(consensus_table))]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- consensus_table.m[order(consensus_table.m$variable),]
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)

# aumentando la abund.relat de los pequenitos para que se vean un poco mas en el heatmap
for(i in 1:length(consensus_table.m$rescale)){
  if (consensus_table.m[i,4]<5 && consensus_table.m[i,4]>0) {
    consensus_table.m[i,4]=consensus_table.m[i,4]+2
  }else{
    if (consensus_table.m[i,4]>=5 && consensus_table.m[i,4]<10) {
      consensus_table.m[i,4]=consensus_table.m[i,4]+4
    }
  }
}

# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("16s_species_1.png", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### 16s genus
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_16s/16s_genus_matrix_perc_sort_only_fil5.txt", sep="\t", header = F)
cnames <- c("Genus","CF3","PH2","PH1","BA","CF1","CF2","HF")
colnames(consensus_table) <- cnames

# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,5,8,6,7,2,4,3)]
# dar orden alfabetico a las columnas
# consensus_table <- consensus_table[ , order(names(consensus_table))]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)

# aumentando la abund.relat de los pequenitos para que se vean un poco mas en el heatmap
for(i in 1:length(consensus_table.m$rescale)){
  if (consensus_table.m[i,4]<5 && consensus_table.m[i,4]>0) {
    consensus_table.m[i,4]=consensus_table.m[i,4]+2
  }else{
    if (consensus_table.m[i,4]>=5 && consensus_table.m[i,4]<10) {
      consensus_table.m[i,4]=consensus_table.m[i,4]+4
    }
  }
}

# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("16s_genus_5.png", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### ITS species
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_ITS/ITS_species_matrix_perc_sort_only_fil1_sinheader.txt", sep="\t", header = F)
cnames <- c("Genus","PH1","PH2","BA","CF1","CF2")
colnames(consensus_table) <- cnames
# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,4,5,6,2,3)]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)

# aumentando la abund.relat de los pequenitos para que se vean un poco mas en el heatmap
for(i in 1:length(consensus_table.m$rescale)){
  if (consensus_table.m[i,4]<5 && consensus_table.m[i,4]>0) {
     consensus_table.m[i,4]=consensus_table.m[i,4]+2
  }else{
    if (consensus_table.m[i,4]>=5 && consensus_table.m[i,4]<10) {
      consensus_table.m[i,4]=consensus_table.m[i,4]+4
    }
  }
}

# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("its_species_1.svg", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### ITS genus
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_ITS/ITS_genus_matrix_perc_sort_only_fil1_sinheader.txt", sep="\t", header = F)
cnames <- c("Genus","PH1","PH2","BA","CF1","CF2")
colnames(consensus_table) <- cnames
# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,4,5,6,2,3)]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)

# aumentando la abund.relat de los pequenitos para que se vean un poco mas en el heatmap
for(i in 1:length(consensus_table.m$rescale)){
  if (consensus_table.m[i,4]<5 && consensus_table.m[i,4]>0) {
    consensus_table.m[i,4]=consensus_table.m[i,4]+2
  }else{
    if (consensus_table.m[i,4]>=5 && consensus_table.m[i,4]<10) {
      consensus_table.m[i,4]=consensus_table.m[i,4]+4
    }
  }
}

# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("its_genus_1.png", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)

#############################
#############################
# cambiar valores para graficar solido si esta o no esta una especie

#### 16s species
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_16s/16s_species_matrix_perc_sort_only_fil1.txt", sep="\t", header = F)
cnames <- c("Genus","CF3","PH2","PH1","BA","CF1","CF2","HF")
colnames(consensus_table) <- cnames

# cambiar valores para graficar solido si esta o no esta una especie
consensus_table <- mutate(consensus_table, CF3 = ifelse(CF3 > 0, 1, CF3))
consensus_table <- mutate(consensus_table, PH2 = ifelse(PH2 > 0, 1, PH2))
consensus_table <- mutate(consensus_table, PH1 = ifelse(PH1 > 0, 1, PH1))
consensus_table <- mutate(consensus_table, BA = ifelse(BA > 0, 1, BA))
consensus_table <- mutate(consensus_table, CF1 = ifelse(CF1 > 0, 1, CF1))
consensus_table <- mutate(consensus_table, CF2 = ifelse(CF2 > 0, 1, CF2))
consensus_table <- mutate(consensus_table, HF = ifelse(HF > 0, 1, HF))

# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,5,8,6,7,2,3,4)]
# dar orden alfabetico a las columnas
# consensus_table <- consensus_table[ , order(names(consensus_table))]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- consensus_table.m[order(consensus_table.m$variable),]
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)
# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("16s_species_1_fill.svg", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### 16s genus
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_16s/16s_genus_matrix_perc_sort_only_fil1.txt", sep="\t", header = F)
cnames <- c("Genus","CF3","PH2","PH1","BA","CF1","CF2","HF")
colnames(consensus_table) <- cnames

# cambiar valores para graficar solido si esta o no esta una especie
consensus_table <- mutate(consensus_table, CF3 = ifelse(CF3 > 0, 1, CF3))
consensus_table <- mutate(consensus_table, PH2 = ifelse(PH2 > 0, 1, PH2))
consensus_table <- mutate(consensus_table, PH1 = ifelse(PH1 > 0, 1, PH1))
consensus_table <- mutate(consensus_table, BA = ifelse(BA > 0, 1, BA))
consensus_table <- mutate(consensus_table, CF1 = ifelse(CF1 > 0, 1, CF1))
consensus_table <- mutate(consensus_table, CF2 = ifelse(CF2 > 0, 1, CF2))
consensus_table <- mutate(consensus_table, HF = ifelse(HF > 0, 1, HF))

# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,5,8,6,7,2,3,4)]
# dar orden alfabetico a las columnas
# consensus_table <- consensus_table[ , order(names(consensus_table))]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)
# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("16s_genus_1_fill.svg", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### ITS species
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_ITS/ITS_species_matrix_perc_sort_only_fil0.1_sinheader.txt", sep="\t", header = F)
cnames <- c("Genus","PH1","PH2","BA","CF1","CF2")
colnames(consensus_table) <- cnames

# cambiar valores para graficar solido si esta o no esta una especie
consensus_table <- mutate(consensus_table, PH2 = ifelse(PH2 > 0, 1, PH2))
consensus_table <- mutate(consensus_table, PH1 = ifelse(PH1 > 0, 1, PH1))
consensus_table <- mutate(consensus_table, BA = ifelse(BA > 0, 1, BA))
consensus_table <- mutate(consensus_table, CF1 = ifelse(CF1 > 0, 1, CF1))
consensus_table <- mutate(consensus_table, CF2 = ifelse(CF2 > 0, 1, CF2))
# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,4,5,6,2,3)]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)
# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("its_species_01_fill.svg", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)


#### ITS genus
consensus_table <- read.csv("/scratch/Project_ClDiaz_tax/heatmap_ITS/ITS_genus_matrix_perc_sort_only_fil0.1_sinheader.txt", sep="\t", header = F)
cnames <- c("Genus","PH1","PH2","BA","CF1","CF2")
colnames(consensus_table) <- cnames 

# cambiar valores para graficar solido si esta o no esta una especie
consensus_table <- mutate(consensus_table, PH2 = ifelse(PH2 > 0, 1, PH2))
consensus_table <- mutate(consensus_table, PH1 = ifelse(PH1 > 0, 1, PH1))
consensus_table <- mutate(consensus_table, BA = ifelse(BA > 0, 1, BA))
consensus_table <- mutate(consensus_table, CF1 = ifelse(CF1 > 0, 1, CF1))
consensus_table <- mutate(consensus_table, CF2 = ifelse(CF2 > 0, 1, CF2))
# dar el orden que yo quiera a las columnas
consensus_table <- consensus_table[ , c(1,4,5,6,2,3)]

consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)
# salvar grafica (reconoce la ext. automatily  .svg o .png )
ggsave("its_genus_01_fill.svg", width = 60, height = 40, dpi=300, units ="in", scale = 0.2, limitsize = FALSE)



