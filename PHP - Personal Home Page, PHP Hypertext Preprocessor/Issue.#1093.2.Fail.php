<?php
/*
    Using strings like '//', "//" will break further function listing.

    2.
    The character # as used for comments in PHP, will also give unwanted results (no function listing).

    Example PHP code:
*/

class Foo
{
    // next line will break everything
    # private function test0($var) {
    private function test1($var) {
    }
}

?>
