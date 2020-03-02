#### ITS genus

#### load
consensus_table <- read.csv("ITS_genus_species_stacked_barchart_1genus_specie_fam.txt", sep="\t", header = F)

# col name
cnames <- c("specie","BA","HF","CF","SCF")
colnames(consensus_table) <- cnames

# selection
consensus_table <- consensus_table[ , c(1,2,3,4,5)]

# format
consensus_table.m <- melt(consensus_table)
consensus_table.m <- ddply(consensus_table.m, .(variable), transform, rescale = value)

#### filter
data_subset_filtered <- filter(consensus_table.m, value > 0.1)

#### graph
graph = ggplot(data_subset_filtered, aes(fill=specie, y=value, x=variable)) +
geom_bar(position="fill", stat="identity") +
scale_fill_viridis(discrete = T) +
labs(x = "Condition", y = NULL, fill = "Family/Genus/Specie\n") +
theme(
    axis.text.y = element_text(color = "grey10", size = 8), 
    axis.text.x = element_text(vjust = 0.5, color = "grey10", size = 12),
    
    legend.text = element_text(color = "grey10", size = 10),
    
    legend.title = element_text(color = "grey10", size = 12),
    
) 
