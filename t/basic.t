use strict;
use warnings;
use Test::More;

use Sub::Nullify;

my $i = 0;
sub debug_log { $i++ }

debug_log;
is $i, 1;

BEGIN {
    Sub::Nullify::nullify(\&debug_log);
}

# the call should be compiled away
debug_log;
is $i, 1;

# the arg list should be compiled away as well
debug_log $i++;
is $i, 1;

# only compilation of entersubs should be messed with
do { \&debug_log }->();
is $i, 2;

done_testing;
