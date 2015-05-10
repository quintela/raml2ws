package RAML;

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
use RAML::Parser;
use Exporter;
our @ISA       = qw/Exporter/;
our @EXPORT_OK = qw(decode_raml);

sub decode_raml($){ RAML::Parser::decode_raml(@_) }

=head1 OOP INTERFACE

=cut 
sub new {
  my ($class, %params) = @_;
  my $file = delete $params{file};

  my $raml = decode_raml $file if $file;

  my $self = { raml => $raml };
  bless $self, $class;
}


1;

__END__

=head1 AUTHOR

Tiago Quintela, <quintela[at]....pt>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 by Tiago Quintela

This library is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.