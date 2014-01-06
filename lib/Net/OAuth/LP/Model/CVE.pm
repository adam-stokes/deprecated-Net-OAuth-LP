package Net::OAuth::LP::Model::CVE;

use Mojo::Base 'Net::OAuth::LP::Model';

has 'cve';

sub by_sequence {
    my ($self, $sequence) = @_;
    $self->cve($self->get(sprintf("%s/bugs/cve/%s", $self->api_url, $sequence)));
}

sub bugs {
    my $self = shift;
    my $bugs = $self->get($self->cve->{bugs_collection_link});
    return $bugs->{entries};
}

sub display_name {
    my $self  = shift;
    return $self->cve->{display_name};
}

sub description {
    my $self = shift;
    return $self->cve->{description};
}

sub title {
    my $self = shift;
    return $self->cve->{title};
}

sub web_link {
    my $self = shift;
    return $self->cve->{web_link};
}

sub date_created {
    my $self = shift;
    return $self->cve->{date_created};
}

sub date_modified {
    my $self = shift;
    return $self->cve->{date_modified};
}

sub status {
    my $self = shift;
    return $self->cve->{status};
}

sub url {
    my $self = shift;
    return $self->cve->{url};
}

sub sequence {
    my $self = shift;
    return $self->cve->{sequence};
}


1;

__END__

=head1 NAME

Net::OAuth::LP::Model::CVE - Launchpad.net cve Interface

=head1 SYNOPSIS

    use Net::OAuth::LP::Client;
    use Net::OAuth::LP::Model;
    my $c = Net::OAuth::LP::Client->new;
    $c->staging(1);

    my $model = Net::OAuth::LP::Model->new($c);
    my $cve = $model->namespace('CVE')->by_sequence('XXXX-XXXX');

    say "Title: ". $cve->title;
    say "Desc:  ". $cve->description;

=head1 DESCRIPTION

CVE model for Launchpad.net Bugs.

=head1 ATTRIBUTES

=head2 cve

CVE object.

=head1 METHODS

=head2 by_sequence

This needs to be called before any of the below methods. Takes a CVE sequence number, e.g. 2011-3188.

=head2 sequence

Returns cve number.

=head2 title

Returns title of cve.

=head2 bugs

Returns a list of entries associated with cve

=head2 web_link

Returns browseable URL link to resource.

=head2 description

Returns cve description

=head2 status

Returns whether the cve is of candidate, entry, deprecated

=head2 date_created

Returns date cve was created

=head2 date_modified

Return date of last modification

=head2 display_name

Returns brief description of the ref and state

=head2 url

Returns URL to site that contains CVE data for this CVE reference.

=head1 AUTHOR

Adam Stokes, C<< <adamjs at cpan.org> >>

=head1 BUGS

Report bugs to https://github.com/battlemidget/Net-OAuth-LP/issues.

=head1 DEVELOPMENT

=head2 Repository

    http://github.com/battlemidget/Net-OAuth-LP

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OAuth::LP

=head1 SEE ALSO

=over 4

=item * L<https://launchpad.net/launchpadlib>, "Python implementation"

=back

=head1 COPYRIGHT

Copyright 2013-2014 Adam Stokes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
