package MyApp::Model::Data;

use DBI;

sub new {
    my ($class) = shift;
    my $self = {
        _db => undef
    };      
   
    bless $self, $class;
    return $self;
};

sub open {
    my ($self) = @_;

    #$self->{_db} = DBI->connect($Modules::Constants::LOGGER_DATABASE, "", "", {RaiseError => 1, AutoCommit => 1, sqlite_unicode => 1});
};

sub close {
    my ($self) = @_;

    if (defined($self->{_db})) {
        #$self->{_db}->close();
    }
};

1;