#!/usr/bin/perl -w
use strict;

my %data;

my $file_to_open= shift;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	next if /^SampleID/;
	chomp;
	if( /^(\S+)\s+(.*)$/ ){
    	$data{$1}{other}= $2;
    }
}
my $file_to_open= shift;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	next if /^SampleID/;
	chomp;
	if( /^(\S+)\s+(\d+)/ ){
    	$data{$1}{fc2}= $2;
    }
}
my $file_to_open= shift;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	next if /^SampleID/;
	chomp;
	if( /^(\S+)\s+(\d+)/ ){
    	$data{$1}{fc3}= $2;
    }
}
my $file_to_open= shift;
open IN, $file_to_open or die "Cant read $file_to_open\n";
while(<IN>){
	next if /^SampleID/;
	chomp;
	if( /^(\S+)\s+(\d+)/ ){
    	$data{$1}{fs}= $2;
    }
}

foreach my $genus ( sort keys %data ){
	$data{$genus}{fc2}||=0;
    $data{$genus}{fc3}||=0;
    $data{$genus}{fs}||=0;
    $data{$genus}{other}||="0\t0\t0\t0";
    print "$genus\t$data{$genus}{other}\t$data{$genus}{fc2}\t$data{$genus}{fc3}\t$data{$genus}{fs}\n";
}
