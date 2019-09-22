<?php

// https://notepad-plus-plus.org/community/topic/15124/php-function-list-and-abstract-functions/12

// Issue: "$i" not detected as double quoted string literal

    class Bad  {
        function RsdTitle() { 
            $i = 1;
           switch ($i) {
                case 1:
                $a =  "$i";
                break;
            }
            return "1";   
        }    
    } 
?>
