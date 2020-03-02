
#### load data
consensus_table <- read.csv("ITS_genus_matrix_only_mds.txt", sep="\t", header = F,row.names=1)
# row.names=1 importante para que tome la primera columna como el nombre de las filas

# row names
rnames <- c("SCF1","SCF2","bye1","bye2","BA","bye3","CF1","CF2","CF3","CF4","CF5","HF1","HF2","S1","S2")
rownames(consensus_table) <- rnames

# selection
consensus_table <- consensus_table[c(1,2,5,7,8,9,10,11,12,13),]
consensus_table <- consensus_table[c(1,2,7,8,9,10,11),]

#### Compute MDS
mds <- consensus_table  %>%
  dist() %>%          
  cmdscale() %>%
  as_tibble()
# head(mds)
colnames(mds) <- c("Coordinate1", "Coordinate2")

#### groups
# K-means clustering (jugar con el numero de cluster que queremos que salga)
clust <- kmeans(mds, 2)$cluster %>%
  as.factor()
mds <- mds %>%
  mutate(groups = clust)
# Plot and color by groups
ggscatter(mds, x = "Coordinate1", y = "Coordinate2", 
          label = rownames(consensus_table),
          color = "groups",
          palette = "jco",
          size = 1, 
          ellipse = TRUE,
          ellipse.type = "convex",
          font.label = c(13, "bold"),
          title= "Metric MDS",
          repel = TRUE)
