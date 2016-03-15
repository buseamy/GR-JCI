<?php 
require('mysqli_connect.php');
require('public_html/include_utils/procedures.php');

$q_JobTest = 'Call spJobTest()';
$r_JobTest = mysqli_query($dbc, $q_JobTest);
complete_procedure($dbc);
?>