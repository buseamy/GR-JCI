<?php
/*
* @File Name:       login.php
* @Description:
* @PHP version:     Currently Unknown
* @Author(s):        Rui Takagi <takagir@ferris.edu>, Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    03/13/2016
*/

// Check if the form has been submitted:
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    require ('./include_utils/login_functions.php');
    require ('../mysqli_connect.php');
    require ('./include_utils/procedures.php');
    require ('./include_utils/email_functions.php');

    $email = mysqli_real_escape_string($dbc, $_POST['email']);
    $pass = mysqli_real_escape_string($dbc, $_POST['pass']);

    $q_verify = "Call spLoginGetUserID('$email', '$pass');";
    $r = @mysqli_query ($dbc, $q_verify); // Run stored procedure
    complete_procedure($dbc);

    while($userid_row = mysqli_fetch_array($r)) {
        if ($userid_row[0] == -1) { //Not a match or incomplete fields
            $errors[] = 'Username or password is incorrect';
        }
        else {
            //Stores the user ID
            $temp_userid = $userid_row[0];
            
            if ($userid_row[2] == 0) {
                //User account isn't active
                $errors[] = 'Username or password is incorrect';
            } else {
                if ($userid_row[1] == 2) {
                    //User needs to click the new verify email link
                    sendVerificationEmail($dbc, $temp_userid, 1);
                    $errors[] = 'Account needs to be verified, please check your email.';
                } else {
                    if (session_status() == PHP_SESSION_NONE) {
                        // Only start the session if one doesn't exist
                        session_start();
                    }
    
                    //sets the user ID
                    $_SESSION['UserID'] = $temp_userid;
    
                    //Roles are set to 0 by default
                    $_SESSION['isAuthor'] =  0;
                    $_SESSION['isReviewer'] = 0;
                    $_SESSION['isEditor'] = 0;
                    // boolean set for condition shortcut
                    $_SESSION['is_author'] = false;
                    $_SESSION['is_reviewer'] = false;
                    $_SESSION['is_editor'] = false;
        
                    //Stored procedure for getting the user roles
                    $Roles = mysqli_query($dbc, "Call spGetUserRoles($temp_userid);");
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
        
                    /* 2016-Mar-25 : JB - Less redundancy to get the user roles
                    //Stored procedure for getting the user roles
                    $q_userrole = "CALL spGetUserRoles('$temp_userid')";
                    $userrole = @mysqli_query($dbc, $q_userrole);
                    $userroles_row = mysqli_fetch_array($q_userrole);
        
                    //Checks for the user roles, sets session variable to true if the array contains that role
                    while($userroles_row = @mysqli_fetch_array($userrole)) {
                        if (in_array("Author", $userroles_row)) {
                            $_SESSION['isAuthor'] =  1;
                        }
                        if (in_array("Reviewer", $userroles_row)) {
                            $_SESSION['isReviewer'] =  1;
                        }
                        if (in_array("Editor", $userroles_row)) {
                            $_SESSION['isEditor'] =  1;
                        }
                    }
                    //complete_procedure($dbc);
                    */
        
                    // Store the HTTP_USER_AGENT:
                    $_SESSION['agent'] = md5($_SERVER['HTTP_USER_AGENT']);
        
                    // Redirect:
                    redirect_user('logged_in.php');
                }
            }
        }
    }

    mysqli_close($dbc); // Close the database connection.
}

// Create the page:
include ('login_page.php');
?>
