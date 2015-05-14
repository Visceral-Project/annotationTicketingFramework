<?php
require_once('auth.php');
require_once('HelperFunctions.php');
trigger_error("FinishedTickets_no_resubmission is deprecated, functionality moved to AnnotationSubmission.php.", E_USER_NOTICE);
?>
<DOCTYPE html>
<html lang="en">

<head>
	<title>VISCERAL Annotation Submission API</title>
	<meta charset="utf-8" />

	<link rel="stylesheet" href="style.css" type="text/css" />
	<meta name="viewport" content="witdth-device-width, initial-scale=1.0"/>
</head>

<body class="body">
	
	<header class="mainheader">
		<img src="img/logo.gif">
		<?php createMenue(); ?>
	</header>
	
	<div class="maincontent">
		<div class="content">
			<div class="ticketcontent">
		
					<!-------------------------------->
					<!-- Landmark Ticket Submission -->
					<!-------------------------------->
					<?php
					// establish connection to visceral db
					$con = getDBConnection();

					// get the current annotator id
					$annotatorID = $_SESSION['annotatorID'];
					
					// get overall number of submitted tickets
					$result = mysqli_query($con,"SELECT count(*)
						FROM manuallandmarkannotation ma, volume v
						where ma.VolumeID = v.VolumeID and
						ma.PatientID = v.PatientID and
						ma.AnnotationReceived>0 and
						ma.AnnotatorID=" . $annotatorID . "");
					$numTickets = mysqli_fetch_array($result);
					echo "<h2>Landmark Tickets (" . $numTickets[0]. " submissions)</h2>";

					// get submitted tickets
					$result = mysqli_query($con,"SELECT ma.PatientID, ma.VolumeID, v.Modality, v.Bodyregion, ma.AnnotatorID, ma.AnnotationReceived
						FROM manuallandmarkannotation ma, volume v
						where ma.VolumeID = v.VolumeID and
						ma.PatientID = v.PatientID and
						ma.AnnotationReceived>0 and
						ma.AnnotatorID=" . $annotatorID . "");

					$entry=1;
					while( $row = mysqli_fetch_array($result)) {

						// create header row
						if ($entry == 1) echo "<table><tr><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th><th>Status</th></tr>";
			
						echo "<tr>";
						echo "<td>" . $row['PatientID'] . "</td>";
						echo "<td>" . $row['VolumeID'] . "</td>";
						echo "<td>" . $row['Modality'] . "</td>";
						echo "<td>" . $row['Bodyregion'] . "</td>";
						if ( $row['AnnotationReceived'] == 1 )
							echo "<td>submitted</td>";
						echo "</tr>";
						
						$entry++;
					}
					if ($entry > 1) echo "</table>";

					mysqli_close($con);
					?>

				<br><hr/><hr/>

					<!------------------------------------>
					<!-- Segmentation Ticket Submission -->
					<!------------------------------------>
					<?php
		
					// establish connection to visceral db
					$con = getDBConnection();

					// select all missing manual annotations of the current annotator
					$annotatorID = $_SESSION['annotatorID'];
					
					// get overall number of submitted tickets
					$result = mysqli_query($con,"SELECT count(*)
						FROM manualannotation ma, volume v, structure s
						where ma.RadLexID = s.RadLexID and
						ma.VolumeID = v.VolumeID and
						ma.PatientID = v.PatientID and
						ma.AnnotationReceived>0 and
						ma.AnnotatorID=" . $annotatorID . "");
					$numTickets = mysqli_fetch_array($result);
					echo "<h2>Segmentation Tickets (" . $numTickets[0]. " submissions)</h2>";

					// get submitted tickets
					$result = mysqli_query($con,"SELECT ma.PatientID, ma.VolumeID, v.Modality, v.Bodyregion, ma.RadLexID, s.Name, 							ma.AnnotatorID, ma.AnnotationReceived
						FROM manualannotation ma, volume v, structure s
						where ma.RadLexID = s.RadLexID and
						ma.VolumeID = v.VolumeID and
						ma.PatientID = v.PatientID and
						ma.AnnotationReceived>0 and
						ma.AnnotatorID=" . $annotatorID . "");

					$entry = 1;
					while( $row = mysqli_fetch_array($result)) {
			
						// create header row
						if ($entry == 1) echo "<table><tr><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th><th>RadLexID</th><th>Structure Name</th><th>Status</th></tr>";
						
						echo "<tr>";
						echo "<td>" . $row['PatientID'] . "</td>";
						echo "<td>" . $row['VolumeID'] . "</td>";
						echo "<td>" . $row['Modality'] . "</td>";
						echo "<td>" . $row['Bodyregion'] . "</td>";
						echo "<td>" . $row['RadLexID'] . "</td>";
						echo "<td>" . $row['Name'] . "</td>";
						if ( $row['AnnotationReceived'] == 1 )
							echo "<td>submitted</td>";
						if ( $row['AnnotationReceived'] == 2 )
							echo "<td>invisible</td>";
						if ( $row['AnnotationReceived'] == 3 )
							echo "<td>bad contrast</td>";
						echo "</tr>";

						$entry++;
					}
					if ($entry > 1) echo "</table>";

					mysqli_close($con);
					?>
			</div>
		</div>
	</div>
	
	<footer class="mainFooter">
		<p>Copyright &copy; Matthias Dorfer @ CIR 2013</p>
	</footer>

</body>

