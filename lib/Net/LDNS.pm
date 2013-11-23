package Net::LDNS;

use 5.12.4;

our $VERSION = '0.1';
require XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

use Net::LDNS::RR;
use Net::LDNS::Packet;

our %destroyed;

sub DESTROY {
    my ($self) = @_;

    if (not $destroyed{$self->addr}) {
        $destroyed{$self->addr} = 1;
        $self->free;
    }

    return;
}

1;

=head1 NAME

    Net::LDNS - Perl wrapper module for the C<ldns> DNS library

=head1 SYNOPSIS

    my $resolver = Net::LDNS->new('8.8.8.8');
    my $packet   = $resolver->query('www.iis.se');
    say $packet->string;

=head1 DESCRIPTION

C<Net::LDNS> represents a resolver, which is the part of the system responsible for sending queries and receiving answers to them.

=head1 METHODS

=over

=item new($addr,...)

Creates a new resolver object. If given no arguments, if will pick up nameserver addresses from the system configuration (F</etc/resolv.conf> or
equivalent). If given a single argument that is C<undef>, it will not know of any nameservers and all attempts to send queries will throw
exceptions. If given one or more arguments that are not C<undef>, attempts to parse them as IPv4 and IPv6 addresses will be made, and if successful
make up a list of servers to send queries to. If an argument cannot be parsed as an IP address, an exception will be thrown.

=item query($name, $type, $class)

Send a query for the given triple. If type or class are not provided they default to A and IN, respectively. Returns a L<Net::LDNS::Packet> or
undef.

=item name2addr($name)

Asks this resolver to look up A and AAAA records for the given name, and return a list of the IP addresses (as strings). In scalar context, returns
the number of addresses found.

=item addr2name($addr)

Takes an IP address, asks the resolver to do PTR lookups and returns the names found. In scalar context, returns the number of names found.

=item recurse($flag)

Returns the setting of the recursion flag. If given an argument, it will be treated as a boolean and the flag set accordingly.

=item debug($flag)

Gets and optionally sets the debug flag.

=item dnssec($flag)

Get and optionally sets the DNSSEC flag.

=item igntc($flag)

Get and optionally sets the igntc flag.

=item usevc($flag)

Get and optionally sets the usevc flag.

=item retry($count)

Get and optionally set the number of retries.

=item retrans($seconds)

Get and optionally set the number of seconds between retries.

=back