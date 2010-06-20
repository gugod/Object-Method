#-*- cperl -*-
use strict;
use Test::More;

package Stuff;
use Object::Method;

sub foo {
}

package main;

my $o = bless {}, "Stuff";
my $p = bless {}, "Stuff";

ok($o->can("foo"));
ok($p->can("foo"));
ok(!$o->can("bar"));
ok(!$p->can("bar"));

subtest "->method attaches the given method to objects" => sub {
    plan tests => 2;

    $o->method("bar", sub { "..." });

    ok($o->can("bar"));
    ok(!$p->can("bar"));
};

subtest "->method attaches the given method to objects" => sub {
    plan tests => 3;

    $p->method("bar", sub { "..." });

    ok($o->can("bar"));
    ok($p->can("bar"));

    isnt($o->can("bar"),  $p->can("bar"), "\$o and \$p has different 'bar' method.");
};

subtest "->cloning is supported" => sub {
    plan tests => 6;

    $o->method("clone", sub { bless { %{ $_[0] } }, ref $_[0] });

    my $clone = $o->clone;

    isa_ok($clone, "Stuff");
    can_ok($clone, "bar" );

    $clone->method("blah", sub { "..." });

    can_ok($clone, "blah");
    ok(!$o->can("blah"));

    isa_ok($clone, "Stuff");
    can_ok($clone, "bar" );
};

done_testing;
