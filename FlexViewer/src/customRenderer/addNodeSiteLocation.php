<?php

$stringToWrite = "<Site>".$_POST["Site"]."</Site>";

$fh = fopen("LOCA_LOCA.xml", 'w');
fwrite($fh, $stringToWrite);
fclose($fh);

?>