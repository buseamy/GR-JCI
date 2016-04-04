 <?php
/*
* @File Name:		teachingnotes.php
* @Description: 	
* @PHP version: 	Currently Unknown
* @Author(s):		
* @Organization:	Ferris State University
* @Last updated:	
*/

/*
 * The purpose of this file is to display page title, meta information, include links to
 * style sheets, and contain the site navigation.
 
 
 			if($_SESSION['iseditor'] > -1) {
					 <li><a class="white" href="editor_index.php">Editor</a></li> <!--Editor page-->
				}
				else {
					<li><a class="white" href="login_page.php">Login</a></li>; <!--Login page-->
				}
 */

// Include the header:
$page_title = 'Teaching Notes';
include ('includes/header.php');
?>


<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
			<h1>Purchasing Information for Teaching Notes</h1>
			<!--Page main body-->
			<div id="home_about">
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
				incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
				exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
				Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
				incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
				exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor 
				incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud 
				exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
			</div>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>
</div>
<?php include ('includes/footer.php'); ?>
