#!/usr/bin/perl -w
#use lib './Net-Twitter-1.18/lib/';
use strict;
use warnings;
use URI::Escape;
#use HTML::Entities;
use Encode;
use Carp;
use Data::Dumper;
use Net::Twitter;
use File::HomeDir;
use Term::ReadLine;
#use Term::Prompt;
use YAML;
use Getopt::Long;
use Term::ReadLine;

#&readline_test;
#&main2;
#exit;
&main;
exit;

sub main2
{
	my %opts = ();
	GetOptions(\%opts, 'command=s','verbose', 'name=s');
	if ($opts{command}) {
		print $opts{command};
		print "\n";
	}
	if ($opts{verbose}) {
		print "Hello, $opts{name}.\n";
	} else {
		print "Hi, $opts{name}.\n";
	}
}

sub readline_test
{
	while (<STDIN>) {
		chomp;
		printf "\033[1;36m%s ?\033[0m ", $_;
		print;
		print "\n";
		if(m/quit/){
			last;
		}
	}
	return;
}

sub main
{
	my $prompt = '';
	my %cmds = %{&command()};
	my $term = new Term::ReadLine 'my_term';
	my $OUT = $term->OUT || \*STDOUT;
	#print $OUT "$OUT\n";
	my $attribs = $term->Attribs;
	$attribs->{completion_function} = sub {
		my ($text, $line, $start) = @_;
		return sort keys %cmds;
	};
	#$attribs->{term_set} = ['', '', '', ''];
	#$attribs->{completion_entry_function} = $attribs->{list_completion_function};
	#$attribs->{completion_word} = [qw(test exit quit reference to a list of words which you want to use for completion)];
	#print $OUT &Dumper($attribs);
	#print $OUT $attribs->{term_set}->[0];
	#print $OUT unpack("H*","\001\033[1;33m\002")."\n";
	#print $OUT unpack("H*",$attribs->{term_set}->[0])."\n";
	#print $OUT unpack("H*",$attribs->{term_set}->[1])."\n";
	#print $OUT unpack("H*",$attribs->{term_set}->[2])."\n";
	#print $OUT unpack("H*",$attribs->{term_set}->[3])."\n";
	#my $config = &call_su($term);
	#my $twit =  Net::Twitter->new(
	#	username  => $config->{username},
	#	password  => $config->{password},
	#);
	my $twit =  Net::Twitter->new(
		username=>'',
		password=>'',
	);
	#my $twit =  Net::Twitter->new();
	#print $OUT &Dumper($twit);
	my $config = &call_su($term,$twit);
	$prompt = $twit->{username};
	$prompt .= '@twitter.com:~';
	while ( defined ($_ = $term->readline(&color_prompt($prompt)))) {
		#print $OUT "$_\n";
		s/\s*$//;
		#m/\s*(\S+)\s+(\S+)/;
		#if(defined $1){
		#print "$1\n";
		#}
		#if(defined $2){
		#print "$2\n";
		#}
		if( $twit->can($_) ){
			$cmds{$_}($term,$twit);
		}elsif(exists $cmds{$_}) {
			$cmds{$_}($term,$twit);
		} else {
			#$cmds{help}($term,$twit);
		}
		#print "\n";
		$prompt = $twit->{username};
		$prompt .= '@twitter.com:~';
	}
}

sub command
{
	return {
		update => \&call_update,
		update_twittervision => \&call_update_twittervision,
		show_status => \&call_show_status,
		destroy_status => \&call_destroy_status,
		user_timeline => \&call_user_timeline,
		public_timeline => \&call_public_timeline,
		friends_timeline => \&call_friends_timeline,
		replies => \&call_replies,
		friends => \&call_friends,
		followers => \&call_followers,
		featured => \&call_featured,
		show_user => \&call_show_user,
		direct_messages => \&call_direct_messages,
		sent_direct_messages => \&call_sent_direct_messages,
		new_direct_message => \&call_new_direct_message,
		destroy_direct_message => \&call_destroy_direct_message,
		verify_credentials => \&call_verify_credentials,
		end_session => \&call_end_session,
		archive => \&call_archive,
		update_location => \&call_update_location,
		update_profile_colors => \&call_update_profile_colors,
		update_profile_image => \&call_update_profile_image,
		update_profile_background_image => \&call_update_profile_background_image,
		update_delivery_device => \&call_update_delivery_device,
		favorites => \&call_favorites,
		create_favorite => \&call_create_favorite,
		destroy_favorite => \&call_destroy_favorite,
		enable_notifications => \&call_enable_notifications,
		disable_notifications => \&call_disable_notifications,
		rate_limit_status => \&call_rate_limit_status,
		create_friend => \&call_create_friend,
		destroy_friend => \&call_destroy_friend,
		relationship_exists => \&call_relationship_exists,
		create_block => \&call_create_block,
		destroy_block => \&call_destroy_block,
		test => \&call_test,
		downtime_schedule => \&call_downtime_schedule,
		trends => \&call_trends,
		search => \&call_search,
		help => \&help,
		useradd => \&call_useradd,
		userdel => \&call_userdel,
		su => \&call_su,
		exit => \&exit,
	};
}

#######################################################################
## Status methods
#######################################################################

sub call_update
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update,
		parameter => [
			{
				status => '',
				in_reply_to_status_id => '',
			},
		],
		setting => [
			{
				status => {
					default => scalar localtime(),
					prompt => 'status',
					description => "What are you doing now?",
				},
				in_reply_to_status_id => {
					default => '',
					prompt => 'in_reply_to_status_id',
					description => "in_reply_to_status_id",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

sub call_update_twittervision
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_twittervision,
		parameter => [ '' ],
		setting => [
			{
				default => '精神と時の部屋',
				prompt => 'location',
				description => "where are you",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &Dumper($res);
	#printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

sub call_show_status
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::show_status,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'a single tweet ID',
				description => "show status ID",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

sub call_destroy_status
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::destroy_status,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'a single tweet ID',
				description => "remove twitte ID",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

sub call_user_timeline
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::user_timeline,
		parameter => [
			{
				id => '',
				since => '',
				since_id => '',
				count => '',
				page => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'id',
					description => "user ID",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "since",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "since_id",
				},
				count => {
					default => '',
					prompt => 'count <= 200',
					description => "count",
				},
				page => {
					default => '',
					prompt => 'page',
					description => "page",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	#&print_single_user($field,${$res}[0]);
	return;
}

sub call_public_timeline
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::public_timeline,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'twitte ID',
				description => "only statuses greater than this twitte ID",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &Dumper($res);
	for (@{$res}) {
		&print_single_tweet($field,$_);
=cut
		printf $OUT &sprint_single_tweet($_);
		my $id = $_->{in_reply_to_status_id};
		while ( defined $id ) {
			my $twit = $field->{twitter};
			my $res = $twit->show_status($id);
			printf $OUT &sprint_single_tweet($res);
			$id = $res->{in_reply_to_status_id};
		}
=cut
	}
	return;
}

sub call_friends_timeline
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::friends_timeline,
		parameter => [
			{
				id => '',
				since => '',
				since_id => '',
				count => '',
				page => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'id',
					description => "user ID",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "since",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "since_id",
				},
				count => {
					default => '200',
					prompt => 'count <= 200',
					description => "count",
				},
				page => {
					default => '',
					prompt => 'page',
					description => "page",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (reverse @{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

sub call_replies
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::replies,
		parameter => [
			{
				page => '' ,
				since => '' ,
				since_id => '',
			},
		],
		setting => [
			{
				page => {
					default => '',
					prompt => 'reply page number',
					description => "give a reply page number",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "Narrows the returned results to just those replies created after the specified HTTP-formatted date",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "Returns only statuses with an ID greater than (that is, more recent than) the specified ID",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	#print $OUT &Dumper($field);
	return;
}

#######################################################################
## User methods
#######################################################################

sub call_friends
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::friends,
		parameter => [
			{
				id => '',
				page => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'id',
					description => "user ID",
				},
				page => {
					default => 0,
					prompt => 'page',
					description => "the other user ID",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		printf $OUT &sprint_single_user($_);
	}
	return;
}

sub call_followers
{
	my $term = shift;
	my $twit = shift;
	my $res = $twit->followers();
	my $OUT = $term->OUT || \*STDOUT;
	print $OUT &Dumper($res);
	for (@{$res}) {
		printf $OUT &sprint_single_user($_);
	}
	return;
}

sub call_featured
{
	############### failure
	my $term = shift;
	my $twit = shift;
	my $res = $twit->featured();
	my $OUT = $term->OUT || \*STDOUT;
	print $OUT &Dumper($res);
	for (@{$res}) {
		printf $OUT &sprint_single_user($_);
	}
	return;
}

sub call_show_user
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::show_user,
		parameter => [
			{
				id => '',
				email => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'id',
					description => "user ID",
				},
				email => {
					default => '',
					prompt => 'email',
					description => "user's email",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

#######################################################################
## Direct Message methods
#######################################################################

sub call_direct_messages
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::direct_messages,
		parameter => [
			{
				page => '',
				since => '',
				since_id => '',
			}
		],
		setting => [
			{
				page => {
					default => '',
					prompt => 'page',
					description => "page",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "since",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "since_id",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

sub call_sent_direct_messages
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::sent_direct_messages,
		parameter => [
			{
				page => '',
				since => '',
				since_id => '',
			}
		],
		setting => [
			{
				page => {
					default => '',
					prompt => 'page',
					description => "page",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "since",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "since_id",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

sub call_new_direct_message
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::new_direct_message,
		parameter => [
			{
				user => '',
				text => '',
			}
		],
		setting => [
			{
				user => {
					default => '',
					prompt => 'screen name or ID',
					description => "user",
				},
				text => {
					default => '',
					prompt => 'message text',
					description => "text",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		#&print_single_tweet($field,$_);
	#}
	print $OUT &Dumper($res);
	return;
}

sub call_destroy_direct_message
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::destroy_direct_message,
		parameter => [ '' ],
		setting => [
			{
				default => '1456789',
				prompt => 'twitte ID',
				description => "twitte ID",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

#######################################################################
## Friendship methods
#######################################################################

sub call_create_friend
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::create_friend,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'making friendship user ID',
				description => "give a user ID to make friendship with",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_destroy_friend
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::destroy_friend,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'breaking friendship user ID',
				description => "give a user ID to break friendship with",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_relationship_exists
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::relationship_exists,
		parameter => [ '', '' ],
		setting => [
			{
				default => '',
				prompt => 'user_a',
				description => "one user ID",
			},
			{
				default => '',
				prompt => 'user_b',
				description => "the other user ID",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &Dumper($res);
	return;
}

#######################################################################
## Account methods
#######################################################################


sub call_verify_credentials
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->verify_credentials();
	printf $OUT &Dumper($res);
	return;
}

sub call_end_session
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->end_session();
	printf $OUT &Dumper($res);
	return;
}

sub call_archive
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::archive,
		parameter => [
			{
				page => '',
				since => '',
				since_id => '',
			}
		],
		setting => [
			{
				page => {
					default => '',
					prompt => 'page',
					description => "page",
				},
				since => {
					default => '',
					prompt => 'since',
					description => "since",
				},
				since_id => {
					default => '',
					prompt => 'since_id',
					description => "since_id",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

sub call_update_location
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_location,
		parameter => [ '' ],
		setting => [
			{
				default => '精神と時の部屋',
				prompt => 'location',
				description => "where are you",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_update_delivery_device
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_delivery_device,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'sms, im, or none',
				description => "Sets which device Twitter delivers updates",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_update_profile_colors
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_profile_colors,
		parameter => [
			{
				profile_background_color => '',
				profile_text_color => '',
				profile_link_color => '',
				profile_sidebar_fill_color => '',
				profile_sidebar_border_color => '',
			}
		],
		setting => [
			{
				profile_background_color => {
					default => '9AE4E8',
					prompt => 'backgroud_color',
					description => "",
				},
				profile_text_color => {
					default => '333333',
					prompt => 'text_color',
					description => "",
				},
				profile_link_color => {
					default => '0084B4',
					prompt => 'link_color',
					description => "",
				},
				profile_sidebar_fill_color => {
					default => 'DDFFCC',
					prompt => 'sidebar_fill_color',
					description => "",
				},
				profile_sidebar_border_color => {
					default => 'BDDCAD',
					prompt => 'sidebar_border_color',
					description => "",
				},
			}
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_update_profile_image
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_profile_image,
		parameter => [
			{
				image => '',
			},
		],
		setting => [
			{
				image => {
					default => './default_profile_normal.png',
					prompt => 'profile_image',
					description => "",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_update_profile_background_image
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::update_profile_background_image,
		parameter => [
			{
				image => '',
			},
		],
		setting => [
			{
				image => {
					default => './default_profile_bigger.png',
					prompt => 'profile_image',
					description => "",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	printf $OUT &sprint_single_user($res);
	return;
}

sub call_rate_limit_status
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->rate_limit_status();
	printf $OUT &Dumper($res);
	return;
}

#######################################################################
## Favorite methods
#######################################################################

sub call_favorites
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::favorites,
		parameter => [
			{
				id => '',
				page => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'ID or screenname',
					description => "user ID",
				},
				page => {
					default => 1,
					prompt => '1 <= page',
					description => "get page number",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
	}
	return;
}

sub call_create_favorite
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::create_favorite,
		parameter => [
			{
				id => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'tweet message ID',
					description => "tweet message ID",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
#	printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

sub call_destroy_favorite
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::destroy_favorite,
		parameter => [
			{
				id => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'tweet message ID',
					description => "tweet message ID",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#printf $OUT &sprint_single_tweet($res);
		&print_single_tweet($field,$res);
	return;
}

#######################################################################
## Notification methods
#######################################################################

sub call_enable_notifications
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::enable_notifications,
		parameter => [
			{
				id => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'screen name',
					description => "screen name",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#for (@{$res}) {
		printf $OUT &sprint_single_user($res);
	#}
	return;
}

sub call_disable_notifications
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::disable_notifications,
		parameter => [
			{
				id => '',
			}
		],
		setting => [
			{
				id => {
					default => '',
					prompt => 'screen name',
					description => "screen name",
				},
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	#for (@{$res}) {
		printf $OUT &sprint_single_user($res);
	#}
	return;
}

#######################################################################
## Block methods
#######################################################################

sub call_create_block
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::create_block,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'blocking user ID',
				description => "give a user ID to block",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	return;
}

sub call_destroy_block
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::destroy_block,
		parameter => [ '' ],
		setting => [
			{
				default => '',
				prompt => 'unblocking user ID',
				description => "give a user ID to unblock",
			},
		],
	};
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	my $res = &twitter_function2($field);
	return;
}


#######################################################################
## Help methods
#######################################################################

sub call_test
{
	############### fainure
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->test();
	printf $OUT &Dumper($res);
	return;
}

sub call_downtime_schedule
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->downtime_schedule();
	printf $OUT &Dumper($res);
	return;
}

#######################################################################
## search methods
#######################################################################

sub call_trends
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res = $twit->trends();
	#$res = &decode_entities($res);
	#printf $OUT &Dumper($res);
	printf $OUT &sprint_trends($res);
	return;
}

sub call_search
{
	my $field = {
		terminal => shift,
		twitter => shift,
		function => \&Net::Twitter::search,
		parameter => [
			{
				word => '',
				from => '',
				to => '',
				'@' => '',
				'#' => '',
				'lang' => '',
				'rpp' => '',
				'page' => '',
				'since_id' => '',
				'geocode' => '',
				'show_user' => '',
			},
		],
		setting => [
			{
				word => {
					default => '',
					prompt => 'word',
					description => 'word',
				},
				from => {
					default => '',
					prompt => 'from a user',
					description => 'from',
				},
				to => {
					default => '',
					prompt => 'to a user',
					description => 'to',
				},
				'@' => {
					default => '',
					prompt => 'referencing a user',
					description => 'referencing a user',
				},
				'#' => {
					default => '',
					prompt => 'containing a hashtag',
					description => 'containing a hashtag',
				},
				'lang' => {
					default => '',
					prompt => 'lang ja or en',
					description => 'lang',
				},
				'rpp' =>{
					default => '',
					prompt => 'rpp <= 100',
					description => 'rpp',
				},
				'page' => {
					default => '',
					prompt => 'page',
					description => 'page',
				},
				'since_id' => {
					default => '',
					prompt => 'since_id',
					description => 'since_id',
				},
				'geocode' => {
					default => '',
					prompt => 'geocode',
					description => 'geocode',
				},
				'show_user' => {
					default => '',
					prompt => 'show_user',
					description => 'show_user',
				},
			},
		],
	};
	my $res = &twitter_function2($field);
	&print_search($field,$res);
	return;
}

sub print_search
{
	my $field = shift;
	my $res = shift;
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	#print $OUT &Dumper($res);
	for (@{$res->{results}}) {
		my $tmp = '';
		#printf $OUT &sprint_single_tweet($_);
		#&print_single_tweet($field,$_);
		#$tmp .= sprintf "%s ", &color_created_at($_->{created_at});
		$tmp .= sprintf "%s ", &color_id($_->{id});
		$tmp .= sprintf "%s ", &color_screen_name($_->{from_user});
		#$tmp .= sprintf "%s ", &color_screen_name($single_tweet->{in_reply_to_status_id});
		$tmp .= sprintf "%s\n", &color_text($_->{text});
		printf $OUT $tmp;
	}
	return;
}

#######################################################################
## original functions
#######################################################################

sub help
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	#print $OUT join(' ', sort keys %cmds); 
	print $OUT "\n";
	return;
}

sub call_su
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $args = {
		function => \&su,
		parameter => [
			{
				username => '',
			},
		],
		setting => [
			{
				username => {
					default => 'username',
					prompt => 'username',
					description => "username",
				},
			},
		],
	};
	my $res = &call_function($args);
	print $OUT &Dumper($res);
	#print $OUT &Dumper($twit);
	$twit->{username} = $res->{username};
	$twit->{password} = $res->{password};
	$twit->credentials(
		$res->{username},
		$res->{password},
	);
	#$twit = Net::Twitter->new(
	#	username=>$res->{username},
	#	password=>$res->{password},
	#);
	#print $OUT &Dumper($twit);
	return;
}

sub call_userdel
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $args = {
		function => \&userdel,
		parameter => [
			{
				username => '',
			},
		],
		setting => [
			{
				username => {
					default => 'username',
					prompt => 'username',
					description => "username",
				},
			},
		],
	};
	my $res = &call_function($args);
	print $OUT &Dumper($res);
	return;
}

sub call_useradd
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $args = {
		function => \&useradd,
		parameter => [
			{
				username => '',
				password => '',
			},
		],
		setting => [
			{
				username => {
					default => 'username',
					prompt => 'username',
					description => "username",
				},
				password => {
					default => 'pasword',
					prompt => 'password',
					description => "password",
				},
			},
		],
	};
	my $res = &call_function($args);
	print $OUT &Dumper($res);
	return;
}

sub su
{
	my $args = shift;
	my $save = 0;
	#my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter");
	my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter/.twitter");
	my $config = eval { YAML::LoadFile($path) } || {};
	my $res;

	foreach (@$config){
		if($_->{username} eq $args->{username}){
			$res->{username} = $_->{username};
			$res->{password} = $_->{password};
		}
	}
	return $res;
}

sub useradd
{
	my $args = shift;
	my $save = 0;
	#my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter");
	my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter/.twitter");
	my $config = eval { YAML::LoadFile($path) } || {};

	if('ARRAY' ne ref $config){
		$config = [];
	}
	foreach (@$config){
		if($_->{username} ne $args->{username}){
			$save++;
		}
	}
	if( $save == scalar @$config){
		push @$config, $args;
		YAML::DumpFile($path, $config);
		chmod 0600, $path;
	}
	return $config;
}

sub userdel
{
	my $args = shift;
	my $save = 0;
	#my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter");
	my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter/.twitter");
	my $config_old = eval { YAML::LoadFile($path) } || {};
	my $config_new = [];

	if('ARRAY' ne ref $config_old){
		$config_new = [];
	}else{
		foreach (@$config_old){
			if($_->{username} ne $args->{username}){
				push @$config_new, $_;
			}
		}
	}
	YAML::DumpFile($path, $config_new);
	chmod 0600, $path;
	return $config_new;
}

sub exit
{
	exit;
}

#######################################################################
## wrapper functions
#######################################################################

sub call_function
{
	my $args = shift;
	my $res = '';
	my $function = $args->{function};
	my $parameter = $args->{parameter};
	my $setting = $args->{setting};
	my $default = '';
	my $value = '';
	my $prompt = '';
	my $description = '';
	my $term = new Term::ReadLine 'call_function_term';
	my $OUT = $term->OUT || \*STDOUT;
	my $i = 0;
	for ($i=0; $i<scalar @$parameter; $i++) {
		foreach (keys %{$parameter->[$i]}) {
			#my $tmp = $setting->[$i]->{$_};
			$default = $setting->[$i]->{$_}->{default};
			$prompt = $setting->[$i]->{$_}->{prompt};
			$description = $setting->[$i]->{$_}->{description};
			$value = $term->readline(&color_prompt("hash: $prompt [$default]"));
			if ($value ne ''){
				$parameter->[$i]->{$_} = $value;
			}else{
				$parameter->[$i]->{$_} = $default;
			}
			if ($parameter->[$i]->{$_} eq '') {
				undef $parameter->[$i]->{$_};
			}else{
				printf $OUT "$parameter->[$i]->{$_}\n";
			}
		}
	}
	#print "callfunction\n";
	$res = &$function(@$parameter);
	return $res;
}

sub twitter_function2
{
	my $field = shift;
	my $function = $field->{function};
	my $parameter = $field->{parameter};
	my $terminal = $field->{terminal};
	my $twitter = $field->{twitter};
	my $setting = $field->{setting};
	my $default = '';
	my $value = '';
	my $prompt = '';
	my $description = '';
	my $OUT = $terminal->OUT || \*STDOUT;
	my $res;
	my $i = 0;
	for ($i=0; $i<scalar @$parameter; $i++) {
		if('HASH' eq ref $parameter->[$i]){
			foreach (keys %{$parameter->[$i]}) {
				#my $tmp = $setting->[$i]->{$_};
				$default = $setting->[$i]->{$_}->{default};
				$prompt = $setting->[$i]->{$_}->{prompt};
				$description = $setting->[$i]->{$_}->{description};
				$value = $terminal->readline(&color_prompt("hash: $prompt [$default]"));
				if ($value ne ''){
					$parameter->[$i]->{$_} = $value;
				}else{
					$parameter->[$i]->{$_} = $default;
				}
				if ($parameter->[$i]->{$_} eq '') {
					undef $parameter->[$i]->{$_};
					delete $parameter->[$i]->{$_};
				}else{
					printf $OUT $parameter->[$i]->{$_}."\n";
				}
			}
		}else{
			$default = $setting->[$i]->{default};
			$prompt = $setting->[$i]->{prompt};
			$description = $setting->[$i]->{description};
			$value = $terminal->readline(&color_prompt("scalar $i: $prompt [$default]"));
			if ($value ne ''){
				$parameter->[$i] = $value;
			}else{
				$parameter->[$i] = $default;
			}
			if ($parameter->[$i] eq '') {
				undef $parameter->[$i];
			}else{
				printf $OUT "$parameter->[$i]\n";
			}
		}
	}
	#print $OUT &Dumper(@tmp2);
	#print $OUT &Dumper(@$parameter);
	$res = $twitter->$function(@$parameter);
	#$res = $twitter->$function(@$parameter);
	print $OUT &Dumper($res);
	#print $OUT &Dumper($twitter);
	return $res;
}

#######################################################################
## configuration functions
#######################################################################

sub configuration
{
	my $term = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $path   = File::Spec->catfile(File::HomeDir->my_home, ".twitter");
	my $config = eval { YAML::LoadFile($path) } || {};
	my $attribs = $term->Attribs;

	my $save = 0;
	while (!$config->{username} || !$config->{password}) {
		$config->{username} = $term->readline('username: ');
		my $redisplay = $attribs->{redisplay_function};
		$attribs->{redisplay_function} = $attribs->{shadow_redisplay};
		$config->{password} = $term->readline('password: ');
		$attribs->{redisplay_function} = $redisplay;
		$save++;
	}

	YAML::DumpFile($path, $config) if $save != 0;
	chmod 0600, $path;

	return $config;
}


#######################################################################
## formatted print functions
#######################################################################

sub print_single_user
{
	my $field = shift;
	my $res = shift;
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	printf $OUT &sprint_single_user($res);
}

sub print_single_tweet
{
	my $field = shift;
	my $res = shift;
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	printf $OUT &sprint_single_tweet($res);
}

sub print_single_tweet2
{
	my $field = shift;
	my $res = shift;
	my $OUT = $field->{terminal}->OUT || \*STDOUT;
	printf $OUT &sprint_single_tweet($res);
	my $id = $res->{in_reply_to_status_id};
	while ( defined $id ) {
		my $single_tweet = $field->{twitter}->show_status($id);
		printf $OUT "+";
		printf $OUT &sprint_single_tweet($single_tweet);
		$id = $single_tweet->{in_reply_to_status_id};
	}
}

sub sprint_trends
{
	my $trends = shift;
	my $res = '';
	if (defined $trends) {
		foreach (@{$trends->{trends}}){
			$res .= sprintf "%s ", &color_url($_->{url});
			$res .= sprintf "%s\n", &color_name($_->{name});
		}
	}
	return $res;
}

sub sprint_single_tweet
{
	my $single_tweet = shift;
	my $res = '';
	if (defined $single_tweet) {
		#$res .= sprintf "%s ", &color_created_at($single_tweet->{created_at});
		$res .= &color_id($single_tweet->{id});
		$res .= ' ';
		$res .= &color_screen_name($single_tweet->{user}{screen_name});
		$res .= ' ';
		#$res .= sprintf "%s ", &color_screen_name($single_tweet->{in_reply_to_status_id});
		$res .= &color_text($single_tweet->{text});
		$res .= "\n";
	}
	return $res;
}

sub sprint_single_user
{
	my $single_user = shift;
	my $res = '';
	if (defined $single_user) {
		#$res .= sprintf "%s ", &color_created_at($single_user->{status}{created_at});
		$res .= &color_id($single_user->{status}{id});
		$res .= ' ';
		$res .= &color_screen_name($single_user->{screen_name});
		$res .= ' ';
		$res .= &color_description($single_user->{description});
		$res .= "\n";
		$res .= &color_text($single_user->{status}{text});
		$res .= "\n";
	}
	return $res;
}

#######################################################################
## Colored functions
#######################################################################

sub color_prompt
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	#$str = sprintf "\033[1;36m%s ?\033[0m ", $str;
	#$str = sprintf "\033[1;36m%s ? ", $str;
	#$str = sprintf pack('C*', '27')."\033[1;36m%s ?".pack('C*', '27')."\033[0m ", $str;
	#$str = sprintf "\001\033[1;36m\002%s\$\001\033[0m\002 ", $str;
	$str = "\001\033[1;36m\002".$str."\$\001\033[0m\002 ";
	#$str = "\033[1;36m".$str."\033[1;0m";
	#$str = sprintf "\\[\033[1;34m\\]%s ?\\[\033[0m\\] ", $str;
	return $str;
}

sub color_text
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str =~ s/%/%%/g;
	$str = encode('utf-8', $str);
	return $str;
}

sub color_created_at
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	$str = "\033[0;35m".$str."\033[0;0m";
	return $str;
}

sub color_description
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	$str = "\033[0;34m".$str."\033[0;0m";
	return $str;
}

sub color_screen_name
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	$str = "\033[0;33m".$str."\033[0;0m";
	return $str;
}

sub color_id
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	$str = "\033[0;32m".$str."\033[0;0m";
	return $str;
}

sub color_name
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = encode('utf-8', $str);
	$str = "\033[1;31m".$str."\033[0;0m";
	return $str;
}

sub color_url
{
	my $str = shift;
	if( !defined $str){
		$str = '';
	}
	$str = &uri_unescape($str);
	$str = encode('utf-8', $str);
	$str = "\033[1;30m".$str."\033[0;0m";
	return $str;
}

__END__
sub call_update
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $status = '';
	while( defined ($status = $term->readline("status ? "))){
		if($status ne ''){
			print $OUT "$status\n";
			$twit->update($status);
		}else{
			last;
		}
	}
	return;
}

sub call_update_old
{
	my $term = shift;
	my $twit = shift;
	&call_twitter_function1($term,$twit,\&Net::Twitter::update,"status");
	return;
}


sub call_show_status_old
{
	my $term = shift;
	my $twit = shift;
	&call_twitter_function1($term,$twit,\&Net::Twitter::show_status,"ID");
	return;
}

sub test
{
	my $status;
	while( defined ($status = $term->readline("status :"))){
		if($status ne ''){
			print $OUT "$status\n";
		}else{
			last;
		}
	}
	return;
}

sub call_create_block_old
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $field = {
		id => '',
	};
	my $res = &call_twitter_function1($term,$twit,\&Net::Twitter::create_block,"id");
	printf $OUT &Dumper($res);
	return;
}

sub call_destroy_block_old
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $field = {
		id => '',
	};
	my $res = &call_twitter_function1($term,$twit,\&Net::Twitter::destroy_block,"id");
	printf $OUT &Dumper($res);
	return;
}

sub call_create_friend_old
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $field = {
		id => '',
	};
	my $res = &call_twitter_function1($term,$twit,\&Net::Twitter::create_friend,"id");
	printf $OUT &Dumper($res);
	return;
}

sub call_destroy_friend_old
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $field = {
		id => '',
	};
	my $res = &call_twitter_function1($term,$twit,\&Net::Twitter::destroy_friend,"id");
	printf $OUT &Dumper($res);
	return;
}

sub call_show_user_old
{
	my $term = shift;
	my $twit = shift;
	my $field = {
		id => '',
		email => '',
	};
	my $res = &call_twitter_function($term,$twit,\&Net::Twitter::show_user,$field);
	#my $res = $twit->show_user();
	#&call_twitter_function1($term,$twit,\&Net::Twitter::show_user,"user ID");
	print Dumper($res);
	printf $OUT &sprint_single_user($res);
	return;
	
}

sub call_replies_old
{
	my $term = shift;
	my $twit = shift;
	my $res = $twit->replies();
	print Dumper($res);
	return;
}

sub call_friends_timeline_old
{
	my $term = shift;
	my $twit = shift;
	my $res = $twit->friends_timeline();
	#print "\033[0;34mtwitte id  ";
	#print "\033[0;32mscreen_name ";
	#print "\033[0;36mtext\033[0;0m\n";
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
		#printf "%s ",  encode('utf-8', $_->{id});
		#printf "\033[0;32m%s\033[0;0m ",  encode('utf-8', $_->{user}{screen_name});
		#printf "%s\n",  encode('utf-8', $_->{text});
	}
	return;
}

sub call_public_timeline_old
{
	my $term = shift;
	my $twit = shift;
	my $res = $twit->public_timeline();
	#print Dumper($res);
	#print "\033[0;34mtwitte id  ";
	#print "\033[0;32mscreen_name\t|\t";
	#print "\033[0;36mtext\033[0;0m\n";
	for (@{$res}) {
		#printf $OUT &sprint_single_tweet($_);
		&print_single_tweet($field,$_);
		#printf "%s ",  encode('utf-8', $_->{id});
		#printf "\033[0;32m%s\033[0;0m ",  encode('utf-8', $_->{user}{screen_name});
		#printf "%s\n",  encode('utf-8', $_->{text});
	}
	return;
}

sub call_user_timeline_old
{
	my $term = shift;
	my $twit = shift;
	my $OUT = $term->OUT || \*STDOUT;
	printf $OUT  "this call function is not defind.\n";
	my $field = {
		id => '',
		since => '',
		since_id => '',
		count => '',
		page => '',
	};
	&call_twitter_function($term,$twit,\&Net::Twitter::user_timeline,$field);
	return;
}

sub call_destroy_status_old
{
	my $term = shift;
	my $twit = shift;
	&call_twitter_function1($term,$twit,\&Net::Twitter::destroy_status,"ID");
	return;
}


sub twitter_function
{
	my $field = shift;
	my $function = $field->{function};
	my $parameter = $field->{parameter};
	my $terminal = $field->{terminal};
	my $twitter = $field->{twitter};
	my $setting = $field->{setting};
	my $default = '';
	my $value = '';
	my $prompt = '';
	my $description = '';
	my $OUT = $terminal->OUT || \*STDOUT;
	my $res;
	my $i = 0;
	for ($i=0; $i<scalar @$parameter; $i++) {
		$default = $setting->[$i]->{default};
		$prompt = $setting->[$i]->{prompt};
		$description = $setting->[$i]->{description};
		$value = $terminal->readline(&color_prompt("$prompt [$default]"));
		if ($value ne ''){
			$parameter->[$i] = $value;
		}else{
			$parameter->[$i] = $default;
		}
		printf $OUT "\r$parameter->[$i]\n";
	}
	#printf $OUT &Dumper(@$parameter);
	$res = $twitter->$function(@$parameter);
	return $res;
}

sub call_twitter_function1
{
	my $term = shift;
	my $twit = shift;
	my $func = shift;
	my $prompt = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res;
	while( defined ($_ = $term->readline("\033[1;34m$prompt ? \033[0m"))){
		if($_ ne ''){
			#print $OUT "$_\n";
			#print $OUT &Dumper($twit->$func($_));
			$res = $twit->$func($_);
		}else{
			last;
		}
	}
	return $res;
}

sub call_twitter_function2
{
	my $term = shift;
	my $twit = shift;
	my $func = shift;
	my $prompt = shift;
	my $OUT = $term->OUT || \*STDOUT;
	my $res;
	while( defined ($_ = $term->readline("\033[1;34m$prompt ? \033[0m"))){
		if($_ ne ''){
			#print $OUT "$_\n";
			#print $OUT &Dumper($twit->$func($_));
			$res = $twit->$func($_);
		}else{
			last;
		}
	}
	return $res;
}

sub call_twitter_function
{
	my $term = shift;
	my $twit = shift;
	my $func = shift;
	my $field = shift;
	my $OUT = $term->OUT || \*STDOUT;
	foreach my $key (sort keys %$field){
		while( defined ($_ = $term->readline("\033[1;34m$key ? \033[0m"))){
			if($_ ne ''){
				$field->{$key} = $_;
				#print $OUT "$_\n";
				#print $OUT &Dumper($twit->$func($_));
			}else{
				last;
			}
		}
	}
	print $OUT &Dumper($twit);
	my $res = $twit->$func($field);
	#print $OUT &Dumper($twit->$func($field));
	print $OUT &Dumper($twit);
	print $OUT &Dumper($field);
	#printf $OUT join'',map{$_." = ".$field->{$_}."\n"} keys %$field;
	return $res;
}

