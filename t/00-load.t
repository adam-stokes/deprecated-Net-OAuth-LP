#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::OAuth::LP' ) || print "Bail out!\n";
}

diag( "Testing Net::OAuth::LP $Net::OAuth::LP::VERSION, Perl $], $^X" );
