#!/usr/bin/perl -l
use warnings;
use strict;

main();
exit;

sub main
{
	my $N = 100;
	my $result = 0;
	my $sum = 0;
	my $i = 0;
	for ($i = 1; $i <= $N; $i++) {
		$sum += ($i * $i);
	}
	$result = (($N * ($N + 1)) / 2);
	$result *= $result;
	$result = $result - $sum;
	print $result;
	return 0;
}
__END__
