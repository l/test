#!/usr/bin/perl -l
use warnings;
use strict;

main();
exit;

sub main
{
	my $pal = 0;
	my $i = 0;
	for ($i = 100; $i < 1000; $i++) {
		my $j = 0;
		for ($j = $i + 1; $j < 1000; $j++) {
			my $num = $i * $j;
			if (is_palindromic($num) && $pal < $num) {
				$pal = $num;
#				print "$i\t$j\t$num";
			}
		}
	}
	print $pal;
	return 1;
}

sub is_palindromic
{
	my $num = shift;
	my $tmp = join '', reverse split //, $num;
	if ($num eq $tmp) {
		return 1;
	} else {
		return 0;
	}
}
__END__
