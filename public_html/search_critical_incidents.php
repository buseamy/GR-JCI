<?php $page_title = 'JCI Website - Search Critical Incidents'; 
// search critical incidents.php Written by Jamal Ahmed
// Cards for this page include view published journal, download publish journal, search critical incidents
	require ('./includes/header.php'); // Include the site header
	$case_list = array();
	$errors = array(); // Initialize an error array.
	
	require('../mysqli_connect.php');
	require('./include_utils/procedures.php');
	require('./include_utils/files.php');
	
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
		
$case_title = trim($_POST['case_title']);
$keyword = trim($_POST['keyword']);
$author = trim($_POST['author']);
$category = trim($_POST['category']);

	// This checks if anything was entered in the textbox
	if ((empty($_POST['case_ID'])) && (empty($_POST['case_title'])) && (empty($_POST['keyword']))
	&& (empty($_POST['author'])) && (empty($_POST['category']))) {
		$errors[] = 'You forgot to enter a search criteria please enter one.';
	}

	// if nothing is entered give an error message. This will handle if only spaces are entered
	else if ((empty($case_title)) && (empty($keyword))
		&& (empty($author)) && (empty($category))) {
			$errors[] = 'You forgot to enter a search criteria please enter one.';
		}
/*
foreach($_POST as $key => $value){
	echo"key:$key   value:$value  ";
}
*/
	
	/*
	if (isset($_POST['case_ID'])) {
		$case_ID = mysqli_real_escape_string($dbc, trim($_POST['case_ID']));
		if (empty($case_ID )) {
			$case_ID = '%';
		}
	} else {
		$case_ID = '%';
	}
	*/
	// if nothing is entered in to the field put in a wildcard operator which allows any value to be selected
	// The query uses an AND operator so it will search on all fields at least one textfield need to be entered
	if (empty($_POST['case_title'])) {
		$case_title = '%';
	} else {
		$case_title = mysqli_real_escape_string($dbc, trim($_POST['case_title']));
	}

	if (empty($_POST['keyword'])) {
		$keyword = '%';
	} else {
		$keyword = mysqli_real_escape_string($dbc, trim($_POST['keyword']));
	}

	if (empty($_POST['author'])) {
		$author = '%';
	} else {
		$author = mysqli_real_escape_string($dbc, trim($_POST['author']));
	}

	if (empty($_POST['category'])) {
		$category = '%';
	} else {
		$category = mysqli_real_escape_string($dbc, trim($_POST['category']));
	}
	
	
	

	// run only if one or more fields has been entered
	if (empty($errors)) {
/*
This was written in Sprint 1 and replaced by Stored procedure when created in Sprint 5

	// select statement joining user table to submission and category table
	// using like instead of = because it allows the wildcard to be used
	$q = "select Abstract from Users u INNER JOIN AuthorsSubmission asub ON u.UserID = asub.UserID
	INNER JOIN Submissions s ON asub.SubmissionID = s.SubmissionID INNER JOIN SubmissionCategories sc ON s.SubmissionID = sc.SubmissionID
	INNER JOIN Categories c ON sc.CategoryID = c.CategoryID
	where SubmissionID like $case_ID AND CaseTitle like $case_title
	AND Keywords like $keyword AND (select FirstName, LastName from Users) like $author AND Category like $category" ;
*/

//echo "$case_title', '$keyword', '$author', '$category";
	
	//echo "$q_search";
	// http://stackoverflow.com/questions/20300582/display-sql-query-results-in-php source
	// $r_search = @mysqli_query ($dbc, $q_search); // Run the query.
	//  if results found
	
	$q_search = "CALL spSearchIncidents ('$case_title', '$keyword', '$author', '$category' ); " ;
	$r_search = mysqli_query($dbc, $q_search);
	
		
		// if results are found
		if (mysqli_num_rows($r_search) > 0) {
			
		
	
	
	//dispay results
		while($case_row = mysqli_fetch_array($r_search, MYSQLI_ASSOC)) {
			array_push($case_list, $case_row);
			// print_r($case_row);
			

		}
	}
	else {
		  $errors[] = 'No results Found' ;
		
	}
	
	/* To see errors in the database
	else {
		echo '<p>'.$dbc->error.' </p>' ;
	}
	*/
	
	
	complete_procedure($dbc);
	} 


}
?>
<div class="content">
	<img class="responsive" src="images/glasses.jpg" alt="reading glasses and book">
</div>

<div class="contentwidth">
    <div class="row flush">
        <div class="col s7">
<?php
// Error message modified From Isys288 register page
if (!empty($errors)) {
                echo '<div>';
                echo '<p class="error"><br />';
                foreach ($errors as $msg) { // Print each error.
                    echo "$msg<br />";
                }
                echo '</p>';
                echo '</div>';
}
?>
			<div class="guest frame1">
				<h1 class="title" align="center">JCI JOURNAL OF CRITICAL INCIDENTS</h1>
			</div>
			<?php
			/*
			$q_publications = "CALL spGetPublicationsYearsList ; " ;
			$r_publications  = mysqli_query($dbc, $q_publications);
			while($row_publications = mysqli_fetch_array($r_publications, MYSQLI_ASSOC)) {
				$years = $row_publications['Year'];
				echo $years;
			}
			<li class=""><a href="#/">2015</a></li>
			             <li class="active"><a href="#/">2014</a></li>
			             <li class=""><a href="#/">2013</a></li>
			             <li class=""><a href="#/">2012</a></li>
			             <li class=""><a href="#/">2011</a></li>
			             <li class=""><a href="#/">2010</a></li>
			             <li class=""><a href="#/">Earlier</a></li>
				*/
				/*
				$years = mysqli_query($dbc, "Call spGetPublicationsYearsList();");
                        complete_procedure($dbc);
                        
                        //Dispay the list of states
                        echo '<option value="$years">Select the Year</option>';
                        while($row = $years->fetch_assoc()) {
                            echo '<option value="'.$row["FileMetaDataID"].'"'.($row["Year"] == $years ? ' selected' : '').'>'.$row["Year"].'</option>';
                        }
					*/	
						
				
			// }
			?>
			<div class="row flush">
				<div class="side_nav col s2 guest_light">
				<div class="guest">
                		<h3 class="title">Download Published Journals By Year</h3>
            		</div>
	             	<ul>
					<?php
					// Storing value to variable in same line as query taken from jeff's register page
					$years = mysqli_query($dbc, "Call spGetPublicationsYearsList();");
                        complete_procedure($dbc);
                        
                        //Dispay the list of states
                      // echo '<option value="$years">Download a published journal</option>';
					  // This was taken from Jeff's Register page drop down boxes
                        while($row = $years->fetch_assoc()) {
							$ID = $row["FileMetaDataID"];
                            echo '<li class=""><a target=\"_blank\" href=\"download.php?fid='.$ID .'"><option value="'.$row["FileMetaDataID"].'">'.$row["Year"].'</a></li></option>';
                        }
					?>
			             
					</ul>
             		<div class="guest">
                		<h3 class="title">Search</h3>
            		</div>
		            <form class="archivesearch"action="" method="post">
						<input placeholder="Case Title" class="regular" type="text" name="case_title" size="15" maxlength="40" value="<?php if (isset($_POST['case_title'])) echo $_POST['case_title']; ?>" /><br>
						<input placeholder="Keywords" class="regular" type="text" name="keyword" size="20" maxlength="60" value="<?php if (isset($_POST['keyword'])) echo $_POST['keyword']; ?>"  /><br>
						<input placeholder="Author" class="regular" type="text" name="author" size="10" maxlength="20" value="<?php if (isset($_POST['author'])) echo $_POST['author']; ?>"  /><br>
						<input placeholder="Category" class="regular" type="text" name="category" size="10" maxlength="20" value="<?php if (isset($_POST['category'])) echo $_POST['category']; ?>"  /><br>
						<input type="submit" name="submit" value="search" /></p>
					</form>
				</div>
				<div class ="col s8"> 
				<?php
				// Mitch suggested using sizeof to only display table if results are returned.
				if(sizeof($case_list) > 0) {
					echo '<table>';
				echo '<tr>';
				echo '<th>Incident Title</th>';
				echo '<th>Author(s)</th>';
				echo '<th>Download</th>';
				echo '</tr>';
				
					/*
					echo '<p> case list size of'.sizeof($case_list).'</p>';
					foreach($case_list as $critical_incident) {
						echo '<p> critical incident size of'.sizeof($critical_incident).'</p>';
						foreach ($critical_incident as $key => $value) 
						{    
						echo "<p>Key-$key, Val-$value</p>";
						}
						*/
					foreach($case_list as $critical_incident) {
						
						$title = $critical_incident['IncidentTitle'];
						$Incident_ID = $critical_incident['CriticalIncidentID'];
						$authors = $critical_incident['Authors'];
						$meta_ID = $critical_incident['FileMetaDataID'];
						echo "<tr>";
						echo "<td>$title</td>";
						echo "<td>$authors</td>";
						echo "<td><a target=\"_blank\" href=\"download.php?fid=$meta_ID\">Download</a></td>"; // TODO: in the future change to create_download_link
						echo "</tr>";
						// echo "<p>Incident Title: $title Author(s): $authors </p>" ;
						
					}
					
					/*
					<object class="pdfviewer" data="files/jci2014.pdf" type="application/pdf">
					
		  				<p>Alternative text - include a link <a href="images/jci2014.pdf">to the PDF!</a></p>
					</object>  
					*/
					
					echo '</table>';
					}
					?>
				</div>
			</div>
		</div>
		<?php require 'includes/sidebar.php'; // Include sidebar ?>
	</div>

</div>
<?php require 'includes/footer.php'; // Include footer ?>
