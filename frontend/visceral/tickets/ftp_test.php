<?php
include('HelperFunctions.php');
include_once('Config.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
	<head>
		<title>VISCERAL FTP Test</title>
		<meta charset="utf-8" />

		<link rel="stylesheet" href="style.css" type="text/css" />
		<meta name="viewport" content="witdth-device-width, initial-scale=1.0"/>
	</head>
	<body>

	<?php
        $config = visceral\Config::getFTPHostConfig();
		// move file to hesso ftp server
		$conn = ftp_connect($config['host']) or die("Could not connect to HESSO ftp server!");
		
		if ( ftp_login($conn, $config['user'], $config['passwd']) )
    	{
			ftp_pasv ( $conn , true );
			echo "Login on Hesso ftp<br>";
			
		    // Change the directory
			if ( ftp_chdir($conn, "volumes_for_annotation/manual_annotations") ) {
				echo "Directory changed<br>";
				
				// create file to server
        		if ( ftp_put($conn, "test_upload.php", "ftp_test.php", FTP_BINARY) ) {
					echo "File put to server<br>";
				} else {
					echo "File can't be put to server<br>";
				}

			} else {
				echo "Directory change not possible<br>";
			}

    	} else {
			echo "Login not possible<br>";
		}
		
		ftp_close($conn);

		/* ftp_chdir($conn, "visceral-dataset"); 
		$retval = ftp_put($conn, $selectedTicket . "nii", $_FILES["file"]["tmp_name"], FTP_ASCII);
		ftp_close($conn);

		if(! $retval )
		{
		  die("<br><b>Status:</b> Could not submit ticket to ftp server!">);
		} else {

			echo "<br><b>Status:</b> Ticket status successfully submitted to ftp server!";
		}
		*/
	?>

	</body>
</html>
