package MyApp::Model::Data;

use strict;
use warnings;

use File::Spec;
use DBI;

sub new {
    my ($class) = shift;
    my $self = {
        _app => shift,
        _db => undef
    };      
   
    bless $self, $class;
    return $self;
}

sub open {
    my ($self) = @_;

    my($vol,$dir,$file) = File::Spec->splitpath(__FILE__);

    my $db = qq(dbi:SQLite:dbname=$dir../database/data.db);
    $self->{_db} = DBI->connect($db, "", "", {RaiseError => 1, AutoCommit => 1, sqlite_unicode => 1});
}

sub close {
    my ($self) = @_;

    if (defined($self->{_db})) {
        $self->{_db}->close();
    }
}

sub insert_sqlite {
    my ($self) = @_;
    my $insert = $self->{_db}->prepare(
        qq(
        insert into table1 (column1, column2)
        values (?,?);
        )
    );

    $insert->execute('test1', 'test2');
}

sub select_sqlite {
    my ($self) = @_;
    my $select = $self->{_db}->prepare(
        qq(
        select * from table1;
        )
    );

    $select->execute();
    my $data = $select->fetchall_arrayref({});
    return $data;
}

1;