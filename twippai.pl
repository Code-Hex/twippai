#!/usr/bin/perl
use strict;
use warnings;

use URI;
use utf8;
use URI::Escape;
use LWP::Authen::OAuth;
use HTTP::Request::Common;
use Encode qw/encode_utf8/;
use Digest::MD5 qw/md5_hex/;
use Path::Class qw/dir file/;
use JSON::XS qw/decode_json/;

my consumer_key = ''; #Your consumer_key
my consumer_secret = ''; #Your consumer_secret
my access_token = ''; #Your access_token
my access_token_secret = ''; #Your access_token_secret

my $dir = dir('./data');
mkdir $dir unless -f $dir;

my ($count, $i, $id, $url) = (1, 1);
my $query = uri_escape_utf8 '#おっぱい'; #URL_Escape
my $uri = URI->new('https://api.twitter.com/1.1/search/tweets.json');
my @kao = ("( ･ω ･)","(  ･ω )","(    ･)","(     )","(･    )","( ω ･ )");
my $ua = LWP::Authen::OAuth->new(
		oauth_consumer_key => $consumer_key,
        oauth_consumer_secret => $consumer_secret,
        oauth_token => $access_token,
        oauth_token_secret => $access_token_secret
	);

while (1) {
	$uri->query_form(
	q => $query,
	lang => 'ja',
    rpp => 100,
    max_id => $id,
	result_type => 'recent'
	);

	my $res = $ua->request(GET $uri);
	die "Error: ". $res->status_line if $res->is_error;
	my $ref = decode_json($res->content);

	for (@{$ref->{statuses}}){
		$| = 1;
		next unless $_->{entities}{media}[0]{media_url};
		$url = $_->{entities}{media}[0]{media_url};
		print encode_utf8($kao[$i==5? $i=0 : $i++]) . " Downloading... $url [$count]\r";
		my $filename = md5_hex($url) . '.jpg';
		my $filepath = $dir->file($filename);
		$res = $ua->get($url, ':content_file' => $filepath->stringify);
		$id = $_->{id};
		$count++;
	}
	sleep 1;
}