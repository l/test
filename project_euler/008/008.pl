#!/usr/bin/perl -l
use warnings;
use strict;

main();
exit;

sub main
{
	my @str = ();
	while(<>) {
		chomp;
		push @str, split //, $_;
	}
	my $result = 0;
	my $i = 0;
	my $i_num = $#str - 3;
	for ($i = 0; $i < $i_num; $i++) {
		my $j_num = $i + 5;
		my $j = $i;
		my $tmp = $str[$j];
		for ($j = $i + 1; $j < $j_num; $j++) {
			$tmp *= $str[$j];
		}
		if ($tmp > $result) {
			$result = $tmp;
		}
	}
	print $result;
	return 1;
}
__END__
