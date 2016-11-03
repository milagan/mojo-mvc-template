package MyApp;
use Mojo::Base 'Mojolicious';
use ZMQ::LibZMQ3;
use ZMQ::Constants qw|ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE ZMQ_FD ZMQ_NOBLOCK|;
use MojoX::Log::Log4perl;
use MyApp::Model::Data;

# This method will run once at server start
sub startup {
  my $self = shift;
  my $ctx  = zmq_init();;
  my $value = 0;
  
  #$self->log( MojoX::Log::Log4perl->new('log.conf'), 'HUP' );

  $self->helper(zmqsock_to_fd => sub {
                  my ( $c, $socket ) = @_;
                  return my $fh = IO::Handle->new_from_fd
                    ($socket->getsockopt(ZMQ_FD),'r');
                });  

  $self->helper(subscribe_socket => sub { return $self->init_subscribe_socket($ctx); });
  $self->helper(publish_socket   => sub { return $self->init_publish_socket($ctx); });
  $self->helper(get_value => sub { return $value; });
  $self->helper(inc_value => sub { return ++$value; });

  my $s = $self->init_publish_socket($ctx);

  Mojo::IOLoop->recurring(0.2 => sub {
                                       zmq_msg_send($$.' hello world', 
                                       $s, ZMQ_NOBLOCK);
                                     });

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->plugin("OpenAPI" => {    
    url => $self->home->rel_file("api.json")
  });    

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome'); 
  $r->get('/helper')->to('example#helper');
  $r->get('/value')->to('example#value');
  $r->get('/incvalue')->to('example#incvalue');
  $r->websocket('echo')->to('example#echo');  

}

sub init_publish_socket {
  my ( $self, $ctx ) = @_;
  my $socket = zmq_socket($ctx, ZMQ_PUB);

  zmq_connect($socket, 'tcp://127.0.0.1:5555');

  return $socket;
}

sub init_subscribe_socket {
  my ( $self, $ctx ) = @_;
  my $socket = $ctx->socket(ZMQ_SUB);

  $socket->setsockopt(ZMQ_SUBSCRIBE,'');
  $socket->connect('tcp://127.0.0.1:5556');

  return $socket;
}
1;
