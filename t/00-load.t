#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 3;

BEGIN {
    use_ok( 'Net::OAuth::LP' ) || print "Bail out!\n";
    my $lp = Net::OAuth::LP->new;
    ok (defined($lp), 'new() works');
    ok ($lp->consumer_key('mykey') && $lp->consumer_key eq 'mykey', 'consumer_key attr set/get ok');
}

diag( "Testing Net::OAuth::LP $Net::OAuth::LP::VERSION, Perl $], $^X" );
