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
<script src="./js/formJS.js" language="Javascript" type="text/javascript"></script>
<script type="text/javascript" src="./js/form_validator.js"></script>
<script type="text/javascript" src="./js/jcf.file.js"></script>
<script type="text/javascript" src="./js/jcf.js"></script>

</script>

</script>
<div id="home-body" class="span7">
    <?php if (isset($_SESSION['isAuthor'])) { // Only display if logged in role is author ?>
        <div class="contentwidth">
            <div class="row flush">
                <div class="col s7">
                    <h1>Submit a case to the Journal of Critical Incidents</h1>
                    <!--Page main body-->
                    <div id="registration-form">
                        <form class="submitform" id="submit_criticalIncident" action="process_critical_incident.php" method="post">
                            <input class="regular required" placeholder="Title" type="text" name="title" id="title" size="30" maxlength="100">
                            <div id="dynamicAuthor">
                                <div>
                                    <h3>Author</h3>
                                    <input class="regular required" placeholder="SCR Member Code" type="text" name="memberCode" id="memberCode" size="30" maxlength="60">
                                    <input class="regular required" placeholder="Email" type="text" id="email" size="30" maxlength="100" name="email">
                                    <input class="regular required" placeholder="First Name" type="text" id="authorFirst" size="30" maxlength="100" name="authorFirst">
                                    <input class="regular required" placeholder="Last Name" type="text" id="authorLast" size="30" maxlength="100" name="authorLast">
                                </div>
                            </div>
                            <button class="author" type="button" onClick="addInput('dynamicAuthor');">Add another author</button>
                            <p><input type="hidden" name="counter" id="counter" value="1"></p>
                            <?php
                            // replace hardcoded inputs with ones generated using the FileTypes table
                            // currently, the only access to this list is from spGetFileTypes by providing RoleID (Author role)
                            ?>
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
                                    <span class="jcf-button-content">Choose Summary</span>
                                </span>
                                <input name="summary" id="summary" type="file" class="author jcf-real-element" style="position: absolute; opacity: 0;">
                            </span><br>

                            <!--<p><label class="inputFileLabel" for="coverPage">Cover Page: </label> <input type="file" class="inputFile" name="coverPage" id="coverPage"></p>
                            <p><label class="inputFileLabel" for="criticalIncident">Critical Incident: </label> <input type="file" class="inputFile" name="criticalIncident" id="criticalIncident"></p>
                            <p><label class="inputFileLabel" for="teachingNotes">Teaching Notes: </label> <input type="file" class="inputFile" name="teachingNotes" id="teachingNotes"></p>
                            <p><label class="inputFileLabel" for="memo">Memo: </label> <input type="file" class="inputFile" name="memo" id="memo"></p>
                            <p><label class="inputFileLabel" for="summary">Summary: </label> <input type="file" class="inputFile" name="summary" id="summary"></p>-->
                            <input class="regular required" placeholder="Key Words (Comma seperated)" type="text" name="keywords" id="keywords"></p>
                            <textarea class="regular abstract" placeholder="Abstract" name="abstract" id="abstract" rows="10" cols="50" maxlength="300"></textarea><br>
                            <span id="remaining_characters">There is a 300 Character limit</span><p>
                            <p><label style="width:1000px;" class="inputFileLabel" for="submit">Submit Critical Incident</label> <input class="inputFile" type="submit" value="submit" name="submit"></p>
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
        </div>
    </div>
<!--Footer-->
<?php include 'includes/footer.php'; ?>
