<?php
/*
* @File Name:       index.php
* @Description:     Home page for JCI website
* @PHP version:     Currently Unknown
* @Author(s):		Jacob Cole <colej28@ferris.edu>
* @Organization:    Ferris State University
* @Last updated:    02/05/2016
*/

/*
 * The purpose of this file is to acts as a placeholder for the final JCI homepage.
 * The index file will contain an includes for the header and footer.
 */

//Title to be displayed for the page
$page_title = 'JCI Website - Home';

// Call to the site header
include ('./includes/header.php');
?>

<div id="mainhead" class="span8">
    <h1>Journal of Critical Incidents</h1>
    <!--Page main body-->
    <div id="home_about">
        <p>The <i>Journal of Critical Incidents</i> does not publish long cases. JCI's focus is on brief incidents that tell about real situation in a real organization.  The incident tells a story about an event, an experience, a blunder, or a success.   Unlike a long case, the incident does not provide historical detail or how the situation developed.  Rather, it provides a snapshot that stimulates student use of their knowledge to arrive at a course of action or analysis.</p>
        <p>Critical incidents can be based on either field work or library research.   The maximum length of the Critical incidents is three single-spaced pages.  See the Style Guide for layout and submission requirements.</p>
        <p>A Teaching Note must be submitted with the critical incident.  The quality of the teaching note is a central factor in review and acceptance process.  Teaching notes are not published in JCI.  They are archived by the Society for Case Research and are available for purchase by adopters of published Critical Incidents.  Copies of the Teaching Note are provided free of charge to the author[s] and members of their personnel, promotion, and tenure committees.</p>
        <p>The first step in the JCI publication process is to present a draft of the Critical Incident in the Case Research Track at the Annual MBAA International meeting.  Critical Incidents receive feedback from session discussants.  After the MBAA presentation, authors may elect to submit the Critical Incident to the JCI Editor.  Submissions are double-blind peer reviewed.  </p>
        <p>The Journal of Critical Incidents is listed in Cabels and is published annually in October.</p>
        <p><b>Editor</b></p>
        <p>Timothy Brotherton</p>
        <p> For additional information, visit our website, <a href="www.sfcr.org">www.sfcr.org</a>, or contact the Editor directly.</p>
        <p>*Source: <a href="http://www.sfcr.org/jci">sfcr.org/jci</a></p>
    </div>
</div>
<!--Side bar-->
<aside class="span4">
	<h2>Resources</h2>
    <ul>
        <li><a href="submit_case.php">Submit a case</a></li>
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
