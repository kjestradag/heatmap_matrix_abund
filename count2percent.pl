#!/usr/bin/perl -w
use strict;

scalar@ARGV == 1 || die "usage: $0 <matrix_count.txt>

      Programa que convierte una matriz de conteos crudos en abundancia total relativa

      matrix_count.txt      Matriz de conteos crudos donde la primer columna es la asignacion
		                      taxonomica y el resto son lps conteos para cada muestra
";

my $file=$ARGV[0];

## Armando el hash de la matriz de abundancia original
my %matrix;
open (FILE, $file) or die ("No puedo abrir el archivo $file\n");
my $header=<FILE>;
while (<FILE>) {
	chomp;
	my@line=split('\t', $_);
	my$tax_name=shift@line;
	my$element=join(',', @line);
	$matrix{$tax_name}=$element;
}
close(FILE);

my @samples=split("\t", $header);
my $samples_number=scalar@samples -1 ;

## Recorriendo el hash para obtener las abundancias relativas
my $suma_val=0;
my @suma_per_sample;
for (my $i=0; $i<$samples_number; $i++) {
	foreach my $key (sort keys %matrix){
		my@key_values=split(',', $matrix{$key});
		$suma_val=$key_values[$i]+$suma_val;
	}
	push(@suma_per_sample, $suma_val);
	$suma_val=0;
}

## Imprimiendo los valores de abundancia total relativa
my @new_vals;
open MATRIX, ">matrix_abund.txt" or die "No puedo escribir el archivo de salida\n";
print MATRIX "$header";
foreach my $key (sort keys %matrix){
	for (my $i=0; $i<$samples_number; $i++) {
		my@key_values=split(',', $matrix{$key});
		if ($key_values[$i] >0 ) {
			my$new_abundance= sprintf "%.6f", ($key_values[$i]*100)/$suma_per_sample[$i];
			push(@new_vals, $new_abundance);
		}else{
			push(@new_vals, "0");
		}
	}
	my$abundances=join("\t", @new_vals);
	@new_vals=();
	print MATRIX "$key\t$abundances\n";
}
close(MATRIX);

