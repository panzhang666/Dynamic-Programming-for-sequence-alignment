use strict;  
use warnings;
open F1, ">S01.fa";
open F2, ">S02.fa";   
my @dna;  
my $dna_length;  
my $newbase;  
my $i=0;  
my $j=0;
my $h=0;
my @nucleotides=qw/A T G C/;
print "please input the DNA length\n";  
chomp($dna_length=<>);  

while($i<$dna_length){
	$newbase=$nucleotides[rand @nucleotides];
	push(@dna,$newbase);
	$i++;
}
my @dna1=@dna;
my $change_length= int($dna_length/10);
my @location;
my $dna_length_1=scalar(@dna1);
while($j<$change_length){
	my $loc= int(rand($dna_length_1));
	my @choice= qw/m d/;
	my $change= $choice[rand @choice];
	if ($change eq "m"){
		if ($dna1[$loc]=~/A/){
			my @nu=qw/T G C/;
			$dna1[$loc]=$nu[rand @nu];
		}
		if ($dna1[$loc]=~/T/){
                        my @nu=qw/A G C/;
                        $dna1[$loc]=$nu[rand @nu];
                }
		if ($dna1[$loc]=~/G/){
                        my @nu=qw/A T C/;
                        $dna1[$loc]=$nu[rand @nu];
                }
		if ($dna1[$loc]=~/C/){
                        my @nu=qw/A T G/;
                        $dna1[$loc]=$nu[rand @nu];
                }
	}
	elsif($change eq "d"){ 
		splice @dna1, $loc,1;
	}
	$dna_length_1=scalar(@dna1);
	$j++;
}
print F1 ">S2","\n",@dna1,"\n";
my @dna2=@dna;
my $dna_length_2=scalar(@dna2);
while($h<$change_length){
        my $loc= int(rand($dna_length_2));
        my @choice= qw/m d/;
        my $change= $choice[rand @choice];
        if ($change eq "m"){	
	        if ($dna1[$loc]=~/A/){
                        my @nu=qw/T G C/;
                        $dna1[$loc]=$nu[rand @nu];
                }
                if ($dna1[$loc]=~/T/){
                        my @nu=qw/A G C/;
                        $dna1[$loc]=$nu[rand @nu];
                }
                if ($dna1[$loc]=~/G/){
                        my @nu=qw/A T C/;
                        $dna1[$loc]=$nu[rand @nu];
                }
                if ($dna1[$loc]=~/C/){
                        my @nu=qw/A T G/;
                        $dna1[$loc]=$nu[rand @nu];
                }
        }
        elsif($change eq "d"){
                splice @dna2, $loc,1;
        }
	$dna_length_2=scalar(@dna2);
        $h++;
}
print F2 ">S3","\n",@dna2,"\n";
exit;
	
