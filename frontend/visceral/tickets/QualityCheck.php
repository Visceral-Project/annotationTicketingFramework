<?php
require_once('auth.php');
require_once('HelperFunctions.php');

include_once('header.php');
?>

	<div class="maincontent">
		<div class="content">
			<article class="topcontent">
				<header>
					<h2>Quality Check</h2>
				</header>


<form action="QualityCheck.php" method="post" enctype="multipart/form-data">
  <p>Select segmentation file for upload (<i>filename<b>.nii.gz / .fcsv</b></i>):</p>
  <table>
      <tr>
          <td>Annotation performance: </td> 
          <td>
            <select name="qcTicketStatus">
              <option value="">chose ticket status</option>
              <option value= "2" style="background-color: green">QC passed</option>
              <option value="-1" style="background-color: red">QC failed</option>
            </select>
          </td>
      </tr>
      <tr>
          <td>Comment</td>
          <td><textarea name="qcComment" rows="4" cols="50" name"qcCommen"/></textarea></td>
      </tr>
      <tr>
          <td><input type="submit" name='submit_qc' value="Perform Quality Check" /></td>
      </tr>
  </table>

  <br></br>

  <?php

  // get annotator id
  $qcAnnotator = $_SESSION['annotatorID'];

  // get db connection
  $conn = getDBConnection();

    // the perform qc button was pressed
  if(isset($_POST['submit_qc'])){

      $selectedTicket = $_POST['qcAnnotationSelection'];
      $chosenQcStatus = $_POST['qcTicketStatus'];

      // missing selection
      if ($selectedTicket=="") {
        echo "<b>Status:</b> No Ticket selected! Please select a ticket from the lists below!";
      }
      else {
        if ($chosenQcStatus==""){
            echo "<b>Status:</b> Please select annotation performance!";

        }else{

          $ticket = parseTicketID($selectedTicket);
          $ticketComment = $_POST['qcComment'];

          if(setAnnotationQCStatus($conn, $ticket['AnnotationID'],$chosenQcStatus,$qcAnnotator, $ticketComment)){

          }


        } // status has been chosen
      } // ticket selection
  } // button was pressed

  echo "<h2>Pending quality check tickets</h2>";
  // create table with quality check tickets
  renderLatestTicketsForQC($conn, $qcAnnotator, "=1 or StatusID=-2 or StatusID=-3");

  echo "<h2>Submitted quality check tickets</h2>";
  renderLatestTicketsForQC($conn, $qcAnnotator, "=-1 or StatusID=2");

  ?>
</form>
</div>
</div>


<?php
include_once('footer.php');
?>