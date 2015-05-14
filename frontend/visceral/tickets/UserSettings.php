<?php
require_once('auth.php');
require_once('HelperFunctions.php');

include_once('header.php');
?>

	<div class="maincontent">
		<div class="content">
			<div class="usersettings">

			<?php

			// establish connection to visceral db
			$con = getDBConnection();

			// boolean flag if db (availability) was changed
			$changed = 0;

			// get session user
			$annotatorID = $_SESSION['annotatorID'];
		
			// change status of annotator when submitt button pressed
			if(isset($_POST['update']))
			{
			
				// get value of checkbox
				$cbValue = $_POST['cbAvailable'];
			
				if ( $cbValue == 'Yes' ) {
					$available = 1;
				} else {
					$available = 0;
				}

				// compile update statement
				$sql = "update annotator set available=" . $available . " where annotatorID=" . $annotatorID;

				// run update statement and check if it worked
				$retval = mysqli_query($con,$sql);
				if(! $retval )
				{
				  die('Could not update data: ' . mysql_error());
				}
				$changed = 1;
			}
		
			// fetch user data
			$result = mysqli_query($con,"SELECT * FROM annotator where annotatorID=" . $annotatorID);
			$row = mysqli_fetch_array($result);

			// get status of annotator and set check box accordingly
			$available = $row['Available'];
			if ($available == 1) {
				$checked = " checked";
			} else {
				$checked = "";
			}

			// print form for user data presentation
			echo "<form action='UserSettings.php' method='post'>";
			
			echo "<table>";
			echo "<tr><td><b>AnnotatorID: </b></td><td>" . $row['AnnotatorID'] . "</td></tr>";
			echo "<tr><td><b>Contact Info: </b></td><td>" . $row['ContactInfo'] . "</td></tr>";
			echo "<tr><td><b>First-Name: </b></td><td>" . $row['FirstName'] . "</td></tr>";
			echo "<tr><td><b>Sur-Name: </b></td><td>" . $row['SurName'] . "</td></tr>";
			echo "<tr><td><b>Available:  </b></td>";
			echo "<td><input type='checkbox' name='cbAvailable' value='Yes'". $checked ."></td></tr>";
			echo "<tr><td><b>doing Quality Check:</b></td><td>" . ($_SESSION['isQC'] == 1 ? "yes" : "no") ."</td></tr>";
			echo "</table>";
		
			echo "<br>";
			echo "<input name='update' type='submit' id='update' value='Change Available'>";
			echo "</form>";
			
			// close database connection
			mysqli_close($con);

			// print status of the update process
			if(isset($_POST['update']))
			{
				if ( $changed == 1 ) {
					if ($available == 1)
						echo "Status was changed successfully to <b>available</b>!";
					else
						echo "Status was changed successfully to <b>not available</b>!";
				}
			}
			?>

			<hr>

			<h3>Change Password</h3>
			<form action='UserSettings.php' method='post'>
			<table>
			<tr><td><b>Old Password: </b></td><td><input type="password" name="passwortOld" /></td></tr>
			<tr><td><b>New Password: </b></td><td><input type="password" name="passwortNew1" /></td></tr>
			<tr><td><b>New Password: </b></td><td><input type="password" name="passwortNew2" /></td></tr>
			</table>
			<br>
			<input name='change' type='submit' id='change' value="Change Password"><br>
			</form>
			
			<?php
			if(isset($_POST['change'])) {
				
				// get username from session
				$username = $_SESSION['username'];
				
				// get annotator id from session
				$annotatorID = $_SESSION['annotatorID'];

				// establish connection to visceral db
				$con = getDBConnection();

				// get old password from db
				$result = mysqli_query($con,"SELECT Password FROM annotator where contactinfo='" . $username . "'");
				$row = mysqli_fetch_array($result);				
				$dbPwd = $row[0];

				// compute hash values of the passwords
				$passwordOld = sha1($_POST['passwortOld']);
				$passwortNew1 = sha1($_POST['passwortNew1']);
				$passwortNew2 = sha1($_POST['passwortNew2']);

				// check if the old password is correct
				if ( $dbPwd == $passwordOld) {

					// check if the user entered the same new password twice
					if ( $passwortNew1 == $passwortNew2 ) {
						
						// change password in database
						$sql = "update annotator set Password='" . $passwortNew1 . "' where annotatorID=" . $annotatorID;
						$retval = mysqli_query($con,$sql);
						if( ! $retval )
						{
						  die('Could not update data: ' . mysql_error());
						} else {
							echo "Your password was changed successfully!";
						}

					} else {
						echo "Please enter the same password twice!";
					}
				} else {
					echo "Old password not correct!";
				}
			}
			?>

			</div>
		</div>
	</div>
<?php
include_once('footer.php');
?>