package Cake::Object::Storage::Persistent::DB::Postgres;
use strict;
use base qw(Cake::Object::Storage::Persistent::DB);

sub __init {
	my ($self, $class) = @_;
	my $config = $class->_getConfig->fetchAll;

	my $platform = $config->{platform};
	my $database = $config->{database};
	my $host     = $config->{host};
	my $port     = $config->{port};
	my $user     = $config->{user};
	my $pw       = $config->{pw};

	my $dsn = "dbi:$platform:database=$database;host=$host;port=$port";

	__PACKAGE__->__driver( DBI->connect( $dsn, $user, $pw ) );
	__PACKAGE__->__driver->{HandleError} = sub { Cake::Exception::DB::DBIError->throw( { driver => "Postgres", "errstr" => $_[0] } ) };
	$class->_registerInitCallback(__PACKAGE__->can('__instantiate'));
	$self->SUPER::__init($class);
}

1;
