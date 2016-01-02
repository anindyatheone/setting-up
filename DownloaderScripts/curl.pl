use strict;
use warnings;
use HTTP::Tiny;

my $response = HTTP::Tiny->new->get('http://yahoo.com/');

die "Failed!\n" unless $response->{success};

print "$response->{status} $response->{reason}\n";

while ( my ( $k, $v ) = each %{ $response->{headers} } ) {
	for ( ref $v eq 'ARRAY' ? @$v : $v ) {
		print "$k: $_\n";
	}
}

print $response->{content} if length $response->{content};
