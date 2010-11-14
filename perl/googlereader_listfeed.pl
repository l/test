#!/usr/bin/perl
#
# googlereader_listfeed.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#
# $ perl googlereader_listfeed.pl --config ~/.google.json
#

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use IO::File;
use JSON;
use WebService::Google::Reader;

my %opts = ();
GetOptions(\%opts, 'config=s', 'uri=s');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config = decode_json(join '', $io->getlines);
$io->close;

my $reader = WebService::Google::Reader->new(%$config);
foreach ($reader->feeds) {
	print $_->{id};
	print "\n";
}
exit;
__END__
