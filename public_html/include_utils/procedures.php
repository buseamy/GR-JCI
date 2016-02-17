<?php
// these functions can be used by any script featuring a database connection

// ignore_remaining_output - expects mysqli query result
// ignores remaining output of a query, such as when a single record is expected
function ignore_remaining_output ($r) {
    while (mysqli_fetch_array($r, MYSQLI_ASSOC) {
    }
}

// complete_procedure - expects mysqli database connection
// handles the extra output from calling a stored procedure
function complete_procedure ($dbc) {
    while (mysqli_more_results($dbc)) {
        mysqli_next_result($dbc);
    }
}

?>