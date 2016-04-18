<?php $page_title = 'JCI Website - Submit a Critical Incident';

/*
 * The purpose of this file is to allow the authors
 * to submit a case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./includes/subnav.php'); // Dashboard navigation
 require ('./include_utils/procedures.php'); // complete_procedure()
?>
<!--Form scripts-->
<script src="./js/formJS.js" language="Javascript" type="text/javascript"></script>
<script type="text/javascript" src="./js/form_validator.js"></script>
<script type="text/javascript" src="./js/jcf.file.js"></script>
<script type="text/javascript" src="./js/jcf.js"></script>
<script type="text/javascript"> $( "#author" ).addClass( "active" ); </script>
<div>
    <?php if (isset($_SESSION['isAuthor'])) { // Only display if logged in role is author
        $UserID = $_SESSION['UserID'];
        $results = $dbc->query("Call spGetUserInfo('$UserID');"); // Run procedure
        complete_procedure($dbc);
        while($row = $results->fetch_assoc()) {
            $email = $row["EmailAddress"];
            $firstname = $row["FirstName"];
            $lastname = $row["LastName"];
            $membercode = $row["MemberCode"];
            $institution = $row["InstitutionAffiliation"];
    }
    ?>
    <div class="contentwidth">
        <div class="row flush">
            <div class="col s7">
                <div class="author roundcorner">
                    <h3 class="title">Submit a Critical Incident</h3>
                </div>
                <!--Page main body-->
                <div style="padding-left:50px;" class="box_guest author_alt" id="registration-form">
                    <h1>Critical Incident</h1>
                    <form class="submitform" id="submit_criticalIncident" action="process_critical_incident.php" method="post" enctype="multipart/form-data">
                        <input class="regular required" placeholder="Title" type="text" name="title" id="title" size="30" maxlength="100">
                        <div id="dynamicAuthor">
                            <div>
                                <h3>Author 1 (Primary Contact)</h3>
                                <p>Email Address: <input class="regular" value="<?php echo $email; ?>" type="text" name="email" id="email"></p>
                                <p>First Name: <input class="regular" value="<?php echo $firstname; ?>" type="text" name="fname" id="fname"></p>
                                <p>Last Name: <input class="regular" value="<?php echo $lastname; ?>" type="text" name="lname" id="lname"></p>
                                <input class="regular" value="<?php echo $membercode; ?>" placeholder="SCR Member Code (Optional)" type="text" name="memberCode" id="memberCode" size="30" maxlength="60">
                            </div>
                        </div>
                        <button class="author" type="button" onClick="addInput('dynamicAuthor');">Add another author</button>
                        <button id="removeAuthor" style="display:none;" class="author" type="button" onClick='removeInput();'>Remove author</button>
                        <p><input type="hidden" name="counter" id="counter" value="1"></p>
                        <h3>Please provide all the following documents:</h3>
                        <span class="jcf-file jcf-pressed">
                            <span class="jcf-fake-input">No file chosen</span>
                            <span class="jcf-upload-button">
                                <span class="jcf-button-content">Choose Cover Page</span>
                            </span>
                            <input name="coverPage" id="coverPage" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                        </span><br>

                        <span class="jcf-file jcf-pressed">
                            <span class="jcf-fake-input">No file chosen</span>
                            <span class="jcf-upload-button">
                                <span class="jcf-button-content">Choose Critical Incident</span>
                            </span>
                            <input name="criticalIncident" id="criticalIncident" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                        </span><br>

                        <span class="jcf-file jcf-pressed">
                            <span class="jcf-fake-input">No file chosen</span>
                            <span class="jcf-upload-button">
                                <span class="jcf-button-content">Choose Teaching Notes</span>
                            </span>
                            <input name="teachingNotes" id="teachingNotes" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                        </span><br>

                        <span class="jcf-file jcf-pressed">
                            <span class="jcf-fake-input">No file chosen</span>
                            <span class="jcf-upload-button">
                                <span class="jcf-button-content">Choose Memo</span>
                            </span>
                            <input name="memo" id="memo" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                        </span><br>

                        <span class="jcf-file jcf-pressed">
                            <span class="jcf-fake-input">No file chosen</span>
                            <span class="jcf-upload-button">
                                <span class="jcf-button-content">Choose Summary (optional)</span>
                            </span>
                            <input name="summary" id="summary" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                        </span><br>

                        <!--<p><label class="inputFileLabel" for="coverPage">Cover Page: </label> <input type="file" class="inputFile" name="coverPage" id="coverPage"></p>
                        <p><label class="inputFileLabel" for="criticalIncident">Critical Incident: </label> <input type="file" class="inputFile" name="criticalIncident" id="criticalIncident"></p>
                        <p><label class="inputFileLabel" for="teachingNotes">Teaching Notes: </label> <input type="file" class="inputFile" name="teachingNotes" id="teachingNotes"></p>
                        <p><label class="inputFileLabel" for="memo">Memo: </label> <input type="file" class="inputFile" name="memo" id="memo"></p>
                        <p><label class="inputFileLabel" for="summary">Summary: </label> <input type="file" class="inputFile" name="summary" id="summary"></p>-->
                        <input class="regular required" placeholder="Key Words (Optional, Comma seperated)" type="text" name="keywords" id="keywords"></p>
                        <textarea class="regular abstract" placeholder="Abstract" name="abstract" id="abstract" rows="10" cols="50" maxlength="300"></textarea><br>
                        <span id="remaining_characters">There is a 300 Character limit</span><p>
                        <p><input type="submit" class="author" value="Submit Critical Incident" name="submit"></p>
                    </form>
                    <!--<script type="text/javascript"> var formValidator  = new Validator("submit_criticalIncident");
                        formValidator.EnableMsgsTogether();

                        formValidator.addValidation("title", "req", "Please enter a title");//Title required

                        //Cover Page validation
                        formValidator.addValidation("coverPage","file_extn=doc;docx;rtf","Allowed files types for cover letter are: .doc, .docx, and .rtf");//check file type
                        formValidator.addValidation("coverPage","req_file","Cover Page is required");//Cover letter required
                        //Critical Incident validation
                        formValidator.addValidation("criticalIncident","file_extn=doc;docx;rtf","Allowed files types for criticalIncident are: .doc, .docx, and .rtf");//Check file type
                        formValidator.addValidation("criticalIncident","req_file","Critical Incident is required");//Critical Incident required
                        //Teaching notes validation
                        formValidator.addValidation("teachingNotes","file_extn=doc;docx;rtf","Allowed files types for Teaching notes are: .doc, .docx, and .rtf");//Check file type
                        formValidator.addValidation("teachingNotes","req_file","Teaching Notes are required");//teachingNotes required
                        //Memo validation
                        formValidator.addValidation("memo","file_extn=doc;docx;rtf","Allowed files types for Memo are: .doc, .docx, and .rtf");//Check file type
                        formValidator.addValidation("memo","req_file","Memo is required");//memo required
                        //summary validation
                        formValidator.addValidation("summary","file_extn=doc;docx;rtf","Allowed files types for summary are: .doc, .docx, and .rtf");//Check file type
                    </script>-->
                </div>
            <?php } else { echo '<div class="contentwidth"><div class="row flush"><div class="col s7"><p>You do not have permission</p>'; }?>
        </div>
        <!--Sidebar-->
        <?php include 'includes/sidebar.php'; ?>
    </div>
</div>
<!--Footer-->
<?php include 'includes/footer.php'; ?>
