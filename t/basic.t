use strict;
use warnings;
use Test::More;

use Sub::Nullify;

my $i = 0;
sub debug_log { $i++ }

debug_log;
is $i, 1, 'nothing special initially';

BEGIN { Sub::Nullify::nullify(\&debug_log) }

debug_log;
is $i, 1, 'the call should be compiled away';

debug_log $i++;
is $i, 1, 'the arg list should be compiled away as well';

do { \&debug_log }->();
is $i, 2, 'only compilation of entersubs should be messed with';

BEGIN { Sub::Nullify::unnullify(\&debug_log) }

debug_log;
is $i, 3, 're-enabling works';

done_testing;
