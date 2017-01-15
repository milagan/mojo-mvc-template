use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME      => 'MojoMVC',
  VERSION   => '0.01',
  test      => {TESTS => 't/*.t'}
);
