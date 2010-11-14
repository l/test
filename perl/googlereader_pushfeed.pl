#!/usr/bin/perl
#
# googlereader_pushfeed.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#
# $ perl googlereader_pushfeed.pl --config ~/.google.json --web 'http://example.com/'
# $ perl googlereader_pushfeed.pl --config ~/.google.json --feed 'http://example.com/feed.xml'
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
GetOptions(\%opts, 'config=s', 'web=s', 'feed=s');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config = decode_json(join '', $io->getlines);
$io->close;

my $reader = WebService::Google::Reader->new(%$config);

if (defined $opts{web}) {
	&web($reader, $opts{web});
} elsif (defined $opts{feed}) {
	&feed($reader, $opts{feed});
} else {
	print "ERROR: --web or --feed option is needed.";
}
exit;

sub web
{
	my $reader = shift;
	my $uri = URI->new(shift);
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
}

sub feed
{
	my $reader = shift;
	my $uri = URI->new(shift);
	my $res = $reader->edit_feed($uri, tag => 'pushfeed', subscribe => 1);
	print Dumper $reader;
	print Dumper $res;
}
__END__
