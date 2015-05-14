<?php
require_once('Config.php');

// establish database connection
// -----------------------------
function getDBConnection()
{

    $config = visceral\Config::getDBHostConfig();
    // establish connection to visceral db
    $con = mysqli_connect($config['host'], $config['user'], $config['passwd'], $config['database']);

    // check connection
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
        $con = null;
    }

    return $con;
}


// create menu
// --------------------
function createMenue()
{
	// add quality check page if annotator is marked as quality check member in database
    $qcMenu = "";
    if ($_SESSION['isQC'] == 1) {
        $qcMenu = "<li><a href='QualityCheck.php'>Quality Check</a></li>";
    };

    echo "<nav><ul>
			<li><a href='index.php'>Home</a></li>
			<li><a href='AnnotationSubmission.php'>Annotation Submission</a></li>" .

        $qcMenu .
        "<li><a href='Statistics.php'>Statistics</a></li>
        <li><a href='UserSettings.php'>User Settings</a></li>
        <li><a href='logout.php'>Logout</a></li>
</ul></nav>";
}


// generate (unique) ticket id for use in forms
function generateTicketID($resultRow)
{
    	$ticketID = $resultRow['PatientID'] . "_" .
        $resultRow['VolumeID'] . "_" .
        $resultRow['Modality'] . "_" .
        $resultRow['BodyRegion'] . "_" .
        $resultRow['AnnotationTypeID'] . "_" .
        $resultRow['AnnotationName'] . "_" .
        $resultRow['AnnotationID'];

    return $ticketID;
}

// parse form input name to struct
function parseTicketID($selectedTicket)
{

    // get ticket information
    $pieces = explode("_", $selectedTicket);

    $selectionStruct = array(
        "PatientID" => $pieces[0],
        "VolumeID" => $pieces[1],
        "Modality" => $pieces[2],
        "BodyRegion" => $pieces[3],
        "AnnotationTypeID" => $pieces[4],
        "AnnotationName" => $pieces[5],
        "AnnotationID" => $pieces[6]
    );

    return $selectionStruct;
}


function setAnnotationStatus($dbConn, $AnnotationID, $StatusID, $AnnotatorID)
{

    $retval = mysqli_query($dbConn, "CALL setAnnotationStatus(" . $AnnotationID . ", ". $StatusID. ", ". $AnnotatorID . ")");

    // check if statement was successful
    if (!$retval) {
        die('"<br><b>Status:</b> Could not change database entry: ' . mysql_error());
    }
    return $retval;
}


function setAnnotationQCStatus($dbConn, $AnnotationID,$qcStatus,$qcAnnotatorID, $comment) {
				
 
  $retval = mysqli_query($dbConn, "CALL setQCAnnotationStatus(" . $AnnotationID . ", ". $qcStatus. ", ". $qcAnnotatorID . ", '". $comment . "')");

    // check if statement was successful
    if (!$retval) {
        die('"<br><b>Status:</b> Could not change database entry: ' . mysql_error());
    }
    return $retval;
}


// -----------------------------------------------------------
// query db for most recent (of versioned) ticket entry
// -----------------------------------------------------------
function queryLatestTickets($conn, $where, $order = "AnnotationCategory, PatientID, VolumeID, AnnotationTypeID")
{

    $query = "SELECT * FROM fullLatestAnnotation_view WHERE " . $where . " ORDER BY " . $order;

    // uncomment this line for debuging
    // echo "query: " . $query;

    $result = mysqli_query($conn, $query);

    #echo "result count: " . mysqli_num_rows($result);

    return $result;
}

// -----------------------------------------------------------
// generate dropdown <select> string for quality check status
// -----------------------------------------------------------
function getStatusOptionSelect($conn, $where = "QCAccessible=1")
{

    $res = '<option value="" selected="selected"></option>';
    $result = mysqli_query($conn, "SELECT * from status WHERE " . $where);

    while ($row = mysqli_fetch_array($result)) {
        $res .= "<option value=" . $row['StatusID'] . " style=\"background: " . $row['Color'] . ";\">" . $row['Name'] . "</option>\n";
    }

    return $res;
}

// -----------------------------------------------------------
// render a table with tickets for given status and annotator IDs
// -----------------------------------------------------------
function renderLatestTicketsForAnnotatorAndStatus($conn, $annotator, $status, $optionSelect = true)
{

    $anno = "";
    if (isset($annotator) && $annotator != null) {
        $anno = " AND AnnotatorID=" . $annotator;
    }

    $where = " StatusID" . $status . $anno;

    $result = queryLatestTickets($conn, $where);

    // display all pending tickets
    $entry = 1;
    while ($row = mysqli_fetch_array($result)) {

        // create header row
        if ($entry == 1) echo "<table><tr>" . ($optionSelect ? "<th></th>" : "") . "<th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th><th>Type</th><th>Status</th><th>QC Comment</th></tr>";

        // change bg color for every second entry
        if ($entry % 2 == 0) echo "<tr bgcolor='#CCCCCC'>";
        else echo "<tr>";

        // display ticket information
        if ($optionSelect) {
            echo "<td>" . "<input type='radio' name='AnnotationSelection' value='" . generateTicketID($row) . "'></td>";
        }
        echo "<td>" . $row['PatientID'] . "</td>";
        echo "<td>" . $row['VolumeID'] . "</td>";
        echo "<td>" . $row['Modality'] . "</td>";
        echo "<td>" . $row['BodyRegion'] . "</td>";
        echo "<td>" . $row['AnnotationName'] . "</td>";
        echo "<td>" . $row['statusName'] . "</td>";
        echo "<td>" . $row['Comment'] . "</td>";


        echo "</tr>\n";

        $entry++;
    }
    if ($entry == 1) echo "<i>0 tickets selected.</i><br>";
    else echo "</table>";

}

// -----------------------------------------------------------
// render current list for open quality check tickets
// -----------------------------------------------------------
function renderLatestTicketsForQC($conn, $qcAnnotator, $status, $optionSelect = true)
{

    $anno = "";
    if (isset($qcAnnotator) && $qcAnnotator != null) {
        $anno = " AND qcAnnotatorID=" . $qcAnnotator;
    }

  
    $where = " (StatusID" . $status . ")" . $anno;
    $result = queryLatestTickets($conn, $where);
    
    // display all pending tickets
    $entry = 1;
    $lastRow = '';
    while ($row = mysqli_fetch_array($result)) {

        // create header row
        if ($entry == 1) {
            echo "<table>" ;
            echo "<colgroup>";
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;
            echo '<col width="150">' ;


            echo "</colgroup>";

            // <th>Modality</th><th>Bodyregion</th><th>Type</th>
            echo "<tr>" . ($optionSelect ? "<th></th>" : "") . "<th>PatientID</th><th>VolumeID</th><th>Modality</th><th>Bodyregion</th><th>Type</th><th>Status</th><th>QC Comment</th></tr>";
        }

        //$volume_row = $row['PatientID'] . "_" . $row['VolumeID'] . "_" . $row['Modality'] . "_" . $row['BodyRegion'];
        // change bg color for every second entry

        //if (strcmp($lastRow, $volume_row)) {
            if ($entry % 2 == 0) echo "<tr bgcolor='#CCCCCC'>";
            else echo "<tr>";

            // display ticket information

            if ($optionSelect) {
                echo "<td>" . "<input type='radio' name='qcAnnotationSelection' value='" . generateTicketID($row) . "'></td>";
            }
	        echo "<td>" . $row['PatientID'] . "</td>";
	        echo "<td>" . $row['VolumeID'] . "</td>";
	        echo "<td>" . $row['Modality'] . "</td>";
	        echo "<td>" . $row['BodyRegion'] . "</td>";
	        echo "<td>" . $row['AnnotationName'] . "</td>";
	        echo "<td>" . $row['statusName'] . "</td>";
	        echo "<td>" . $row['Comment'] . "</td>";


            echo "</tr>\n";

            $entry++;
        //} else {}
        //$lastRow = $volume_row;

    }
    if ($entry == 1) echo "<i>You have currently no tickets assigned.</i><br>";
    else echo "</table>";
}



function processQC($dbConn, $ticket, $keys, $comment) {

    foreach($keys as $key) {
        $value = $_POST[$key];

        $keyparts = explode("_", $key);
        $keyPrefix = $keyparts[0];
	    $annotationID = $keyparts[1];
        $landmarkID = $keyparts[2];

        if($keyPrefix == "landmark") {
            echo "landmark " . $landmarkID . ": status=". $value ."\n";;
        }
        else if($keyPrefix == "structure") {
            echo "structure " . $annotationID . ": status=". $value ."\n";;
        }
        else {
            echo "<p>dunno how to process ticket: " . $key . "</p>";
        }
    }

    if($comment != null) {
        echo "comment : " . $comment . "\n";
    }
    else {
        echo "no comment.";
    }
}

?>
