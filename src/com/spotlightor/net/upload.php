<?php
// 与URLRequestWrapper配合使用
// default path for the image to be stored //
$default_path = 'images/';

// check to see if a path was sent in from flash //
$target_path = ($_POST['dir']) ? $_POST['dir'] : $default_path;
if (!file_exists($target_path)) mkdir($target_path, 0777, true);

// full path to the saved image including filename //
$destination = $target_path . basename( $_FILES[ 'Filedata' ][ 'name' ] ); 

// move the image into the specified directory //
if (move_uploaded_file($_FILES[ 'Filedata' ][ 'tmp_name' ], $destination)) {
    echo "The file " . basename( $_FILES[ 'Filedata' ][ 'name' ] ) . " has been uploaded;";
} else {
    echo "FILE UPLOAD FAILED";
}
?>
