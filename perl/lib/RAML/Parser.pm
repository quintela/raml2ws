package RAML::Parser;

use 5.16.2;

use FindBin qw($Bin);
use YAML::Dumper;
use YAML::XS;


use constant DEBUG => 1;

sub new {
  my ($class, %cnf) = @_;

  my $file = delete $cnf{file};
  my $self = {
    __raml => __load_raml($file),
  };

  bless $self, $class;
}

sub __load_raml { 
  my $base   = Load(__read_file($_[0]));
  while( my ($key, $value) = each %$base ){
    $base->{$key} = __handle_include( $value ) if __is_an_include( $key, $value ); 
  }
  return $base;
}

sub __dumper { YAML::Dumper->new }

sub __handle_include {
  __dumper()->dump($_[0]) =~ /\!\!perl\/scalar:include(.+)/;
  my $file = $1;
  $file =~ s/(^\s*|\s*$)//g;
  return __load_raml("$Bin/data/$file");
}

sub __is_an_include {
  return $_[0] =~ /^\// && ref $_[1] eq 'include' ? 1 : 0;
}

sub __read_file {
  my $buf;
  {
    local *FH;
    open FH, "$_[0]" or die $!;
    -f FH and sysread FH, $buf, -s FH;
  }
  return $buf;
}

1;

__END__

=head1 AUTHOR

Tiago Quintela 

=head1 CONTRIBUTORS
