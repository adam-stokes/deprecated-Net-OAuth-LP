#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use Mojo::Base -strict;
use 5.14.0;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;
use Net::OAuth::LP::Model;
use List::AllUtils qw(first);

use DDP;

my $c = Net::OAuth::LP::Client->new;
if (   defined($ENV{LP_CONSUMER_KEY})
    && defined($ENV{LP_ACCESS_TOKEN})
    && defined($ENV{LP_ACCESS_TOKEN_SECRET}))
{
    $c->consumer_key($ENV{LP_CONSUMER_KEY});
    $c->access_token($ENV{LP_ACCESS_TOKEN});
    $c->access_token_secret($ENV{LP_ACCESS_TOKEN_SECRET});
}

# Set whether we want staging or not
$c->staging(0);

p $c;

my $model = Net::OAuth::LP::Model->new($c);

p $model;

my $bug = $model->namespace('Bug')->by_id($ENV{LP_BUG});

say "Bug representation";

p $bug;

p $bug->tasks;

p $bug->date_created;

p $bug->watches;

my $bugtask =
  first { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ } @{$bug->tasks};

# p $bugtask;

my $person = $model->namespace('Person')->by_name('~adam-stokes');

p $person;

p $person->ppas;
