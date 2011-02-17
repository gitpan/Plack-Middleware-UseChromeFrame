package Plack::Middleware::UseChromeFrame;
BEGIN {
  $Plack::Middleware::UseChromeFrame::VERSION = '1.002';
}
use strict;
use parent 'Plack::Middleware';
use Plack::Util ();

# ABSTRACT: enable Google Chrome Frame for users who have it

sub call {
	my $self = shift;
	my ( $env ) = @_;
	my $res = $self->app->( $env );

	my $ua = $env->{'HTTP_USER_AGENT'};
	return $res unless defined $ua and $ua =~ /chromeframe/i;

	Plack::Util::response_cb( $res, sub {
		Plack::Util::header_push( $_[0][1], 'X-UA-Compatible', 'chrome=1' );
		return;
	} );
}

1;



=pod

=head1 NAME

Plack::Middleware::UseChromeFrame - enable Google Chrome Frame for users who have it

=head1 VERSION

version 1.002

=head1 SYNOPSIS

 # in app.psgi
 use Plack::Builder;
 
 builder {
     enable 'UseChromeFrame';
     $app;
 };

=head1 DESCRIPTION

This is a lightweight middleware that adds the C<X-UA-Compatible: chrome=1>
header required by GoogleE<nbsp>ChromeE<nbsp>Frame to take over page rendering,
for requests made from a browser with ChromeE<nbsp>Frame installed.

=head1 SEE ALSO

=over 4

=item *

GoogleE<nbsp>ChromeE<nbsp>Frame L<http://code.google.com/chrome/chromeframe/>

=item *

L<Plack::Middleware::ChromeFrame>

This is a much more aggressive middleware. Visitors running
InternetE<nbsp>Explorer without ChromeE<nbsp>Frame installed are prevented from
seeing the site at all: they only receive a page instructing them on how to
install ChromeE<nbsp>Frame.

=back

=head1 AUTHOR

Aristotle Pagaltzis <pagaltzis@gmx.de>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Aristotle Pagaltzis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

