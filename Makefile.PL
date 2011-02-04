use strict;

use ExtUtils::MakeMaker;
use ExtUtils::Depends;

my $dep = ExtUtils::Depends->new('Sub::Nullify', 'B::Hooks::OP::Check::EntersubForCV');

WriteMakefile(
    NAME => 'Sub::Nullify',
    $dep->get_makefile_vars,
);
