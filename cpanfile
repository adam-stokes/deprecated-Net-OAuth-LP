requires 'HTTP::Request';
requires 'HTTP::Request::Common';
requires 'Hash::AsObject';
requires 'JSON';
requires 'LWP::UserAgent';
requires 'List::Objects::WithUtils';
requires 'Method::Signatures';
requires 'Moo';
requires 'Moo::Role';
requires 'Net::OAuth';
requires 'Types::Standard';
requires 'URI';
requires 'URI::Encode';
requires 'URI::QueryParam';
requires 'IO::Socket::SSL';
requires 'LWP::Protocol::https';
requires 'DDP';
requires 'Mojolicious';

on build => sub {
    requires 'Test::More';
};

on test => sub {
    requires 'indirect';
    requires 'multidimensional';
    requires 'bareword::filehandles';
};


