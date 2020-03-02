
# graficar (primero llenar la tabla: ejemplos abajo)
CV_mine <- ggplot(consensus_table.m, aes(variable, Genus)) + geom_tile(aes(fill = rescale), colour = "white", size=0.25) + 
  scale_fill_gradientn("Relat.abundance", colours = c("#FFFFFF","#234d20", "#000000")) +
  scale_y_discrete(limits= unique(consensus_table.m$Genus)) +
  theme_minimal(base_size = 10) + 
  labs(x = "Samples", y = NULL) +
  scale_x_discrete(expand = c(0, 0)) +
  theme(
    axis.text.y = element_text(color = "grey10", size = 10), 
    axis.text.x = element_text(vjust = 0.5, color = "grey10", size = 14),
    legend.text = element_text(color = "grey10", size = 14),
    legend.title = element_text(color = "grey10", size = 15),
  ) 
CV_mine

#############################

#### 16s and ITS heatmaps example
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


#### 16s and ITS graph solid values example
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



