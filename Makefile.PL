use inc::Module::Install;
name 'Object-Method';
all_from 'lib/Object/Method.pm';

tests 't/*.t';
author_tests 'xt/*.t';

build_requires 'Test::More';

auto_include;
WriteAll;
