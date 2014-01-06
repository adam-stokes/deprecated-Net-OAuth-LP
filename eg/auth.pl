#!/usr/bin/env perl

use Mojo::Base -strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use v5.14;

my $client = Net::OAuth::LP::Client->new;

$client->staging(1);
$client->consumer_key('cts-pika-bot');
$client->login_with_creds;

say "Consumer key: " . $client->consumer_key;
say "Token: " . $client->access_token;
say "Token secret: ". $client->access_token_secret;

