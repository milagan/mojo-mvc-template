package MyApp::Controller::Service;
use Mojo::Base 'Mojolicious::Controller';

sub get_restapi_blocking {
  my $c = shift;

  $c->render_later();
  my $data = $c->service->check_evolvestore_version_blocking();
  $c->render(json => {data => $data});      
}

sub get_restapi_nonblocking {
  my $c = shift;

  $c->render_later();
  $c->service->check_evolvestore_version_nonblocking($c);   
}

1;