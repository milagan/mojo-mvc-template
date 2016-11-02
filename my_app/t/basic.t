use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('MyApp');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
$t->get_ok('/incvalue')->status_is(200)->content_like(qr/1/i);
$t->get_ok('/value')->status_is(200)->content_like(qr/1/i);

done_testing();
