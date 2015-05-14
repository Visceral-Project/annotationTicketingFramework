<?php

// external includes
require_once('HelperFunctions.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

	session_start();

	$username = $_POST['username'];
	$password = $_POST['passwort'];

	// compute sha1 hash of password
	$passwordHash = sha1($password);

	$hostname = $_SERVER['HTTP_HOST'];
	$path = dirname($_SERVER['PHP_SELF']);

	// establish connection to visceral db
	$con = getDBConnection();

	// check username and password
	$result = mysqli_query($con,"SELECT * FROM annotator where contactinfo='" . $username . "'");
	
	$row = mysqli_fetch_array($result);
	
	$dbUsername = $row['ContactInfo'];
	$dbAnnotatorID = $row['AnnotatorID'];
	$dbFirstName = $row['FirstName'];
	$dbSurName = $row['SurName'];
	$dbPassword = $row['Password'];
	$dbQC = $row['Qc'];

	mysqli_close($con);

	// if ok proceed to main page
	if ($dbUsername == $username && $dbPassword == $passwordHash) {
		
		$loginInvalid = 1;

		// preserve session data
		$_SESSION['angemeldet'] = true;
		$_SESSION['username'] = $dbUsername;
		$_SESSION['annotatorID'] = $dbAnnotatorID;
		$_SESSION['firstName'] = $dbFirstName;
		$_SESSION['surName'] = $dbSurName;
		$_SESSION['isQC']= $dbQC;


		// go to main page
		if ($_SERVER['SERVER_PROTOCOL'] == 'HTTP/1.1') {
			if (php_sapi_name() == 'cgi') {
				header('Status: 303 See Other');
			}
			else {
				header('HTTP/1.1 303 See Other');
			}
		}

		header('Location: http://'.$hostname.($path == '/' ? '' : $path).'/index.php');
		exit;
	}
	else {
		$loginInvalid = 0;
	}
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
	<head>
		<title>VISCERAL Annotation System</title>
		<meta charset="utf-8" />

		<link rel="stylesheet" href="style.css" type="text/css" />
		<meta name="viewport" content="witdth-device-width, initial-scale=1.0"/>
	</head>
	<body>
		<div class="login">
			<img src="img/logo.gif">
			<h3>Welcome to the VISCERAL Annotation Submission System!</h3>
			<form action="login.php" method="post">
				<table border='0'>
				<tr><td>E-Mail:</td><td><input type="text" name="username" /></td></tr>
				<tr><td>Password:</td><td><input type="password" name="passwort" /></td></tr>
				<tr><td></td><td><input type="submit" value="Login" /></td></tr>
				</table>
			</form>
			<?php
				if ($_SERVER['REQUEST_METHOD'] == 'POST') {
					if ($loginInvalid==0) echo "<br><b>Login data invalid!</b><br>";
				}
			?>
			<p>Copyright &copy; Matthias Dorfer @ CIR 2013</p>
		</div>
	</body>
</html>
