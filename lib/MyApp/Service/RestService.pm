package MyApp::Service::RestService;
use Mojo::JSON qw(decode_json encode_json);

sub new {
    my ($class) = shift;
    my $self = {
        _app => shift,
        _ua => Mojo::UserAgent->new()
    };      
   
    bless $self, $class;
    return $self;
}

sub check_evolvestore_version_blocking {
    my ($self) = @_;

    my $ua = $self->{_ua};
    my $get = "http://evolvestore.cloudapp.net/command_onlineversion?version=1.00";

    my $tx = $ua->get($get);
    my $data = decode_json($tx->res->body);

    return $data;
}

sub check_evolvestore_version_nonblocking {
    my ($self, $c) = @_;

    my $ua = $self->{_ua};
    my $get = "http://evolvestore.cloudapp.net/command_onlineversion?version=1.00";

    $ua->get($get => sub {
        my ($ua, $tx) = @_;
        my $data = decode_json($tx->res->body);

        # send reply after 10 seconds
        Mojo::IOLoop->timer(10 => sub {
            $c->render(json => {data => $data});
        });
    });
}

1;