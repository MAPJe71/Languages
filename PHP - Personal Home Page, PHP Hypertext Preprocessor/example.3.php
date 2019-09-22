<?php

// Connect to database

$errmsg = "";
if (! @mysql_connect("localhost","trainee","abc123")) {
        $errmsg = "Cannot connect to database";
        }
@mysql_select_db("test");

// First run ONLY - need to create table by uncommenting this
// Or with silent @ we can let it fail every sunsequent time ;-)

$q = <<<CREATE
create table pix (
    pid int primary key not null auto_increment,
    title text,
    imgdata blob)
CREATE;
@mysql_query($q);

// Insert any new image into database

if ($_REQUEST[completed] == 1) {
        // Need to add - check for large upload. Otherwise the code
        // will just duplicate old file ;-)
        // ALSO - note that latest.img must be public write and in a
        // live appliaction should be in another (safe!) directory.
        move_uploaded_file($_FILES['imagefile']['tmp_name'],"latest.img");
        $instr = fopen("latest.img","rb");
        $image = addslashes(fread($instr,filesize("latest.img")));
        if (strlen($instr) < 149000) {
                mysql_query ("insert into pix (title, imgdata) values (\"".
                $_REQUEST[whatsit].
                "\", \"".
                $image.
                "\")");
        } else {
                $errmsg = "Too large!";
        }
}

// Find out about latest image

$gotten = @mysql_query("select * from pix order by pid desc limit 1");
if ($row = @mysql_fetch_assoc($gotten)) {
        $title = htmlspecialchars($row[title]);
        $bytes = $row[imgdata];
} else {
        $errmsg = "There is no image in the database yet";
        $title = "no database image available";
        // Put up a picture of our training centre
        $instr = fopen("../wellimg/ctco.jpg","rb");
        $bytes = fread($instr,filesize("../wellimg/ctco.jpg"));
}

// If this is the image request, send out the image

if ($_REQUEST[gim] == 1) {
        header("Content-type: image/jpeg");
        print $bytes;
        exit ();
        }
?>