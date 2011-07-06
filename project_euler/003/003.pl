#!/usr/bin/perl -l
use warnings;
use strict;

main();
exit;

sub main
{
	my $N = 600851475143;#600851321316;#13195;#
	my $sqrtN = sqrt $N;
	my $pf = 1;
	my $i = 0;
	for ($i = 2; $i <= $sqrtN; $i++) {
		if ($N % $i == 0 && is_prime($i) == 1) {
			$pf = $i;
		}
	}
	print $pf;
	return 0;
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
