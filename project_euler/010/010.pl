#!/usr/bin/perl -l
use warnings;
use strict;

main0();
#main();
exit;

sub main0
{
	my $sum = 0;
	$sum += 2;
	$sum += 3;
	$sum += 5;
	my $i = 0;
	my $k = 0;
	my @I = (1, 5);
	my $j = 0;
	my $j_num = @I;
	kloop: for ($k = 1; ; $k++) {
		for ($j = 0; $j < $j_num; $j++) {
			$I[$j] += 6;
			if (!($I[$j] < 2000000)) {
				last kloop;
			}
			$i = $I[$j];
			if (is_prime0($i) == 1) {
				$sum += $i;
#				print "$i $sum";
			}
		}
	}
#	print "$i $sum";
	print $sum;
	return 1;
}
#142913828922
#
#real    2m14.557s
#user    0m45.067s
#sys     0m0.008s

sub main
{
	my $sum = 0;
	my $i = 0;
	for ($i = 2; $i < 2000000; $i++) {
		if (is_prime($i) == 1) {
			$sum += $i;
			print "$i $sum";
		}
	}
	print "$i $sum";
	return 1;
}
#142913828922
#
#real    2m23.292s
#user    0m47.947s
#sys     0m0.020s

sub is_prime
{
	my $N = shift;
	if ($N == 2) { return 1; }
	if ($N == 3) { return 1; }
	my $tmp = $N % 6;
	if ($tmp == 1) {
		return is_prime0($N);
	} elsif ($tmp == 5) {
		return is_prime0($N);
	} else {
		return 0;
	}
}
#142913828922
#
#real    2m23.292s
#user    0m47.947s
#sys     0m0.020s


sub is_prime0
{
	my $N = shift;
	my $sqrtN = sqrt $N;
	my $i = 0;
	for ($i = 2; $i <= $sqrtN; $i++) {
		if ($N % $i == 0) {
			return 0;
		}
	}
	return 1;
}
#142913828922
#
#real    2m23.961s
#user    0m48.327s
#sys     0m0.012s

__END__
