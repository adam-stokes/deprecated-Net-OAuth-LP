#!perl -T
use strict;
use warnings FATAL => 'all';
use YAML qw[LoadFile];
use File::Spec::Functions;
use Test::More;

# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing

BEGIN {
    use_ok('Net::OAuth::LP') || print "Bail\n";
    use_ok('Net::OAuth::LP::Client') || print "Bail out!\n";
}

diag( "Testing Net::OAuth::LP $Net::OAuth::LP::VERSION, Perl $], $^X" );
done_testing();
