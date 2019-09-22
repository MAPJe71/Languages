/*
**  https://github.com/notepad-plus-plus/notepad-plus-plus/issues/4794
*/

main() {
    if( Test(1) ) {
        // do some stuff
    }
    if( Test(2) ) 2;
    if( Test(3) ) { 3 };
    if( Test(4) ) 
    { 
        4;
    };
}

int Test(int x) {
    return 1;
}