#!/usr/bin/perl
use warnings;
use strict;

main();
main0();
exit;

sub main
{
	my $i = 1;
	for ($i = 1; $i <= 1000; $i++) {
		my $j = 0;
		for ($j = 501 - $i; $j <= 1000 - $i; $j++) {
			if (!($i < $j)) {
				last;
			}
			my $a = $i * $j;
			my $b = 1000 * ($i + $j - 500);
#			my $a = $i**2 + $j**2;
#			my $b = (1000 - $i - $j) ** 2;
			if ($a == $b) {
				print "$i\t$j\t";
				print (1000 - $i - $j);
#				print $i**2 + $j**2;
#				print "\t";
#				print ((1000 - $i - $j) ** 2);
				print "\n";
			}
		}
	}
	return 1;
}

sub main0
{
	my $i = 1;
	my $j = 1000 * (500 - $i);
	for ($i = 1; $i <= 333; $i++) {
		if ($j % (1000 - $i) == 0) {
			my $b = $j / (1000 - $i);
			print "$i\t";
			print $b;
			print "\t";
			print (1000 - $i - $b);
			print "\n";
		}
		$j -= 1000;
	}
	return 1;
}
__END__
a^2 + b^2 = c^2
a + b + c = 1000
c = 1000 - a - b
c^2 = 1000^2 + a^2 + b^2 - 2000a - 2000b + 2ab
0 = 1000^2 - 2000a - 2000b + 2ab
2000 (a + b - 500) = 2ab
2^3 * 5^3 * (a + b - 500) = ab

0 = 500 * 1000 - 1000a - 1000b + ab
0 = (500 - a) 1000 - (1000 - a) b
(1000 - a) b = (500 - a) 1000 
b = 1000 (500 - a) / (1000 - a)
