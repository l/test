#!/usr/bin/perl
#
# googlereader_pushfeed.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#
# $ perl googlereader_pushfeed.pl --config ~/.google.json --web 'http://example.com/'
# $ perl googlereader_pushfeed.pl --config ~/.google.json --feed 'http://example.com/feed.xml'
# $ perl googlereader_pushfeed.pl --config ~/.google.json --tag test_tag --pipe --feed 1 < feed.txt
#

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use IO::File;
use JSON;
use URI;
use LWP::UserAgent;
use Web::Scraper;
use WebService::Google::Reader;

#print Dumper @ARGV;
my %opts = ();
GetOptions(\%opts, 'config=s', 'tag=s',  'web=s', 'feed=s', 'pipe');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config = decode_json(join '', $io->getlines);
$io->close;

$config->{debug} = 1;

my $reader = WebService::Google::Reader->new(%$config);

if (!defined $opts{tag} || $opts{tag} eq '') {
	 $opts{tag} = 'pushfeed';
}
#print Dumper %opts;

if (defined $opts{pipe}) {
	if (defined $opts{web}) {
		&pipe($reader, $opts{tag}, \&web);
	} elsif (defined $opts{feed}) {
		&pipe($reader, $opts{tag}, \&feed);
	}
} elsif (defined $opts{web}) {
	web($reader, $opts{tag}, $opts{web});
} elsif (defined $opts{feed}) {
	feed($reader, $opts{tag}, $opts{feed});
} else {
	print "ERROR: --web or --feed or --pipe option is needed.";
}
exit;

sub pipe
{
	my $reader = shift;
	my $tag = shift;
	my $func = shift;
	my $uri = [];
	my $io = IO::File->new;
	$io->fdopen(fileno(STDIN), "r");
	while(my $line = $io->getline) {
		chomp $line;
		print $line, "\n";
#		my $uri = URI->new($line);
		push @{$uri}, $line;
		if (@{$uri} > 30) {
			&$func($reader, $tag, $uri);
			$uri = [];
		}
	}
	$io->close;
	if (@{$uri} > 0) {
		&$func($reader, $tag, $uri);
		$uri = [];
	}
	return;
}

sub web
{
	my $reader = shift;
	my $tag = shift;
	my $uri = URI->new(shift);
	my $scraper = scraper {
		process '/html/head/link', 'link[]' => {
			type => '@type',
			     href => '@href',
		}
	};

	my $ua = new LWP::UserAgent();
	$ua->agent('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; ja-JP-mac; rv:1.9.0.6) Gecko/2009011912 Firefox/3.0.6 GTB5');
	$ua->max_size(1000000);

	$scraper->user_agent($ua);

	my $result;# = $scraper->scrape($uri);
	eval {$result = $scraper->scrape($uri)};
	if ($@) {
		warn $@;
		return 1;
	}

	print Dumper $result;

	foreach (@{$result->{link}}) {
		if (defined $_->{type}) {
			my $type = $_->{type};
			if ($type eq 'application/rss+xml' ||
					$type eq 'application/rdf+xml' ||
# foaf is also rdfformat
					$type eq 'application/atom+xml') {
				my $res = $reader->edit_feed($_->{href}, tag => $tag, subscribe => 1);
#				print Dumper $_, "\n";
#				print Dumper $reader;
				print Dumper $res;
			}
		}
	}
}

sub feed
{
	my $reader = shift;
	my $tag = shift;
	my $uri = shift;
#	my $uri = URI->new(shift);
	my $res = $reader->edit_feed($uri, tag => $tag, subscribe => 1);
	print Dumper $res;
	if (!$res) {
		print Dumper $reader;
		warn $uri;
	}
	return;
}
__END__
