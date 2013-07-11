# NAME

Net::OAuth::LP - Launchpad.net OAuth 1.0

# SYNOPSIS

OAuth 1.0a authorization and client for Launchpad.net

# ATTRIBUTES

[Net::OAuth::LP](http://search.cpan.org/perldoc?Net::OAuth::LP) implements the following attributes:

## __consumer\_key__

Holds the string that identifies your application.

    $lp->consumer_key('my-app-name');

## __token__

Token received from authorized request

## __token\_secret__

Token secret received from authorized request

# AUTHOR

Adam 'battlemidget' Stokes, `<adamjs at cpan.org>`

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

Copyright 2013- Adam Stokes

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
