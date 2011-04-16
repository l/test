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
GetOptions(\%opts, 'config=s', 'id=i');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config;
{
	local $/ = undef;
	$config = decode_json($io->getline);
}
$io->close;

print Dumper $config;

my $json  = new JSON;
$json->pretty;
print $json->canonical->encode($config);

my $conf = {};
$conf->{email} = $config->{email} || die 'undefined email';
$conf->{password} = $config->{password} || die 'undefined password';
$conf->{id} = $opts{id} || 0;

main($conf);
exit;

sub main
{
	my $conf = shift;
	return;
}
__END__
