<!--This navigation will only be available once a user is logged in-->
<div id="subnav" class="subnav span9">
    <ul>
        <?php
        if (isset($_SESSION['UserID']) && $_SESSION['isEditor'] == 1){
            echo '<li><a class="editor" href="editor_incident_management.php">Editor</a></li>';
        }
        if (isset($_SESSION['UserID']) && $_SESSION['isAuthor'] == 1){
            echo '<li><a class="author" href="author_incident_management.php">Author</a></li>';
        }
        if (isset($_SESSION['UserID']) && $_SESSION['isReviewer'] == 1){
            echo '<li><a class="reviewer" href="reviewer_incident_management.php">Reviewer</a></li>';
        }
        ?>
    </ul>
</div>
