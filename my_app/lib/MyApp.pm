package MyApp;
use Mojo::Base 'Mojolicious';
use ZMQ;
use ZMQ::Constants qw|ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE ZMQ_FD ZMQ_NOBLOCK|;
use MojoX::Log::Log4perl;

# This method will run once at server start
sub startup {
  my $self = shift;
  my $ctx  = ZMQ::Context->new(10);
  
  $self->log( MojoX::Log::Log4perl->new('log.conf'), 'HUP' );

  $self->helper(zmqsock_to_fd => sub {
                  my ( $c, $socket ) = @_;
                  return my $fh = IO::Handle->new_from_fd
                    ($socket->getsockopt(ZMQ_FD),'r');
                });  

  $self->helper(subscribe_socket => sub { return $self->init_subscribe_socket($ctx); });
  $self->helper(publish_socket   => sub { return $self->init_publish_socket($ctx); });

  Mojo::IOLoop->recurring(0.2 => sub {
                                       $s->sendmsg(ZMQ::Message->new($$.' hello world'), ZMQ_NOBLOCK);
                                     });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->websocket('/websocket')->to('example#websocket');  
}

sub init_publish_socket {
  my ( $self, $ctx ) = @_;
  my $socket = $ctx->socket(ZMQ_PUB);

  $socket->connect('tcp://127.0.0.1:5555');

  return $socket;
}

sub init_subscribe_socket {
  my ( $self, $ctx ) = @_;
  my $socket = $ctx->socket(ZMQ_SUB);

  $socket->setsockopt(ZMQ_SUBSCRIBE,'');
  $socket->connect   ('tcp://127.0.0.1:5556');

  return $socket;
}
1;
