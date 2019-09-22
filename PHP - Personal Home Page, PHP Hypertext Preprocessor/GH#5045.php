
<?php

/* https://github.com/notepad-plus-plus/notepad-plus-plus/issues/5045 */

abstract class PageGrille extends PageMotsBleus
{
    abstract function GetTypeGrille() ;             // blabla blabla
    abstract function GetGrilleJSON($p_grilleId);   // Retourn JSON
    
    function CleanStr($pStr){
        return str_replace ( "\\" , "" , $pStr);
    }

    function GetJavascriptMajax() {
        return "ABC";
    }
}

?>