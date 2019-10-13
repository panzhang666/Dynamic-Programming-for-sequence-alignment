use strict;
use warnings;
open (S2, "$ARGV[0]")or die $!;
open (S3, "$ARGV[1]")or die $!;
open (SUB, "$ARGV[2]")or die $!;
open (GAP, "$ARGV[3]")or die $!;
open CP, " > mel-vir-aln.txt ";
my %hash;
my @base;
my @re;
my ($seq1,$seq2,$gap,$diag_score,$left_score,$up_score)=@_;
readline S2;
while(my$re=<S2>){
        chomp($re);
        if ($re=~/^\w+/){
                $seq1.=$re;
        }
}
readline S3;
while(my $in=<S3>){
        chomp($in);
        if ($in=~/^\w+/){
                $seq2.=$in;
        }
}
while(<SUB>){
	chomp;
	@re=split /\t/,$_;
	if ($re[2]=~/^\D$/){
		$base[0]=$re[1];
		$base[1]=$re[2];
                $base[2]=$re[3];
                $base[3]=$re[4];
	}
	else{
		$hash{$re[0]}{$base[0]}=$re[1];
		$hash{$re[0]}{$base[1]}=$re[2];
		$hash{$re[0]}{$base[2]}=$re[3];
		$hash{$re[0]}{$base[3]}=$re[4];
	}
}
while(my $read=<GAP>){
        chomp($read);
        if ($read=~/\d/){
                $gap=$read;
        }
}
my @matrix;
$matrix[0][0]{score}=0;
$matrix[0][0]{pointer}="none";
my $len1 = length($seq1);
my $len2 = length($seq2);
for (my $j=1; $j<=$len1; $j++){
	$matrix[0][$j]{score}=0;
	$matrix[0][$j]{pointer}="none";
}
for (my $i=1; $i<=$len2; $i++){
	$matrix[$i][0]{score}=$gap*$i;
	$matrix[$i][0]{pointer}="up";
}
my $max_i=0;
my $max_j=0;
my $max_score=0;
for (my $i=1;$i<=$len2;$i++){
	for (my$j=1;$j<=$len1;$j++){
		my $letter1 = substr($seq1,$j-1,1);
		my $letter2 = substr($seq2,$i-1,1);
		if (exists $hash{$letter1}{$letter2}){
			$diag_score=$matrix[$i-1][$j-1]{score}+$hash{$letter1}{$letter2};
		}
		$up_score = $matrix[$i-1][$j]{score}+$gap;
       		$left_score = $matrix[$i][$j-1]{score}+$gap;
		if ($diag_score>=$up_score){
			if ($diag_score>=$left_score){
				$matrix[$i][$j]{score}=$diag_score;
				$matrix[$i][$j]{pointer}="diagonal";
			}
			else{
	 			$matrix[$i][$j]{score}=$left_score;
				$matrix[$i][$j]{pointer}="left";
			}
		}
		else {
			if ($up_score>=$left_score){
				$matrix[$i][$j]{score}=$up_score;
				$matrix[$i][$j]{pointer}="up";
			}
			else{
				$matrix[$i][$j]{score}=$left_score;
				$matrix[$i][$j]{pointer}="left";
			}
		}
	}	
}
my$align1="";
my$align2="";
	while(1){
		if ($matrix[$len2][$len1]{pointer} eq "none"){
			last;	
		}
		if ($matrix[$len2][$len1]{pointer} eq "diagonal"){
			$align1.= substr($seq1, $len1 - 1, 1 );
			$align2.= substr($seq2, $len2 - 1, 1 );
			$len2--;
			$len1--;
		}
		elsif($matrix[$len2][$len1]{pointer} eq "left"){
			$align1.=substr($seq1, $len1-1,1);
			$align2.="-";
			$len1--;
		}
		elsif($matrix[$len2][$len1]{pointer} eq "up"){
			$align1.="-";
			$align2.=substr($seq2,$len2-1,1);
			$len2--;
			}
	}
$align1=reverse $align1;
$align2=reverse $align2;
my$score=0;
for(my $c=1;$c<=length($align1);$c++){
	my $letter1 = substr($align1,$c-1,1);
        my $letter2 = substr($align2,$c-1,1);
	if (exists $hash{$letter1}{$letter2}){
        	$score+=$hash{$letter1}{$letter2};
                }
	else{
		$score+=$gap;
	}
}
print CP "The optimal alignment between given sequences has score X=$score.","\n",$align1,"\n","$align2","\n";

