#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use Mojo::Base -strict;
use 5.14.0;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use List::AllUtils qw(first);

use DDP;

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $bug = $c->namespace('Bug')->by_id(859600);

say "Bug representation";

p $bug;

p $bug->tasks;

p $bug->date_created;

p $bug->watches;

my $bugtask =
  first { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ } @{$bug->tasks};

# p $bugtask;

my $person = $c->namespace('Person')->by_name('~adam-stokes');

p $person;

p $person->ppas;
