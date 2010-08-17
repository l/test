#!/usr/bin/perl
#
# webservice_client_skeleton.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#
# $ perl webservice_client_skeleton.pl --config ~/.webservice.json
#

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use IO::File;
use JSON;

my %opts = ();
GetOptions(\%opts, 'config=s');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config = decode_json(join '', $io->getlines);
$io->close;

print Dumper $config;
exit;
__END__
