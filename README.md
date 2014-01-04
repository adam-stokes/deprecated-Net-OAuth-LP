# NAME

Net::OAuth::LP - Launchpad.net OAuth 1.0

# SYNOPSIS

OAuth 1.0a authorization and client for Launchpad.net

# ATTRIBUTES

[Net::OAuth::LP](https://metacpan.org/pod/Net::OAuth::LP) implements the following attributes:

## __consumer\_key__

Holds the string that identifies your application.

    $lp->consumer_key('my-app-name');

## __access\_token__

Token received from authorized request

## __access\_token\_secret__

Token secret received from authorized request

## __staging__

Boolean to interact with staging server or production.

## __ua__

A [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent).

# METHODS

## __access\_token\_url__

OAuth Access token url

## __authorize\_token\_url__

OAuth Authorize token url

## __request\_token\_url__

OAuth Request token url

## __api\_url__

API url for doing the client interactions with launchpad.net

# AUTHOR

Adam Stokes, `<adamjs at cpan.org>`

# BUGS

Report bugs to https://github.com/battlemidget/Net-OAuth-LP/issues.

# DEVELOPMENT

## Repository

    http://github.com/battlemidget/Net-OAuth-LP

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::OAuth::LP

# SEE ALSO

- [https://launchpad.net/launchpadlib](https://launchpad.net/launchpadlib), "Python implementation"

# COPYRIGHT

Copyright 2013-2014 Adam Stokes

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
