#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use strict;
use warnings;
use 5.14.0;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Models::Bug;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $bug = Net::OAuth::LP::Models::Bug->new(c => $c, resource => '859600');
my $person =
  Net::OAuth::LP::Models::Person->new(c => $c, resource => '~adam-stokes');
$bug->fetch;
my $bugtask = $bug->tasks->entries->first(
    sub { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ });
$bug->attrs->{target_name} = $bugtask->{bug_target_name};
$bug->attrs->{status}      = $bugtask->{status};
$bug->attrs->{importance}  = $bugtask->{importance};
$bug->attrs->title($bugtask->{title});

pp($bug->attrs);


