<?php 
/*
* @File Name:       submit_case.php
* @Description:     Home page for JCI website
* @PHP version:     Currently Unknown
* @Author(s):       Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/05/2016
*/

/*
 * The purpose of this file is to allow the authors 
 * to submit a case with all required materials. 
 */

//Title to be displayed for the page    
$page_title = 'JCI Website - Submit a case';

// Call to the site header
include ('./includes/header.php');
?>
<!--Form scripts-->
<script src="js/addAuthor.js" language="Javascript" type="text/javascript"></script>
<script type="text/javascript" src="js/form_validator.js"></script>

<div id="home-body" class="span8">
    <h1>Submit a case to the Journal of Critical Incidents</h1>
    <!--Page main body-->
    <div id="registration-form">
        <form id="submit_case" action="">
            <p><label for="memberCode">Member Code: </label> <input type="text" name="memberCode" id="memberCode" size="30" maxlength="60"></p>
            <p><label for="title">Title: <span class="required">*</span> </label> <input type="text" name="title" id="title" size="30" maxlength="100"></p>
            <div id="dynamicAuthor">
                <p>
                    <label for="author">Author: <span class="required">*</span> </label> <input type="text" id="author" size="30" maxlength="100" name="authors"> 
                    <input type="button" value="Add another author" onClick="addInput('dynamicAuthor');">
                </p>
            </div>
            
            <h3>Please provide all the following documents:</h3><br>
            <p><label for="coverLetter">Cover Letter: <span class="required">*</span> </label> <input type="file" class="inputFile" name="coverLetter" id="coverLetter"></p>
            <p><label for="case">Case: <span class="required">*</span> </label> <input type="file" class="inputFile" name="case" id="case"></p>
            <p><label for="teachingNotes">Teaching Notes: <span class="required">*</span> </label> <input type="file" class="inputFile" name="teachingNotes" id="teachingNotes"></p>
            <p><label for="memo">Memo: <span class="required">*</span> </label> <input type="file" class="inputFile" name="memo" id="memo"></p>
            <p><label for="summary">Summary: <span class="required">*</span> </label> <input type="file" class="inputFile" name="summary" id="summary"></p>
            <p><input type="submit" value="submit"></p>
        </form>
        <script type="text/javascript"> var formValidator  = new Validator("submit_case");
            formValidator.EnableMsgsTogether();
            
            formValidator.addValidation("title", "req", "Please enter a title");//Title required
            formValidator.addValidation("author", "req", "Please enter an author");//author required

            
            //Cover Letter validation
            formValidator.addValidation("coverLetter","file_extn=pdf;doc;docx","Allowed files types for cover letter are: .doc, .docx, and .pdf");//check file type
            formValidator.addValidation("coverLetter","req_file","Cover Letter is required");//Cover letter required
            //Case validation
            formValidator.addValidation("case","file_extn=pdf;doc;docx","Allowed files types for case are: .doc, .docx, and .pdf");//Check file type
            formValidator.addValidation("case","req_file","Case is required");//Case required
            //Teaching notes validation
            formValidator.addValidation("teachingNotes","file_extn=pdf;doc;docx","Allowed files types for Teaching notes are: .doc, .docx, and .pdf");//Check file type
            formValidator.addValidation("teachingNotes","req_file","Teaching Notes are required");//teachingNotes required
            //Memo validation
            formValidator.addValidation("memo","file_extn=pdf;doc;docx","Allowed files types for Memo are: .doc, .docx, and .pdf");//Check file type
            formValidator.addValidation("memo","req_file","Memo is required");//memo required
            //summary validation
            formValidator.addValidation("summary","file_extn=pdf;doc;docx","Allowed files types for summary are: .doc, .docx, and .pdf");//Check file type
            formValidator.addValidation("summary","req_file","Summary is required");//summary required
        </script>
    </div>
</div>
<!--Side bar-->
<aside class="span4">
	<h2>Resources</h2>
    <ul>
        <li><a href="#">Resource 1</a></li>
        <li><a href="#">Resource 2</a></li>
        <li><a href="#">Resource 3</a></li>
        <li><a href="#">Resource 4</a></li>
        <li><a href="#">Resource 5</a></li>
    </ul>
    <br>
    <h2>Important Dates:</h2>
    <p>Submission Deadline: September 1st</p>
    <p>Journal Publication: October 31st</p>
    <br>
    <h2>Important Information</h2>
    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
</aside>

<?php include 'includes/footer.php'; ?>

