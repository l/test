#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use JSON;
use URI;
use IO::File;
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
