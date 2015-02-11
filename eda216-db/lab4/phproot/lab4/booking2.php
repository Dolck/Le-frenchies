<?php
	require_once('database.inc.php');

  session_start();
	$db = $_SESSION['db'];
  $userId = $_SESSION['userId'];
  $movieTitle = $_POST['movieName'];
  $_SESSION['movieTitle'] = $movieTitle;
	$db->openConnection();
	
	$pDates = $db->getPerformanceDates($movieTitle);
	$db->closeConnection();
?>

<html>
<head><title>Booking 2</title><head>
<body><h1>Booking 2</h1>
  Current user: <?php print $userId ?>
  Selected movie: <?php print $movieTitle?>
	<p>
	Performances:
	<p>
	<form method=post action="booking3.php">
		<select name="perfDates" size=10>
		<?php
			$first = true;
			foreach ($pDates as $date) {
				if ($first) {
					print "<option selected>";
					$first = false;
				} else {
					print "<option>";
				}
				print $date;
			}
		?>
		</select>		
		<input type=submit value="Select date">
	</form>
</body>
</html>
