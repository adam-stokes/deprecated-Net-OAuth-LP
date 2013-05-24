#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Models::Person;
use Data::Dump qw(pp);
use Data::Dumper;
use File::Spec::Functions;
use YAML qw[LoadFile];

my $creds = LoadFile catfile($ENV{HOME}, '.lp-auth.yml');

my $client = Net::OAuth::LP::Models::Person->new(
    consumer_key        => $creds->{consumer_key},
    access_token        => $creds->{access_token},
    access_token_secret => $creds->{access_token_secret}
);

# Use staging setup for now.
# $client->staging(1);

#my $bug  = $client->bug('859600');

my $p = Net::OAuth::LP::Models::Person->new;
$p->staging(1);
$p->find('~adam-stokes');



