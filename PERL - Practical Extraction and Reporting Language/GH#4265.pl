
# https://github.com/notepad-plus-plus/notepad-plus-plus/issues/4265

# Perl allows functions defined without any prototype or signature:

sub function1 {
    return 1
}

# Perl also allows function attrbutes:

sub function2 : prototype($$) {
    return 1
}
