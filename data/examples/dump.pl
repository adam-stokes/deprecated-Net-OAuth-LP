#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use Data::Dumper;
use File::Spec::Functions;
use YAML qw[LoadFile];

my $creds = LoadFile catfile($ENV{HOME}, '.lp-auth.yml');

my $client = Net::OAuth::LP::Client->new(
    consumer_key        => $creds->{consumer_key},
    access_token        => $creds->{access_token},
    access_token_secret => $creds->{access_token_secret}
);

# Use staging setup for now.
$client->staging(1);

my $bug  = $client->bug('859600');
my @tags = qw[bark othertag];

eval { $client->bug_set_tags($bug, \@tags); };
warn $@ if $@;
