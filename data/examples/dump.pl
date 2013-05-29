#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use strict;
use warnings;
use v5.10;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Models::Bug;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $bug = Net::OAuth::LP::Models::Bug->new(c => $c);
$bug->find('859600');
my $newbug = $bug->tasks->entries->first(sub { $_->{bug_target_name} =~ /(Ubuntu)/ });
pp($newbug);



