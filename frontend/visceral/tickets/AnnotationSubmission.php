<?php
require_once('auth.php');
require_once('HelperFunctions.php');
require_once('FtpUpload.php');

include_once('header.php');
?>

<div class="maincontent">
<div class="content">

<h2>Unified Ticket Submission</h2>
<form action="AnnotationSubmission.php" method="post" enctype="multipart/form-data">
<p>Select segmentation file for upload (<i>filename<b>.nii.gz / .fcsv</b></i>):</p>
<table>
    <tr>
        <td>Annotation file</td><td><input type="file" name="file" id="file" size="40" value="..."></td>
    </tr>
    <tr>
        <td>Annotation visibility</td>
	<td>
          <select name="annotation_visibility" >
            <option value="1"  style="background-color: lightgreen">fully visible</option>
            <option value="-2" style="background-color: orange">bad contrast</option>
            <option value="-3" style="background-color: orange">not in volume</option>
          </select>
          </td>
    </tr>
    <tr>
        <td><input type="submit" name='submit_annotation' value="Submit annotation" /></td>
    </tr>
</table>

<?php


$conn = getDBConnection();

// the submit button was pressed
if(isset($_POST['submit_annotation'])) {

  $submittedTicket = $_POST['AnnotationSelection'];
  
  // missing selection
  if ($submittedTicket=="") {
    echo "<b>Status:</b> No Ticket selected! Please select a ticket to submit from the list below!";
  }
  else {
    
    // annotation was selected
    $ticket = parseTicketID($_POST['AnnotationSelection']);
    $visibility = $_POST['annotation_visibility'];
	
    if($visibility != "1") {
      if(setAnnotationStatus($conn, $ticket['AnnotationID'], $visibility, $_SESSION['annotatorID'])) {
        echo "<b>Status:</b> Ticket status successfully updated!";
		
      }
      else {
        echo "<b>Status:</b> failed to updated visibility status!";
      }
    }else{
      uploadAnnotationFTP($conn, $submittedTicket);
    }
  }
}

  // get annotatorID
  $annotator = $_SESSION['annotatorID'];

  // list pending tickets of annotator, i.e. where annotation status == 0
  echo "<h2>Pending tickets</h2>";
  renderLatestTicketsForAnnotatorAndStatus($conn, $annotator, "=0");

  // list submitted tickets of annotator, i.e. where annotation status !=0
  echo "<h2>Previously submitted tickets</h2>";
  renderLatestTicketsForAnnotatorAndStatus($conn, $annotator, "!=0");

  mysqli_close($conn);

?>


</form>
<br />
    <hr/>
    <hr/>
<br />
</div>
</div>


<?php
include_once('footer.php');
?>
