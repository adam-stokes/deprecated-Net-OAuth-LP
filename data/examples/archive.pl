#!/usr/bin/env perl
# Launchpad Archive
# Interfaces with LP for administrative work and scheduling of random tasks
#
# Author: Adam Stokes <adam.stokes@ubuntu.com>
# LGPLv2+

use Modern::Perl '2013';
use Net::OAuth::LP::Client;
use Net::OAuth::LP::Archive;

use Data::Dumper;
use File::Spec::Functions;
use YAML qw[LoadFile];
use Carp;

# We're authenticated *hopefully*
# Setup LP client
my $lpc = Net::OAuth::LP::Client->new;

my $q = new Net::OAuth::LP::Archive;
say Dumper($q);

say Dumper($q->archive);
say Dumper(
    $lpc->search(
        $q->archive->{self_link},
        {'ws.op' => 'getPublishedBinaries',
	'pocket' => 'Release',
	'status' => 'Published'}
    )
);
1;
