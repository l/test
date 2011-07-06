#!/usr/bin/perl -l
use warnings;
use strict;
use Data::Dumper;

main();
exit;

sub main
{
	my $result = {};
	my $result2 = 1;
	my $i = 0;
	for ($i = 2; $i <= 20; $i++) {
		my $tmp = int_fact($i);
		while (my ($key, $val) = each %{$tmp}) {
			if (!defined $result->{$key} || $result->{$key} < $val) {
				$result->{$key} = $val;
			}
		}
	}
	while (my ($key, $val) = each %{$result}) {
		$result2 *= $key ** $val;
	}
	print Dumper $result;
	print $result2;
}

sub int_fact
{
	my $N = shift;
	my $sqrtN = sqrt $N;
	my $result;
	my $i = 2;
	for ($i = 2; $i <= $sqrtN; $i++) {
		while ($N % $i == 0) {
			$N = $N / $i;
			$result->{$i}++;
		}
		$sqrtN = sqrt $N;
	}
	if ($N != 1) {
		$result->{$N}++;
	}
	return $result;
}
__END__
2 2^1;
3       3^1;
4 2^2;
5            5^1;
6 2^1 * 3^1;
7                7^1;
8 2^3;
9       3^2;
10 2^1 *     5^1;

2^3 * 3^2 * 5^1 * 7^1
8 * 9 * 5 * 7
40 * 63
2520
