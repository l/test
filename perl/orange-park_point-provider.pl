#!/usr/bin/perl
#
# orange-park auto provider for obtained points
#
# $ perl orange-park.pl --config orange-park.json --id 1 --point 100
#
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use IO::File;
use JSON;
use WWW::Mechanize;
use Web::Scraper;

my %opts = ();
GetOptions(\%opts, 'config=s', 'id=i', 'point=i');

my $io = IO::File->new();
$io->open($opts{config}, 'r') or die $!;
my $config;
{
	local $/ = undef;
	$config = decode_json($io->getline);
}
$io->close;

my $conf = {};
$conf->{email} = $config->{email} || die 'undefined email';
$conf->{password} = $config->{password} || die 'undefined password';
$conf->{id} = $opts{id} || 0;
$conf->{point} = $opts{point} || 50;

if ($conf->{id} == 0) {
	$conf->{id} = 'cr[0]';
} elsif ($conf->{id} == 1) {
	$conf->{id} = 'cr[1]';
} else {
	die;
}

main($conf);
exit;

sub main
{
	my $conf = shift;
	print Dumper $conf;

	my $scraper = scraper {
		process "/html/body/table[4]/tr/td/div/table/tr/td[3]/center[2]/table[1]/tr/td/table/tr[5]/td[2]", 'point' => 'TEXT';
	};

	my $mech = new WWW::Mechanize(
			autocheck => 1,
			agent => "Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16",
			);
#	my $dump_sub = sub { $_[0]->dump(maxlength => 0); return };
#	$mech->set_my_handler(request_send  => $dump_sub);
#	$mech->set_my_handler(response_done => $dump_sub);

	$mech->get("http://orange-park.jp/");
	$mech->submit_form(
			with_fields => {
			log => $conf->{email},
			passwrd => $conf->{password},
			},
			button => 'lo',
			);
	my $result = $scraper->scrape($mech->content, $mech->uri);
#	print Dumper $result;
	$result->{point} =~ m/\A([0-9]+)/;
	print Dumper $1;

	exit if ($1 < $conf->{point});

	$mech->follow_link(url_regex => qr/assigncredits\.php\Z/i);
	$mech->submit_form(
			with_fields => {
			$conf->{id} => $conf->{point},
			},
			button => 'edit',
			);
	return;
}
__END__
