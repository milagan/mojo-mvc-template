package MyApp::Controller::Example;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use ZMQ::LibZMQ3;
use ZMQ::Constants qw|ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE ZMQ_FD ZMQ_NOBLOCK|;

# This action will render a template
sub welcome {
  my $c = shift;

  # Render template "example/welcome.html.ep" with message
  $c->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub helper {
  my $c = shift;

  my $s = $c->publish_socket;
  zmq_msg_send($$.' hello world', $s, ZMQ_NOBLOCK);
  
  $c->render(json => {data => 'helper'});
}

sub value {
  my $c = shift;

  my $s = $c->get_value;
  $c->render(json => {data => $s});      
}

sub incvalue {
  my $c = shift;

  my $s = $c->inc_value;
  $c->render(json => {data => $s});      
}

sub log {
  my $c = shift->openapi->valid_input or return;

  my $input = $c->validation->output;

  my $events = "log";
  my $output = {code => 200, data => $events};
  $c->render(openapi => $output);   
}

sub sample {
  my $c = shift->openapi->valid_input or return;

  my $input = $c->validation->output;

  my $events = "sample";
  my $output = {code => 200, data => $events};
  $c->render(openapi => $output);   
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

sub write_sqlitedb {
  my $c = shift;

  $c->model->insert_sqlite();
  $c->render(json => {data => 'OK'});      
}

sub read_sqlitedb {
  my $c = shift;

  my $data = $c->model->select_sqlite();
  $c->render(json => {data => $data});      
}

1;
