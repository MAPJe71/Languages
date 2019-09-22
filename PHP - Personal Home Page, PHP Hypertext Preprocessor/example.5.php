
<?php

namespace models {
    class workdata extends \MyApp\ModelBase implements IArray, \MyApp\IModelBase,   IContainer{

        public function fetchRecord($id) {
            return true;
        }

    }
}

?>