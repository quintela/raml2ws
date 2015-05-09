package RAML::Parser;

use v5.20.2;

use FindBin qw($Bin);
use JSON::XS qw(decode_json);
use YAML::Dumper;
use YAML::XS;

use constant DEBUG => $ENV{DEBUG};
require DDP if DEBUG;

=head1 INTERFACE

bless'ed be the parser!
Pass a file param and load RAML stuct to memory

=cut
sub dumpit;
sub new {
  Carp::croak "Path to base RAML file is mandatory" unless $_[1];
  my $raml = iterate( __load_raml($_[1]) );

  dumpit $raml;

  my $self = {
    __raw => {
     __title__      => $raml->{title},
     __version__    => $raml->{version},
     __base_uri__   => $raml->{baseUri},
     __media_type__ => $raml->{media_type},
     __protocols__  => $raml->{protocols},
  #  __schemas__ => .. ## to-do something about this
    }
  };

  bless $raml, $_[0];
}

=head1 OOP accessors

=cut

# sub {}

=head1 load files into mem 

=cut
sub iterate {
  my $o = shift;

  return ( ref($o) && $o =~ /HASH\(/)
    ? { 
        map { 
          $_ => __isa_include($o->{$_}) 
            ? iterate( __handle_include( $o->{$_} ) )
            : iterate( $o->{$_}) 
        } keys %{$o} 
      }
    : ( ref($o) && $o =~ /ARRAY\(/ ) 
      ? [ map { 
            __isa_include($_) 
              ? iterate( __handle_include( $_ ) )
              : iterate( $_ ) 
          } @{$o} 
        ] 
      : $o;
}

=head2 utilities

__dumper, dumpit, __load_raml, __load_json

=cut
sub __load_raml { Load(__read_file($_[0])) }
sub __load_json { decode_json(__read_file($_[0])) }
sub __dumper { state $dumper = YAML::Dumper->new; $dumper }
sub dumpit($) { DEBUG ? ref($_[0]) ? say STDERR DDP::p( $_[0] ) : say STDERR $_[0] : 1 };


=head2 __isa_include

=cut 
sub __isa_include { ref($_[0]) eq 'include' ? 1 : 0; }

=head2 __handle_include

handle include routes
## TODO: find the bin from file-path and w/o findbin
=cut
sub __handle_include {
  __dumper()->dump($_[0]) =~ /\!\!perl\/scalar:include\s*([^\s*]+)/;
  my $file = "$Bin/data/$1";
  return __read_file($file) if $file =~ /\.md$/;
  return __load_json($file) if $file =~ /\.json$/;
  return __load_raml($file) if $file =~ /\.(yaml|raml)$/;
  Carp::croak "oh! some unknown file extension";
  return;
}

=head2 __read_file
loads a file from disk
=cut

sub __read_file {
  my $buf;
  dumpit "try to read from '$_[0]'";
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