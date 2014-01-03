#!/usr/bin/env perl

use Mojo::Base -strict;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);

my $client = Net::OAuth::LP::Client->new;
$client->consumer_key('cts-pika-bot');
$client->login_with_creds;

pp $client;

