#!/usr/bin/perl -l
use warnings;
use strict;

main();

sub main
{
	my $sum = 0;
	my $i = 0;
	for($i = 0; $i < 100; $i++) {
		if($i % 3 == 0 || $i % 5 == 0) {
			$sum += $i;
		}
	}
	print $sum;
	return 0;
}

exit;
__END__
