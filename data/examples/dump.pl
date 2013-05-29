#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use strictures 1;
use v5.10;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Models::Bug;
use Net::OAuth::LP::Models::Person;
use Net::OAuth::LP::Client;
use Data::Dump qw(pp);

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $model = Net::OAuth::LP::Models::Bug->new(c => $c);
$model->find('859600');
say $model->bug->title;
my $newbug = $model->tasks->entries->first(sub { $_->{bug_target_name} =~ /(Ubuntu)/ });
pp($newbug);

#pp($bug->watches->entries->all);


