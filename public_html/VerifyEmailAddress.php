<?php 

if (isset($_GET["e"])) {
    require('../mysqli_connect.php');
    require('./include_utils/procedures.php');
	require('./include_utils/login_functions.php');
    
    $guid = mysqli_real_escape_string($dbc, $_GET["e"]);
    
    $r = mysqli_fetch_array(mysqli_query($dbc, "Call spVerifyEmailAddress('$guid');"), MYSQLI_ASSOC);
    complete_procedure($dbc);
    $UserID = $r["UserID"];
    
    if ($UserID > -1) {
        //We have a valid user id, set session info and redirect to main page
        session_start();
        
        //sets the user ID
        $_SESSION['UserID'] = $r["UserID"];
        
        //Roles are set to 0 by default
        $_SESSION['isAuthor'] =  0;
        $_SESSION['isReviewer'] = 0;
        $_SESSION['isEditor'] = 0;
		
		//Stored procedure for getting the user roles
		$Roles = mysqli_fetch_array(mysqli_query($dbc, "Call spGetUserRoles($UserID);"));
		complete_procedure($dbc);
		if (in_array("Author", $Roles)) {
            $_SESSION['isAuthor'] =  1;
        }
        if (in_array("Reviewer", $Roles)) {
            $_SESSION['isReviewer'] =  1;
        }
        if (in_array("Editor", $Roles)) {
            $_SESSION['isEditor'] =  1;
        }
		
        // Store the HTTP_USER_AGENT:
        $_SESSION['agent'] = md5($_SERVER['HTTP_USER_AGENT']);
        
        // Close the database connection.
        mysqli_close($dbc);
        
        // Redirect:
        redirect_user('logged_in.php');
    }
    else {
        //We don't have a valid userid so the GUID expired or was already used
        mysqli_close($dbc);
		
        // Redirect:
        redirect_user('index.php');
    }
}

?>