<?php
require_once('auth.php');
require_once('HelperFunctions.php');

include_once('header.php');

?>

	<div class="maincontent">
		<div class="content">
			
			<?php
			
			// establish connection to visceral db
			$con = getDBConnection();

			echo "<h2>Volume Statistics</h2>";
			echo "<nav><ul>";

			// get overall number of volumes
			$result = mysqli_query($con,"SELECT count(*) FROM volume");
			$numVolumes = mysqli_fetch_array($result);
			echo "<li>Overall number of volumes: " . $numVolumes[0]. "</li>";

			// get number of volumes for each segmentation and bodyregion
			$result = mysqli_query($con,"SELECT  modality,bodyregion,count(*) as count FROM volume GROUP BY modality, bodyregion");

			echo "<ul>";
			while( $row = mysqli_fetch_array($result)) {
				echo "<li>" . $row['modality'] . "_" . $row['bodyregion'] . ": " . $row['count'] . "</li>";
			}
			echo "</ul>";
	    echo "</ul>";
	    echo "<hr>";


            
			// get count by annotation type     
            $annotationCountQuery = "SELECT AnnotationCategory as Type,  count(*) as count FROM visceral_tickets_release.fullLatestAnnotation_view group by Type;";
            $countByTypeResult = mysqli_query($con, $annotationCountQuery);
			
			// get count by annotation type and status
            $annotationStatsQuery = "SELECT AnnotationCategory as Type, StatusID, statusName as Name, count(*) as amount FROM visceral_tickets_release.fullLatestAnnotation_view
            						 group by AnnotationCategory, StatusID, statusName order by AnnotationCategory";

            $countByTypeStatus = array();
            $result = mysqli_query($con,$annotationStatsQuery);
            
            while($row = mysqli_fetch_array($result)) {
                $countByTypeStatus[$row['Type']][$row['Name']] = $row['amount'];
            }


            while($row = mysqli_fetch_array($countByTypeResult)) {
					echo "<h2>".$row['Type']." annotations</h2>";
		            echo "<p>Overall number of pending or received annotations: " . $row['count'] . "</p>";
		            $subStatus = $countByTypeStatus[$row['Type']];
				    $keys = array_keys($subStatus);
				    sort($keys);
		
				    echo "<ul>\n";
				    foreach($keys as $key) {
					     echo "<li>".$key.": ". $subStatus[$key] ."</li>\n";
				    }
				    echo "</ul>\n";
            }

	    echo "</nav>";
	    echo "<hr>";

	    echo "<h2>Annotator Statistics</h2>";
	    
	    // get number of available annotators
	    $result = mysqli_query($con,"SELECT COUNT(*) FROM annotator where Available=1");
	    $numAnnotators = mysqli_fetch_array($result);

            $result = mysqli_query($con,"SELECT COUNT(*) FROM annotator where Qc=1 AND Available=1");
            $numQC = mysqli_fetch_array($result);


            echo "<nav><ul>";
	    echo "<li>Number of available annotators: " . $numAnnotators[0]. "</li>";
            echo "<li>Number of available QC: " . $numQC[0]. "</li>";
	    echo "</ul></nav>";

	
	mysqli_close($con);
			?>
		</div>
	</div>

<?php
  include_once('footer.php');
?>