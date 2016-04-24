<?php
/*
* @File Name:       about.php
* @Description:     About page for JCI website
* @PHP version:     Currently Unknown
* @Author(s):		Rui Takagi
* @Organization:    Ferris State University
* @Last updated:    4/9/2016
*/

//Title of the page
$page_title = 'About';

// Call to the site header
include ('./includes/header.php');
?>
<div class="content">
    <img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>
<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
            <h1>About the Journal</h1>
            <!--Page main body-->
            <div id="home_about">
                <h2>JCI Mission</h2>
				<p> The <i>Journal of Critical Incidents</i> does not publish long cases. <i>JCI's</i> focus is on brief incidents that tell about real situation in a 
				real organization. The incident tells a story about an event, an experience, a blunder, or a success. Unlike a long case, the incident does 
				not provide historical detail or how the situation developed. Rather, it provides a snapshot that stimulates student use of their knowledge 
				to arrive at a course of action or analysis. Critical incidents can be based on either field work or library research. The maximum length of 
				the Critical incidents is three single-spaced pages. See the Style Guide for layout and submission requirements. If you are interested in joining 
				SCR, publishing in one of the journals or contacting the Officers of the Society, go to <a href="www.sfcr.org">www.sfcr.org</a>. </p>
			
				
				<!--<h2>Letter from the Editor</h2>-->
				
				<h2>Policies</h2>
				<li><a href="editorial_policy.php">Editorial Policy</a></li>
				<li><a href="editorial_policy.php#ethics_malpractice">Publication Ethics Policy and User Responsibilities</a></li>

				<h2>People</h2>
				<li><a href="https://www.sfcr.org/docs/officers.pdf" target="_blank">Society for Case Research Officers and Editorial Board Members </a></li>
				
				<h2>Teaching Notes</h2>
				<p>Please contact Joanne Tokle <b>(tokljoan@isu.edu)</b> to purchase copies of Teaching Notes.</p>
				
				<h2>Other resources</h2>
				<li><a href="https://ssl2.cabells.com/" target="_blank">Cabell International's Site</a></li>
				
				
				<p>Please <a href="contact.php">contact us</a> if you have any questions. </p>
            </div>
        </div>

        <!--Sidebar-->
        <?php  include 'includes/sidebar.php';?>
    </div>
</div>
<!--Footer-->
<?php include 'includes/footer.php'; ?>
