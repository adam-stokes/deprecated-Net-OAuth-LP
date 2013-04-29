#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Net::OAuth::LP::Client;

my $client = Net::OAuth::LP::Client->new;
print Dumper($client->bug('1'));
