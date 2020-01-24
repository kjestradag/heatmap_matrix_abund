Pipeline for heatmap graphs generation:

##1## merging of tables

$ integrar_tablas.pl <species_matrix1.txt> <species_matrix2.txt> .. > 16s_species_matrix.txt

$ integrar_tablas.pl <genus_matrix1.txt> <genus_matrix2.txt> .. > 16s_genus_matrix.txt > 16s_genus_matrix.txt

##2## relative abundance estimation

$ count2percent.pl 16s_genus_matrix.txt; mv matrix_abund.txt 16s_genus_matrix_perc.txt

$ count2percent.pl 16s_species_matrix.txt; mv matrix_abund.txt 16s_species_matrix_perc.txt

##3## some intermediate steps

$ sort -k2nr 16s_genus_matrix_perc.txt > 16s_genus_matrix_perc_sort.txt

$ sort -k2nr 16s_species_matrix_perc.txt > 16s_species_matrix_perc_sort.txt

##4## fix the header line after the sort above (put it up)

##5## left only the genus or specie

$ cut -d';' -f6 16s_genus_matrix_perc_sort.txt > 16s_genus_matrix_perc_sort_only.txt

$ cut -d';' -f7 16s_species_matrix_perc_sort.txt > 16s_species_matrix_perc_sort_only.txt

##6## playing with some threshold lines

$ awk '{if ($2>0.1 || $3>0.1 || $4>0.1 || $5>0.1 || $6>0.1 || $7>0.1) print $0}' 16s_species_matrix_perc_sort_only.txt > 16s_species_matrix_perc_sort_only_fil0.1.txt; sed '1 d' 16s_species_matrix_perc_sort_only_fil0.1.txt > 16s_species_matrix_perc_sort_only_fil0.1_sinheader.txt

$ awk '{if ($2>1 || $3>1 || $4>1 || $5>1 || $6>1 || $7>1) print $0}' 16s_species_matrix_perc_sort_only.txt > 16s_species_matrix_perc_sort_only_fil1.txt; sed '1 d' 16s_species_matrix_perc_sort_only_fil1.txt > 16s_species_matrix_perc_sort_only_fil1_sinheader.txt

$ awk '{if ($2>5 || $3>5 || $4>5 || $5>5 || $6>5 || $7>5) print $0}' 16s_species_matrix_perc_sort_only.txt > 16s_species_matrix_perc_sort_only_fil5.txt; sed '1 d' 16s_species_matrix_perc_sort_only_fil5.txt > 16s_species_matrix_perc_sort_only_fil5_sinheader.txt

$ awk '{if ($2>0.1 || $3>0.1 || $4>0.1 || $5>0.1 || $6>0.1 || $7>0.1) print $0}' 16s_genus_matrix_perc_sort_only.txt > 16s_genus_matrix_perc_sort_only_fil0.1.txt; sed '1 d' 16s_genus_matrix_perc_sort_only_fil0.1.txt > 16s_genus_matrix_perc_sort_only_fil0.1_sinheader.txt

$ awk '{if ($2>1 || $3>1 || $4>1 || $5>1 || $6>1 || $7>1) print $0}' 16s_genus_matrix_perc_sort_only.txt > 16s_genus_matrix_perc_sort_only_fil1.txt; sed '1 d' 16s_genus_matrix_perc_sort_only_fil1.txt > 16s_genus_matrix_perc_sort_only_fil1_sinheader.txt

$ awk '{if ($2>5 || $3>5 || $4>5 || $5>5 || $6>5 || $7>5) print $0}' 16s_genus_matrix_perc_sort_only.txt > 16s_genus_matrix_perc_sort_only_fil5.txt; sed '1 d' 16s_genus_matrix_perc_sort_only_fil5.txt > 16s_genus_matrix_perc_sort_only_fil5_sinheader.txt

# Graph in R
r_graph_fixname.R
