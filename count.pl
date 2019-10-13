use warnings;
open F1, "mel-vir-aln.txt";
open F2, ">count.txt";
readline F1;
while ($re=<F1>){	
	chomp($re);
	print F2 length($re),"\n"; 
}

