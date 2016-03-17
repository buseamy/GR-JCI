<?php $page_title = 'JCI Website - Submit a Critical Incident';

/*
 * The purpose of this file is to allow the authors
 * to submit a case with all required materials.
 */

 require ('../mysqli_connect.php'); // Connect to the database
 require ('./includes/header.php'); // Include the site header
 require ('./include_utils/procedures.php'); // complete_procedure()

?>
<!--Form scripts-->
<script src="js/formJS.js" language="Javascript" type="text/javascript"></script>
<script type="text/javascript" src="js/form_validator.js"></script>
<div id="home-body" class="span8">
    <?php if (isset($_SESSION['isAuthor'])) { // Only display if logged in role is author ?>
        <h1>Submit a case to the Journal of Critical Incidents</h1>
        <!--Page main body-->
        <div id="registration-form">
            <form id="submit_criticalIncident" action="process_critical_incident.php" method="post">
                <p><label for="title">Title: <span class="required">*</span> </label> <input type="text" name="title" id="title" size="30" maxlength="100"></p>
                <div id="dynamicAuthor">
                    <div>
                        <h3>Author</h3>
                        <p><label for="memberCode">SCR Member Code: </label> <input type="text" name="memberCode" id="memberCode" size="30" maxlength="60"></p>
                        <p><label for="email">Email: <span class="required">*</span></label> <input type="text" id="email" size="30" maxlength="100" name="email"></p>
                        <p><label for="authorFirst">First Name: <span class="required">*</span> </label> <input type="text" id="authorFirst" size="30" maxlength="100" name="authorFirst"></p>
                        <p><label for="authorLast">Last Name: <span class="required">*</span></label><input type="text" id="authorLast" size="30" maxlength="100" name="authorLast"></p>
                    </div>
                </div>
                <p><input type="button" value="Add another author" onClick="addInput('dynamicAuthor');"><p>
                <p><input type="hidden" name="counter" id="counter" value="1"></p>
                <h3>Please provide all the following documents:</h3><br>
                <p><label for="coverPage">Cover Page: <span class="required">*</span> </label> <input type="file" class="inputFile" name="coverPage" id="coverPage"></p>
                <p><label for="criticalIncident">Critical Incident: <span class="required">*</span> </label> <input type="file" class="inputFile" name="criticalIncident" id="criticalIncident"></p>
                <p><label for="teachingNotes">Teaching Notes: <span class="required">*</span> </label> <input type="file" class="inputFile" name="teachingNotes" id="teachingNotes"></p>
                <p><label for="memo">Memo: <span class="required">*</span> </label> <input type="file" class="inputFile" name="memo" id="memo"></p>
                <p><label for="summary">Summary: </label> <input type="file" class="inputFile" name="summary" id="summary"></p>
                <p><label for="keywords">Key Words (Comma seperated): </label> <input type="text" name="keywords" id="keywords"></p>
                <p><label for="abstract">Abstract: </label><br>
                <textarea class="abstract" name="abstract" id="abstract" rows="10" cols="50" maxlength="300"></textarea><br>
                <span id="remaining_characters">There is a 300 Character limit</span><p>
                <p><input type="submit" value="submit" name="submit"></p>
            </form>
            <!--<script type="text/javascript"> var formValidator  = new Validator("submit_criticalIncident");
                formValidator.EnableMsgsTogether();

                formValidator.addValidation("title", "req", "Please enter a title");//Title required
                formValidator.addValidation("email", "req", "Please enter an email");//author required
                formValidator.addValidation("authorFirst", "req", "Please enter an author first name");//author required
                formValidator.addValidation("authorLast", "req", "Please enter an author last name");//author required

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
    <?php } else { echo "<p>You do not have permission</p>"; }?>
</div>

<!--Sidebar-->
<?php include 'includes/sidebar.php'; ?>
<!--Footer-->
<?php include 'includes/footer.php'; ?>
