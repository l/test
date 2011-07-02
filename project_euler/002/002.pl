#!/usr/bin/perl -l
use warnings;
use strict;

main();

sub main
{
	my $a_i = 0;
	my $sum = 0;
	my $a_0 = 1;
	$a_i = $a_0;
	if ($a_i % 2 == 0) {
		$sum += $a_i;
	}
	my $a_1 = 2;
	$a_i = $a_1;
	if ($a_i % 2 == 0) {
		$sum += $a_i;
	}
	while ($a_i < 4000000) {
		$a_i = $a_0 + $a_1;
		if ($a_i % 2 == 0) {
			$sum += $a_i;
		}
		$a_0 = $a_1;
		$a_1 = $a_i;
	}
	print $sum;
	return 0;
}

exit;
__END__
