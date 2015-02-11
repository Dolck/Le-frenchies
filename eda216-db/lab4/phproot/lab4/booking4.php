<?php
	require_once('database.inc.php');
	
	session_start();
	$db = $_SESSION['db'];
	$userId = $_SESSION['userId'];
	$db->openConnection();
	
  $performance = $_SESSION['performance'];
  $tickedId = $db->bookTicket($userId, $performance);
  var_dump($ticketId);
	$db->closeConnection();
?>

<html>
<head><title>Booking 4</title><head>
<body><h1>Booking 4</h1>
  <?php
  if($ticketId > 1){
    print("One ticket booked. Booking number: " . $ticketId);
  } else {
    print("Failed to book ticket.");
  }
  ?> 
	<p>
	<form method=post action="booking1.php">
		<input type=submit value="New booking">
	</form>
</body>
</html>
