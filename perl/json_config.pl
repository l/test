#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Data::Dumper;

my $json_file = $ARGV[0] || "passwd.json";
my $perl_data = {username=>"hoge", password=>"fuga" };
print Dumper $perl_data, $json_file;

&encode_json_file($perl_data, $json_file);
print Dumper $perl_data, $json_file;

$perl_data = &decode_json_file($json_file);
print Dumper $perl_data, $json_file;

exit;

sub encode_json_file {
	my $perl_data = shift;
	my $json_file = shift;

	my $json_data = encode_json($perl_data);
	my $fp;
	open $fp, '>', $json_file or die $!;
	print $fp $json_data;
	close $fp;

	return;
}

sub decode_json_file {
	my $json_file = shift;

	my $json_data = '';
	my $fp;
	open $fp, '<', $json_file or die $!;
	{
		local $/ = undef;
		$json_data = <$fp>;
	}
	close $fp;
	$perl_data = decode_json($json_data);

	return $perl_data;
}
__END__
