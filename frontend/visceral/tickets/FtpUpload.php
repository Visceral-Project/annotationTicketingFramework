<?php
require_once('HelperFunctions.php');
require_once('Config.php');

set_include_path(get_include_path() . PATH_SEPARATOR . 'phpseclib');
include_once('Net/SSH2.php');
include_once('Net/SFTP.php');

function generateFilename($ticket) {

// $row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['Bodyregion'] . "_LMAnnotations" . "_" . $row['AnnotatorID'] . "'></td>";
#print_r($ticket);

  $part = "_";
  if(isset($ticket['FileNamePart']) && $ticket['FileNamePart'] != '') {
    $part = "_" . $ticket['FileNamePart'] . "_";
  }

  $structureIDPart = "";
  if( $ticket['AnnotationTypeID']>0){
      $structureIDPart = "_" . $ticket['AnnotationTypeID'] . "";
  }

  $name = $ticket['PatientID'] . "_" . $ticket['VolumeID'] . "_" . $ticket['Modality'] . "_" . $ticket['BodyRegion'] . $structureIDPart . $part . $ticket['AnnotatorID'];
  // echo "name: " . $name;
  return $name;
  
}

function uploadAnnotationFTP($dbConn, $selectedTicket)
{

  // parse ticket information
  $ticket = parseTicketID($selectedTicket);

  // fetch meta information about this annotation type
  $result = mysqli_query($dbConn, "SELECT * FROM annotationtype WHERE AnnotationTypeID=" . $ticket['AnnotationTypeID']);
  $typeRow = mysqli_fetch_array($result);
  
  $ticket += array('TypeName' => $typeRow['Name']);
  $ticket += array('FileNamePart' => $typeRow['FileNamePart']);
  $ticket += array('AnnotatorID' => $_SESSION['annotatorID']);


  // expected file extensions come from database
  $allowedExts = explode(",", $typeRow['FileExtension']);

  // build filenames for ftp transfer
  $localFile = $_FILES["file"]["tmp_name"];
  $extension = end(explode(".", $_FILES["file"]["name"],2));

  $remoteFile = generateFilename($ticket) . "." . $extension;

  // TO MODIFY!!
  // setup remote ftp dir
  $remoteDir = "PATH_OF_DATADIR_ON_FTP_SERVER" . $typeRow['RemoteUploadDir'];

  // check if upload to local server was successful
  $fileError = $_FILES["file"]["error"];

  /// check if file with correct extension was selected
  if (in_array($extension, $allowedExts)) {
      // check for file errors
      if ($fileError > 0) {
          echo "Return Code: " . $fileError . "<br>";
      } else {

          $config = visceral\Config::getSFTPHostConfig();
          // move file to OPTIMA sftp server
          // $ftpConn = ftp_connect($config['host']) or die("Could not connect to OPTIMA sftp server!");
		  
		  $sftp = new Net_SFTP($config['host']);
		  
		  if ($sftp->login($config['user'], $config['passwd'])) {
		  	//echo "login succesfull <br>";
			  
			// change directory
			$sftp->chdir($remoteDir); 
			
			// echo $sftp->pwd() . "<br>"; // show path of current directory
			
				// upload file
    			if ($sftp->put($remoteFile, $localFile))
			  	{
			  		echo "<b>Status:</b> Ticket " . $remoteFile . " uploaded successfully to server!";

                      // change ticket status in database to received
				      $retval = setAnnotationStatus($dbConn, $ticket['AnnotationID'], 1, $ticket['AnnotatorID']);
					  
				      // check if statement was successful
				      if ($retval) {
				          echo "<br><b>Status:</b> Ticket status successfully set to received in database!";
				      }	
				}else{
	  				 echo "<br><b>Status:</b> Annotation can't be put to server!";		
		  		} 
		  } else { echo "Login not possible<br>";}
      }
  } else {
      echo "<b>Status:</b> Invalid file type (extension)! Please select an annotation file ending in ". implode(", ", $allowedExts) ."!";
  }
}

?>
