package ClassName;

use base qw(ParentClass);

sub new {
	my \$class = shift;
	\$class = ref \$class if ref \$class;
	my \$self = bless {}, \$class;
	\$self;
}

1;
