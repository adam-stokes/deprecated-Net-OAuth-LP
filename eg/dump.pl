#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use strictures 1;
use v5.16;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Models::Bug;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $bug = Net::OAuth::LP::Models::Bug->new(c => $c, resource => '859600');
my $person = Net::OAuth::LP::Models::Person->new(c => $c, resource => '~adam-stokes');
pp($person->fetch);


