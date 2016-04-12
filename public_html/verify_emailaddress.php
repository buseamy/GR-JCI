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
        // boolean set for condition shortcut
        $_SESSION['is_author'] = false;
        $_SESSION['is_reviewer'] = false;
        $_SESSION['is_editor'] = false;
        
        //Stored procedure for getting the user roles
        $Roles = mysqli_query($dbc, "Call spGetUserRoles($UserID);");
        complete_procedure($dbc);
        while ($row = mysqli_fetch_array($Roles, MYSQLI_ASSOC)) {
            // short-circuits if already set
            $_SESSION['is_author'] = ($_SESSION['is_author'] || $row['RoleTitle'] == 'Author');
            $_SESSION['is_reviewer'] = ($_SESSION['is_reviewer'] || $row['RoleTitle'] == 'Reviewer');
            $_SESSION['is_editor'] = ($_SESSION['is_editor'] || $row['RoleTitle'] == 'Editor');
            // TODO: boolean could be added to the actions per if, or the if could be on the boolean
            if ($row["RoleTitle"] == 'Author') { $_SESSION['isAuthor'] =  1; }
            if ($row["RoleTitle"] == 'Reviewer') { $_SESSION['isReviewer'] =  1; }
            if ($row["RoleTitle"] == 'Editor') { $_SESSION['isEditor'] =  1; }
        }

        //echo $_SESSION['isAuthor'].'<br />'.$_SESSION['isReviewer'].'<br />'.$_SESSION['isEditor'];
        
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