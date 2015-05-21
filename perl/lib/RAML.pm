package RAML;

use v5.20.1;

=head1 NAME

RAML - RESTful API Modeling Language (RAML)

=head1 SYNOPSIS

RAML is a simple and succinct way of describing practically-RESTful APIs. 

The goal is to allow API developers to write "specification first" 
before implementing webservices.

It can be used to bootstrap a webservice based on its specification 

=head1 VERSION
  
  0.10

=head1 DESCRIPTION

RAML (RESTful API Modeling Language)
See L<http://raml.org/>.

=head1 FEATURES

=head2 decode_raml
  
  use RAML qw(decode_raml);

  decode_raml $raml_file;

=cut 

## setup exporter/"proxy" for decode_raml

use Exporter;
our @ISA       = qw/Exporter/;
our @EXPORT_OK = qw(decode_raml);

use RAML::Parser;
sub decode_raml($){ RAML::Parser::decode_raml(@_) }

=head1 OOP INTERFACE

=cut 

use RAML::Base;

sub new {
  my ($class, %params) = @_;
  
  my $file = delete $params{file};
  my $raml = decode_raml $file if $file;

  ## TODO: should I register RAML on object or just chew the struct and 
  ### register the resulting chewed struct
  ### id est => chew the struct on OBJ creation and just bless the reference
  my $self = { __raw__  => $raml };

  bless $self, $class;
}

=head1 PRIVATE METHODS


=cut

=head2 __base

=cut

sub __base { state $base = RAML::Base->new( $_[0]->{__raw__} ); }



=head1 PUBLIC METHODS

=cut

=head2 title

=cut
sub title { $_[0]->__base->title }
=head2 version

=cut
sub version { $_[0]->__base->version }
=head2 base_uri

=cut
sub base_uri { $_[0]->__base->base_uri }

=head2 media_type

=cut
sub media_type { $_[0]->__base->media_type }
=head2 protocols

=cut
sub protocols { $_[0]->__base->protocols }

=head2 routes

=cut
sub routes { $_[0]->__base->routes }

1;

__END__

=head1 AUTHOR

Tiago Quintela, <quintela[at]....pt>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 by Tiago Quintela

This library is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.