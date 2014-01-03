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
p $c;
# $c->staging(1);

# my $bug = Net::OAuth::LP::Model::Bug->new(c => $c, resource => '859600');
# my $person =
#   Net::OAuth::LP::Model::Person->new(c => $c, resource => '~adam-stokes');

#$c->get_bug(859600);
p $c;
# my $bugtask = $bug->tasks->entries->first(
#     sub { $_->{bug_target_name} =~ /ubuntu-advantage|(Ubuntu)/ });
# $bug->{target_name} = $bugtask->{bug_target_name};
# $bug->{status}      = $bugtask->{status};
# $bug->{importance}  = $bugtask->{importance};
# $bug->title($bugtask->{title});

# p $bug;


