<?php
// These functions were writen by Jonathan Sankey and uses ideas found at the following sites:
// http://stackoverflow.com/questions/6193289/check-the-format-of-a-date-in-php
// http://stackoverflow.com/questions/6238992/converting-string-to-date-and-datetime


// This function takes a date in the American standard format. If it is in that format it will convert it to the European format
// and return it for upload to the database. If it is in the wrong format it will exit with a descriptive error.
function convert_to($date) {
   list($m, $d, $y) = explode('/', $date);
   if(checkdate($m, $d, $y)){
		$newdate = DateTime::createFromFormat('m/d/Y', $date )->format('Y-m-d');
		return $newdate;
      }else{
      die("The date was in the wrong format");
      }
}


// this function converts Eropean standard time format to American standart time format for display.
function convert_from ($date) {
	$newdate = DateTime::createFromFormat('Y-m-d', $date )->format('m/d/Y');
	return $newdate;
}