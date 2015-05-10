package RAML::Parser;

=head1 NAME

RAML::Parser

=head1 SYNOPSIS

Used in conjuntion w/ L<RAML> it can be used to bootstrap a webservice 
given a specific template engine

=head1 VERSION
  
  0.10

=head1 DESCRIPTION

This module converts RAML files to Perl data structures using
L<JSON::XS>, L<YAML::XS> and L<YAML::Dumper>.

=head1 INTERFACE

=cut 
use v5.20.2;

use JSON::XS qw(decode_json);
use YAML::Dumper;
use YAML::XS;

## save path
our $path;

=head2 decode_raml

=cut
sub decode_raml { 
  Carp::croak 'Full path to RAML file should be supplied' unless $_[0];
  $path = __path($_[0]);
  Carp::croak 'Invalid path to file' unless $path;
  __inflate( __load_raml($_[0]) ); 
};

# inflate
# read external includes: .md, .yaml, .raml and .json
sub __inflate {
  my $o = $_[0];
  return ( ref($o) && $o =~ /HASH\(/)
    ? { map { $_ => __isa_include($o->{$_}) 
      ? __inflate( __handle_include( $o->{$_} ) ) 
      : __inflate( $o->{$_}) } keys %{$o} }
    : ( ref($o) && $o =~ /ARRAY\(/ ) 
      ? [ map { __isa_include($_) 
          ? __inflate( __handle_include( $_ ) ) 
          : __inflate( $_ ) } @{$o} ] 
      : $o;
}

# test if value isa include
sub __isa_include { ref($_[0]) eq 'include' ? 1 : 0; }

# handle include routes
sub __handle_include {
  __dumper()->dump($_[0]) =~ /\!\!perl\/scalar:include\s*([^\s*]+)/;
  my $file = __is_full_path($1) ? $1 : "$path/$1";

  return __read_file($file) if $file =~ /\.md$/;
  return __load_json($file) if $file =~ /\.json$/;
  return __load_raml($file) if $file =~ /\.(yaml|raml)$/;

  Carp::croak "oh! some unknown file extension";
  return;
}

# utilities
sub __path { $_[0] =~ m{^(.+)?/[^\s]+\.[yr]aml$}; $1 }

sub __is_full_path { $_[0] =~ m{/} ? 1 : 0 }

sub __load_raml { Load(__read_file($_[0])); }

sub __load_json { decode_json(__read_file($_[0])); }

sub __dumper { state $dumper = YAML::Dumper->new; }

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

Tiago Quintela, <quintela[at]....pt>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 by Tiago Quintela

This library is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.

