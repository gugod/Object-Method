package Object::Method;

use strict;
use warnings;
our $VERSION = '0.01';

sub import {
    no strict;
    if (@_ > 0) {
        *{caller . "::method"} = \&method;
    }
}

my $id = 0;

sub method {
    my ($o, $m, $c) = @_;

    my $p = ref($o);
    unless ($p =~ /#<\(\d+\)>$/) {
        $id++;
        my $op = $p;
        $p = $op . "#<${id}>";
        # eval "package $p;";
        bless $o, $p;
        {
            no strict;
            @{$p . "::ISA"}=($op);
        }
    }

    {
        no strict;
        *{$p . "::$m"} = $c;
    }
    return $o;
}

1;
__END__

=head1 NAME

Object::Method - attach method to objects instead of classes.

=head1 SYNOPSIS

  package Stuff;
  use Object::Method;

  package main;

  my $o = Stuff->new;
  my $p = Stuff->new;

  # Attach method 'foo' to $o but not $p
  $o->method("foo", sub { ... });

=head1 DESCRIPTION

Object::Method lets you attach methods to methods to object but not
its classes. There are two different ways to use this module. Keep reading.

The first way is to use it to create a class that allows user to
attach methods at runtime. To do this, simply put 'use Object::Method' in your
class body like this:

    package Stuff;
    use Object::Method;

This effectively exports a C<method> method to your class, which can be used to
create new methods like this:

    my $o = Stuff->new;

    $o->method("foo" => sub { ... });

The C<method> method takes exactly two arguments: the method name, and
a sub-routine or code-ref. After calling that C<method> method on
object C<$o>, a new method C<foo> will be attached to C<$o> and can be
invoked only on C<$o>.

=head1 AUTHOR

Kang-min Liu E<lt>gugod@gugod.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut

