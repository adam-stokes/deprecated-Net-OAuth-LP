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
requires 'perl', 'v5.10.0';
requires 'strictures', '1';

on build => sub {
    requires 'Test::More';
};
