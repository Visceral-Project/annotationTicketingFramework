<?php
require_once('auth.php');
require_once('HelperFunctions.php');

include_once('header.php');
?>

	
	<div class="maincontent">
		<div class="content">
			<article class="topcontent">
				<header>
					<?php
					// print hello message
					$dbFirstName = $_SESSION['firstName'];
					echo "<h2>Hello " . $dbFirstName . "</h2>";
					?>
				</header>
				
				<footer>
					<p class="post-info">Welcome to the VISCERAL annotation submission system!</p>
				</footer>

				<content>
					<?php
					// print login data
					$username = $_SESSION['username'];
					echo "<p> You are currently logged in as <b>" . $username . "</b>.</p>"
					?>
					<p>Please got to <a href="AnnotationSubmission.php">Annotation Submission</a> and submit your pending annotations.</p>
					<p>If you are for any reason not available please change your availability status at <a href="UserSettings.php">User Settings</a>.
                       This helps us to take your status into account when creating new annotation tickets or to re-assign your pending tickets
                        to another available annotator. You can also change your password there.</p>
				</content>
			</article>

		</div>
	</div>

<?php
include_once('footer.php');
?>