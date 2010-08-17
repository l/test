#!/usr/bin/perl
#
# googlereader_pushfeed.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#
# $ perl googlereader_pushfeed.pl --config ~/.google.json --uri 'http://example.com/'
#

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use IO::File;
use JSON;
use URI;
use Web::Scraper;
use WebService::Google::Reader;

my %opts = ();
GetOptions(\%opts, 'config=s', 'uri=s');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config = decode_json(join '', $io->getlines);
$io->close;

my $reader = WebService::Google::Reader->new(%$config);
my $uri = URI->new($opts{uri});
my $scraper = scraper {
	process '/html/head/link', 'link[]' => {
		type => '@type',
		href => '@href',
	}
};

my $result = $scraper->scrape($uri);
print Dumper $result;

foreach (@{$result->{link}}) {
	if (defined $_->{type}) {
		my $type = $_->{type};
		if ($type eq 'application/rss+xml' ||
				$type eq 'application/rdf+xml' ||
				$type eq 'application/atom+xml') {
			my $res = $reader->edit_feed($_->{href}, tag => 'pushfeed', subscribe => 1);
			print Dumper $_, "\n";
			print Dumper $reader;
			print Dumper $res;
		}
	}
}
exit;
__END__
