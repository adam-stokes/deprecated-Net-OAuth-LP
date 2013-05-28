package Net::OAuth::LP::Client;

# VERSION

use Moo;
use Method::Signatures;

use HTTP::Request::Common;
use HTTP::Request;
use JSON;
use Data::Dump qw(pp);

use URI::Encode;
use URI::QueryParam;
use URI;
use LWP::UserAgent;

with('Net::OAuth::LP');

method __query_from_hash ($params) {
    my $uri = URI->new;
    for my $param (keys $params) {
        $uri->query_param_append($param, $params->{$param});
    }
    $uri->query;
}

# construct path, if a resource link just provide as is.
method __path_cons ($path) {
    if ($path =~ /^http.*api/) {
        return URI->new("$path", 'https');
    }
    URI->new($self->api_url . "/$path", 'https');
}

method __oauth_authorization_header ($request) {
    my $enc = URI::Encode->new({encode_reserved => 1});
    join(",",
        'OAuth realm="https://api.launchpad.net"',
        'oauth_consumer_key="' . $request->consumer_key . '"',
        'oauth_token="' . $request->token . '"',
        'oauth_signature_method="PLAINTEXT"',
        'oauth_signature="' . $enc->encode($request->signature) . '"',
        'oauth_timestamp="' . $request->timestamp . '"',
        'oauth_nonce="' . $request->nonce . '"',
        'oauth_version="' . $request->version . '"');
}

method _request ($resource, $params, $method) {
    my $ua  = LWP::UserAgent->new();
    my $uri = $self->__path_cons($resource);

    # If no credentials we assume data is public and
    # bail out afterwards
    if (   !defined($self->consumer_key)
        || !defined($self->access_token)
        || !defined($self->access_token_secret))
    {
        my $res = $ua->request(GET $uri->as_string);
        die $res->{_content} unless $res->is_success;
        return decode_json($res->content);
    }

    # If we are here then it is assumed we've passed the
    # necessary credentials to access protected data
    my $request = Net::OAuth->request('protected resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => '',
        token            => $self->access_token,
        token_secret     => $self->access_token_secret,
        request_url      => $uri->as_string,
        request_method   => $method,
        signature_method => 'PLAINTEXT',
        timestamp        => time,
        nonce            => $self->_nonce,
    );
    $request->sign;

    if ($method eq "POST") {
        my $_req =
          HTTP::Request->new(POST => $request->normalized_request_url);
        $_req->header(
            'Authorization' => $self->__oauth_authorization_header($request));
        $_req->content($self->__query_from_hash($params));
        my $res = $ua->request($_req);
        die "Failed to POST: " . $res->{_msg} unless ($res->{_rc} == 201);
    }
    elsif ($method eq "PATCH") {

        # HTTP::Request::Common doesnt support PATCH verb
        my $_req =
          HTTP::Request->new(PATCH => $request->normalized_request_url);
        $_req->header('User-Agent'   => 'imafreakinninjai/1.0');
        $_req->header('Content-Type' => 'application/json');
        $_req->header(
            'Authorization' => $self->__oauth_authorization_header($request));
        $_req->content(encode_json($params));
        my $res = $ua->request($_req);

        # For current Launchpad API 1.0 the response code is 209
        # (Initially in draft spec for PATCH, but, later removed
        # during final)
        # FIXME: Check for Proper response code 200 after 2015 when
        # API is expired.
        die $res->{_content} unless $res->{_rc} == 209;
        decode_json($res->content);
    }
    else {
        my $res = $ua->request(GET $request->to_url);
        die $res->{_content} unless $res->is_success;
        decode_json($res->content);
    }
}

method get ($resource) {
    $self->_request($resource, undef, 'GET');
}


method post ($resource, $params) {
    $self->_request($resource, $params, 'POST');
}

method update ($resource, $params) {
    $self->_request($resource, $params, 'PATCH');
}

1; # End of Net::OAuth::LP::Client

__END__

=head1 NAME

Net::OAuth::LP::Client - Launchpad.net Client routines

=head1 DESCRIPTION

This isn't meant to be called directly but inherited from exposed Net::OAuth::LP::Models.

=head1 DEVELOPMENT

=head2 Repository

    http://github.com/battlemidget/Net-OAuth-LP

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OAuth::LP::Client

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Adam Stokes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

