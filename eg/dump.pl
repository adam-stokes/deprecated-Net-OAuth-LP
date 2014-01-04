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

say "Title: ". $bug->title;
say "Desc:  ". $bug->description;
say "Heat:  ". $bug->heat;
say "Br0ke: ". $bug->bug->{test};

my $person = $c->namespace('Person');
#->by_name('~adam-stokes');
p $person;



#$c->get_bug(859600);
# my $bugtask = $bug->tasks->entries->first(
#     sub { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ });
# $bug->{target_name} = $bugtask->{bug_target_name};
# $bug->{status}      = $bugtask->{status};
# $bug->{importance}  = $bugtask->{importance};
# $bug->title($bugtask->{title});

# p $bug;


