use strict;
use warnings;

package Sub::Nullify;

use XSLoader;
use B::Hooks::OP::Check::EntersubForCV;

XSLoader::load(__PACKAGE__);

1;
