#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);
use File::Spec::Functions;

my $client = Net::OAuth::LP::Client->new;
$client->consumer_key('scr4p3r');
$client->login_with_creds;

pp $client;

