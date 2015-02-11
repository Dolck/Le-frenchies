<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
  $userId = $_SESSION['userId'];
  $pDate = $_POST['perfDates'];
  $movieTitle = $_SESSION['movieTitle'];
	$db->openConnection();
	
  $performance = $db->getPerformance($movieTitle, $pDate);
  $_SESSION['performance'] = $performance;
  $theater = $performance[2];
  $availSeats = $performance[3];
	$db->closeConnection();
?>

<html>
<head><title>Booking 3</title><head>
<body><h1>Booking 3</h1>
  Current user: <?php print $userId ?>
  <p>
  Data for selected performance:
	<p>
	<table border=1>
	  <tr>
    <td>Movie:</td> <td><?php print $movieTitle ?></td>
    </tr>
    <tr>
    <td>Date:</td> <td><?php print $pDate ?></td>
    </tr>
    <tr>
    <td>Theater:</td> <td><?php print $theater ?></td>
    </tr>
    <tr>
    <td>Free seats:</td> <td><?php print $availSeats ?></td>
    </tr>
  </table>
	<p>
	<form method=post action="booking4.php">
		<input type=submit value="Book ticket">
	</form>
</body>
</html>
