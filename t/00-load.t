#!perl -T
use strict;
use warnings;
use Test::More;
use Test::Mojo;
# Some tests run if we've already authenticated again launchpad.net
# otherwise just some basic testing

use_ok 'Net::OAuth::LP';

done_testing;
