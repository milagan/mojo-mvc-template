package MyApp::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub echo {
  my $c = shift;
  
  $c->app->log->debug( 'Websocket opened.' );
  $c->inactivity_timeout(300);

  # Incoming message
  $c->on(message => sub {
    my ($c, $msg) = @_;
    $c->send("echo: $msg");
  });

  # Closed
  $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    $c->app->log->debug("WebSocket closed with status $code");
  });
}

1;
