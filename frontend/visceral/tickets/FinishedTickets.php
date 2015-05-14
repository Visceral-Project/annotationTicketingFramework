<?php
require_once('auth.php');
require_once('HelperFunctions.php');
trigger_error("FinishedTickets is deprecated, functionality moved to AnnotationSubmission.php.", E_USER_NOTICE);
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
		

				<!-------------------------------->
				<!-- Landmark Ticket Submission -->
				<!-------------------------------->
				<h2>Submitted Landmark Tickets</h2>

				<form action="FinishedTickets.php" method="post" enctype="multipart/form-data">
					Select landmark file for upload (<i>filename<b>.fcsv</b></i>):
					<table>					
					<tr>
						<td><input type="file" name="file" id="file" size="40" value="..."></td>
						<td><input type="submit" name='submit_landmark' value="Re-Upload Landmarks" /></td>
					</tr>
					</table>
				
				<div class="ticketcontent">
					<?php

					// submit manual landmark annotation
					if(isset($_POST['submit_landmark']))
					{
						
						echo "<br>";

						$selectedLandmarkTicket = $_POST['LandmarkSelection'];

						// check if ticket selected
						if ($selectedLandmarkTicket=="") {
							echo "<b>Status:</b> No Ticket selected! Please select a ticket to submit from the list below!";
						} else {
							copyLandmarkAnnotationToFTP($selectedLandmarkTicket);
						}
					}

					echo "<br>";
		
					// establish connection to visceral db
					$con = getDBConnection();

					// get the current annotator id
					$annotatorID = $_SESSION['annotatorID'];
					
					// get overall number of submitted tickets
					$result = mysqli_query($con,"SELECT count(*)
						FROM manuallandmarkannotation ma, volume v
						where ma.VolumeID = v.VolumeID and
						ma.PatientID = v.PatientID and
						ma.AnnotationReceived!=0 and
						ma.AnnotatorID=" . $annotatorID . "");
					$numTickets = mysqli_fetch_array($result);
					echo "<h3>Number of submitted Landmark-Tickets: " . $numTickets[0]. "</h3>";

					// select all missing manual landmark annotations of the current annotator
					$result = mysqli_query($con,"SELECT mla.PatientID, mla.VolumeID, v.Modality, v.Bodyregion, mla.AnnotatorID
						FROM manuallandmarkannotation mla, volume v where
						mla.VolumeID = v.VolumeID and
						mla.PatientID = v.PatientID and
						mla.annotationreceived!=0 and
						mla.AnnotatorID=" . $annotatorID .
						" ORDER BY mla.PatientID, mla.VolumeID");

					echo "<br>";
					
					// display all pending tickets
					$entry = 1;
					while( $row = mysqli_fetch_array($result) ) {
			
						// create header row
						if ($entry == 1) echo "<table><tr><th></th><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th></tr>";

						// change bg color for every second entry
						if ($entry%2 == 0) echo "<tr bgcolor='#CCCCCC'>";
						else echo "<tr>";

						// display ticket information
						echo "<td>" . "<input type='radio' name='LandmarkSelection' value='" .	
							$row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['Bodyregion'] . "_LMAnnotations" .
							"_" . $row['AnnotatorID'] . "'></td>";
						echo "<td>" . $row['PatientID'] . "</td>";
						echo "<td>" . $row['VolumeID'] . "</td>";
						echo "<td>" . $row['Modality'] . "</td>";
						echo "<td>" . $row['Bodyregion'] . "</td>";
						echo "</tr>";

						$entry++;
					}
					if ($entry > 1) echo "</table>";

					mysqli_close($con);
					?>
				</form>
				</div>

            <br><hr/><hr/><br>

            <!------------------------------------>
            <!-- Segmentation Ticket Submission -->
            <!------------------------------------>
            <h2>Submitted Segmentation Tickets</h2>

            <form action="FinishedTickets.php" method="post" enctype="multipart/form-data">
                Select segmentation file for upload (<i>filename<b>.nii.gz</b></i>):
                <table>
                <tr>
                    <td><input type="file" name="file" id="file" size="40" value="..."></td>
                    <td><input type="submit" name='submit' value="Re-Upload Segmentation" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" name='notvisible' value="Structure not in volume" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" name='badcontrast' value="Structure has bad contrast" /></td>
                </tr>
                </table>

            <div class="ticketcontent">
                <?php

                // submit manual annotation
                if(isset($_POST['submit']))
                {

                    echo "<br>";

                    $selectedTicket = $_POST['SegmentationSelection'];

                    // check if ticket selected
                    if ($selectedTicket=="") {
                        echo "<b>Status:</b> No Ticket selected! Please select a ticket to re-submit from the list below!";
                    } else {
                        //uploadAnnotation($selectedTicket);
                        copyAnnotationToFTP($selectedTicket);
                    }
                }

                // set structure to invisible
                if(isset($_POST['notvisible']))
                {

                    echo "<br>";

                    $selectedTicket = $_POST['SegmentationSelection'];

                    // check if ticket selected
                    if ($selectedTicket=="") {
                        echo "<b>Status:</b> No Ticket selected! Please select a ticket to re-submit from the list below!";
                    } else {
                        setAnnotationInvisible($selectedTicket);
                    }
                }

                // set structure to invisible
                if(isset($_POST['badcontrast']))
                {

                    echo "<br>";

                    $selectedTicket = $_POST['SegmentationSelection'];

                    // check if ticket selected
                    if ($selectedTicket=="") {
                        echo "<b>Status:</b> No Ticket selected! Please select a ticket to re-submit from the list below!";
                    } else {
                        setAnnotationBadContrast($selectedTicket);
                    }
                }

                echo "<br>";

                // establish connection to visceral db
                $con = getDBConnection();

                // get the current annotator
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
                echo "<h3>Number of submitted Segmentation-Tickets: " . $numTickets[0]. "</h3>";

                // select all submitted manual annotations of the current annotator
                $result = mysqli_query($con,"SELECT ma.PatientID, ma.VolumeID, v.Modality, v.Bodyregion, ma.RadLexID, s.Name, 							ma.AnnotatorID, ma.AnnotationReceived
                    FROM manualannotation ma, volume v, structure s
                    where ma.RadLexID = s.RadLexID and
                    ma.VolumeID = v.VolumeID and
                    ma.PatientID = v.PatientID and
                    ma.AnnotationReceived!=0 and
                    ma.AnnotatorID=" . $annotatorID .
                    " ORDER BY ma.PatientID, ma.VolumeID");

                echo "<br>";

                // display all submitted tickets
                $entry = 1;
                while( $row = mysqli_fetch_array($result)) {

                    // create header row
                    if ($entry == 1) echo "<table><tr><th></th><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th><th>RadLexID</th><th>Structure Name</th><th>Status</th></tr>";

                    // change bg color for every second entry
                    if ($entry%2 == 0) echo "<tr bgcolor='#CCCCCC'>";
                    else echo "<tr>";

                    // display ticket information
                    echo "<td>" . "<input type='radio' name='SegmentationSelection' value='" .
                        $row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['Bodyregion'] .
                        "_" . $row['RadLexID'] . "_" . $row['AnnotatorID'] . "'></td>";
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
            </form>
			</div>

            <br><hr/><hr/><br>


            <!-------------------------------->
            <!-- Careful Lesion Annotation Ticket Submission -->
            <!-------------------------------->
            <h2>Submitted Careful Lesion Tickets</h2>

            <form action="FinishedTickets.php" method="post" enctype="multipart/form-data">
        Select landmark file for upload (<i>filename<b>.fcsv</b></i>):
        <table>
            <tr>
                <td><input type="file" name="file" id="file" size="40" value="..."></td>
                <td><input type="submit" name='submit_carefulLesion' value="Re-Upload Careful Lesion Annotation" /></td>
            </tr>
        </table>

        <div class="ticketcontent">
            <?php

            // submit manual landmark annotation
            if(isset($_POST['submit_carefulLesion']))
            {

                echo "<br>";

                $selectedCarefulLesionTicket = $_POST['CarefulLesionSelection'];

                // check if $selectedCarefulLesionTicket selected
                if ($selectedCarefulLesionTicket=="") {
                    echo "<b>Status:</b> No Ticket selected! Please select a ticket to submit from the list below!";
                } else {
                    copyCarefulLesionAnnotationToFTP($selectedCarefulLesionTicket);
                }
            }

            echo "<br>";

            // establish connection to visceral db
            $con = getDBConnection();

            // get the current annotator id
            $annotatorID = $_SESSION['annotatorID'];

            // get overall number of submitted tickets
            $result = mysqli_query($con,"SELECT count(*)
						FROM carefullesionannotation cla, volume v
						where cla.VolumeID = v.VolumeID and
						cla.PatientID = v.PatientID and
						cla.AnnotationReceived!=0 and
						cla.AnnotatorID=" . $annotatorID . "");
            $numTickets = mysqli_fetch_array($result);
            echo "<h3>Number of submitted Careful Lesion -Tickets: " . $numTickets[0]. "</h3>";

            // select all annotated careful lesion annotations of the current annotator
            $result = mysqli_query($con,"SELECT cla.PatientID, cla.VolumeID, v.Modality, v.Bodyregion, cla.AnnotatorID
						FROM carefullesionannotation cla, volume v where
						cla.VolumeID = v.VolumeID and
						cla.PatientID = v.PatientID and
						cla.annotationreceived!=0 and
						cla.AnnotatorID=" . $annotatorID .
                " ORDER BY cla.PatientID, cla.VolumeID");

            echo "<br>";

            // display all pending tickets
            $entry = 1;
            while( $row = mysqli_fetch_array($result) ) {

                // create header row
                if ($entry == 1) echo "<table><tr><th></th><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th></tr>";

                // change bg color for every second entry
                if ($entry%2 == 0) echo "<tr bgcolor='#CCCCCC'>";
                else echo "<tr>";

                // display ticket information
                echo "<td>" . "<input type='radio' name='CarefulLesionSelection' value='" .
                    $row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['Bodyregion'] . "_CarefulLesionAnnotations" .
                    "_" . $row['AnnotatorID'] . "'></td>";
                echo "<td>" . $row['PatientID'] . "</td>";
                echo "<td>" . $row['VolumeID'] . "</td>";
                echo "<td>" . $row['Modality'] . "</td>";
                echo "<td>" . $row['Bodyregion'] . "</td>";
                echo "</tr>";

                $entry++;
            }
            if ($entry > 1) echo "</table>";

            mysqli_close($con);
            ?>
    </form>
            </div>

            <br><hr/><hr/><br>

            <!-------------------------------->
            <!-- Rough Lesion Annotation Ticket Submission -->
            <!-------------------------------->
            <h2>Submitted Rough Lesion Tickets</h2>

            <form action="FinishedTickets.php" method="post" enctype="multipart/form-data">
        Select rough lesion annotation file for upload (<i>filename<b>.fcsv</b></i>):
        <table>
            <tr>
                <td><input type="file" name="file" id="file" size="40" value="..."></td>
                <td><input type="submit" name='submit_roughLesion' value="Re-Upload Rough Lesion Annotation" /></td>
            </tr>
        </table>

        <div class="ticketcontent">
            <?php

            // submit manual landmark annotation
            if(isset($_POST['submit_roughLesion']))
            {

                echo "<br>";

                $selectedRoughLesionTicket = $_POST['RoughLesionSelection'];

                // check if $selectedRoughLesionTicket selected
                if ($selectedRoughLesionTicket=="") {
                    echo "<b>Status:</b> No Ticket selected! Please select a ticket to submit from the list below!";
                } else {
                    copyRoughLesionAnnotationToFTP($selectedRoughLesionTicket);
                }
            }

            echo "<br>";

            // establish connection to visceral db
            $con = getDBConnection();

            // get the current annotator id
            $annotatorID = $_SESSION['annotatorID'];

            // get overall number of submitted tickets
            $result = mysqli_query($con,"SELECT count(*)
						FROM roughlesionannotation rla, volume v
						where rla.VolumeID = v.VolumeID and
						rla.PatientID = v.PatientID and
						rla.AnnotationReceived!=0 and
						rla.AnnotatorID=" . $annotatorID . "");
            $numTickets = mysqli_fetch_array($result);
            echo "<h3>Number of submitted Careful Lesion -Tickets: " . $numTickets[0]. "</h3>";

            // select all annotated careful lesion annotations of the current annotator
            $result = mysqli_query($con,"SELECT rla.PatientID, rla.VolumeID, v.Modality, v.Bodyregion, rla.AnnotatorID
						FROM roughlesionannotation rla, volume v where
						rla.VolumeID = v.VolumeID and
						rla.PatientID = v.PatientID and
						rla.annotationreceived!=0 and
						rla.AnnotatorID=" . $annotatorID .
                " ORDER BY rla.PatientID, rla.VolumeID");

            echo "<br>";

            // display all pending tickets
            $entry = 1;
            while( $row = mysqli_fetch_array($result) ) {

                // create header row
                if ($entry == 1) echo "<table><tr><th></th><th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th></tr>";

                // change bg color for every second entry
                if ($entry%2 == 0) echo "<tr bgcolor='#CCCCCC'>";
                else echo "<tr>";

                // display ticket information
                echo "<td>" . "<input type='radio' name='RoughLesionSelection' value='" .
                    $row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['Bodyregion'] . "_RoughLesionAnnotations" .
                    "_" . $row['AnnotatorID'] . "'></td>";
                echo "<td>" . $row['PatientID'] . "</td>";
                echo "<td>" . $row['VolumeID'] . "</td>";
                echo "<td>" . $row['Modality'] . "</td>";
                echo "<td>" . $row['Bodyregion'] . "</td>";
                echo "</tr>";

                $entry++;
            }
            if ($entry > 1) echo "</table>";

            mysqli_close($con);
            ?>
    </form>
            </div>

            <br><hr/><hr/><br>

		</div>
	</div>
	
	<footer class="mainFooter">
		<p>Copyright &copy; Matthias Dorfer @ CIR 2013</p>
	</footer>

</body>

