use 5.006;
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name     'Net-OAuth-LP';
all_from 'lib/Net/OAuth/LP.pm';
author   q{=Adam Stokes <adam.stokes@ubuntu.com>};
license  'perl';

perl_version 5.006;

tests_recursive('t');

resources (
   #homepage   => 'http://yourwebsitehere.com',
   #IRC        => 'irc://irc.perl.org/#Net-OAuth-LP',
   license    => 'http://dev.perl.org/licenses/',
   #repository => 'git://github.com/=Adam Stokes/Net-OAuth-LP.git',
   bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-OAuth-LP',
);

configure_requires (
   'Module::Install' => 0,
);

build_requires (
   'Test::More' => 0,
);

requires (
   #'ABC'              => 1.6,
   #'Foo::Bar::Module' => 5.0401,
);

install_as_cpan;
auto_install;
WriteAll;
