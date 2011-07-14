#!/usr/bin/perl -l
use warnings;
use strict;

main();
exit;

sub main
{
	my $num = 0;
	my $i = 0;
	for($i = 2; $num < 10001; $i++) {
		if (is_prime($i) == 1) {
			print "$num $i";
			$num++;
		}
	}
	return 1;
}

sub is_prime
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

__END__
