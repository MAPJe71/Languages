<?php
 class Bad  {
function RsdTitle() { 
    $i = 1;
    $table = 5;
    if (TRUE) {
        switch ($i) {
            case 1: return "Jeu pour apprendre la table de multiplication par {$table}";
            case 2: return "Jeu pour apprendre la table de {$table} d'addition";
        }
    }
    return "Jeu avec les tables de multiplications https://motsbleus.pages-informatique.com/jeu-tables-multiplications.html";   
}   
 } 
?>