#!/usr/bin/env perl
#
# for quick tests only, should not be depended upon for
# proper examples of current api.

use Mojo::Base -strict;
use 5.14.0;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Net::OAuth::LP::Client;

use DDP;

my $c = Net::OAuth::LP::Client->new;
$c->staging(1);

my $bug = $c->namespace('Bug')->by_id(859600);

p $bug;

my $person = $c->namespace('Person')->by_name('~adam-stokes');

p $person;

