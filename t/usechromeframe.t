use strict;
no warnings;
use Plack::Test;
use Plack::Builder;
use Test::More;
use HTTP::Request::Common;

my $app = sub { return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'All your browsers are belong to us' ] ] };

$app = builder {
	enable 'UseChromeFrame';
	$app;
};

test_psgi app => $app, client => sub {
	my $cb = shift;

	my ( $req, $res );

	$req = GET 'http://localhost/';
	$res = $cb->( $req );
	ok !$res->header( 'X-UA-Compatible' ), 'Regular requests are unmolested';

	$req = GET 'http://localhost/', 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0) chromeframe/5.0.342.0';
	$res = $cb->( $req );
	is $res->header( 'X-UA-Compatible' ), 'chrome=1', 'Chrome Frame requests get X-UA-Compatible added';
};

done_testing;
