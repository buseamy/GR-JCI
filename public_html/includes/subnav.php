<!--This navigation will only be available once a user is logged in-->

    <img class="responsive" src="images/wood_image.jpg" alt="conference">
    <div class="dashcontent">
         <div class="dashboardnav">
            <ul class="row dashnav">
                <li class="homeicon col s1 active nomargin"> <a href="dashboard.php"><img id="dashboardicon" src="images/homeicon.png"></a></li>
                <li class="col s1 nomargin nomobile"></li>
                <?php
                if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1){
                    echo '<li class="editor col s2 nomargin" id="editor"><a href="editor_incident_management.php">Editor</a></li>';
                }
                if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1){
                    echo '<li class="author col s2 nomargin" id="author"><a href="author_incident_management.php">Author</a></li>';
                }
                if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1){
                    echo '<li class="reviewer col s2 nomargin" id="reviewer"><a href="reviewer_incident_management.php">Reviewer</a></li>';
                }?>
            </ul>
		</div>
