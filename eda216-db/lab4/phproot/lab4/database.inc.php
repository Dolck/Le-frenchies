<?php
/*
 * Class Database: interface to the movie database from PHP.
 *
 * You must:
 *
 * 1) Change the function userExists so the SQL query is appropriate for your tables.
 * 2) Write more functions.
 *
 */
class Database {
	private $host;
	private $userName;
	private $password;
	private $database;
	private $conn;
	
	/**
	 * Constructs a database object for the specified user.
	 */
	public function __construct($host, $userName, $password, $database) {
		$this->host = $host;
		$this->userName = $userName;
		$this->password = $password;
		$this->database = $database;
	}
	
	/** 
	 * Opens a connection to the database, using the earlier specified user
	 * name and password.
	 *
	 * @return true if the connection succeeded, false if the connection 
	 * couldn't be opened or the supplied user name and password were not 
	 * recognized.
	 */
	public function openConnection() {
		try {
			$this->conn = new PDO("mysql:host=$this->host;dbname=$this->database", 
				$this->userName,  $this->password);
			$this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		} catch (PDOException $e) {
			$error = "Connection error: " . $e->getMessage();
			print $error . "<p>";
			unset($this->conn);
			return false;
		}
		return true;
	}
	
	/**
	 * Closes the connection to the database.
	 */
	public function closeConnection() {
		$this->conn = null;
		unset($this->conn);
	}

	/**
	 * Checks if the connection to the database has been established.
	 *
	 * @return true if the connection has been established
	 */
	public function isConnected() {
		return isset($this->conn);
	}
	
	/**
	 * Execute a database query (select).
	 *
	 * @param $query The query string (SQL), with ? placeholders for parameters
	 * @param $param Array with parameters 
	 * @return The result set
	 */
	private function executeQuery($query, $param = null) {
		try {
			$stmt = $this->conn->prepare($query);
			$stmt->execute($param);
			$result = $stmt->fetchAll();
		} catch (PDOException $e) {
			$error = "*** Internal error: " . $e->getMessage() . "<p>" . $query;
			die($error);
		}
		return $result;
	}
	
	/**
	 * Execute a database update (insert/delete/update).
	 *
	 * @param $query The query string (SQL), with ? placeholders for parameters
	 * @param $param Array with parameters 
	 * @return The number of affected rows
	 */
	private function executeUpdate($query, $param = null) {
		try{
			$stmt = $this->conn->prepare($query);
			$stmt->execute($param);
			return $stmt->rowCount();
		} catch(PDOException $e) {
			$error = "*** Internal error: " . $e->getMessage() . "<p>" . $query;
			die($error);
		}
	}
	
	/**
	 * Check if a user with the specified user id exists in the database.
	 * Queries the Users database table.
	 *
	 * @param userId The user id 
	 * @return true if the user exists, false otherwise.
	 */
	public function userExists($userId) {
		$sql = "select userName from Users where userName = ?";
		$result = $this->executeQuery($sql, array($userId));
		return count($result) == 1; 
	}

	/*
	 * *** Add functions ***
	 */

	public function getMovieNames() {
		$sql = "select title from movies";
		$result = $this->executeQuery($sql, array());

		$movies = array();
		foreach ($result as $res) {
			array_push($movies, $res[0]);
		}
		return $movies;
	}

	public function getPerformanceDates($movieTitle){
		$sql = "select pDate from performances where movieTitle=?";
		$result = $this->executeQuery($sql, array($movieTitle));

		$dates = array();
		foreach ($result as $res) {
			array_push($dates, $res[0]);
		}
		return $dates;	
	}

	public function getPerformance($movieTitle, $pDate){
		$sql = "select movieTitle, pDate, theaterName, availSeats from performances where movieTitle=? and pDate=? for update";
		$result = $this->executeQuery($sql, array($movieTitle, $pDate));

		$perf = array();
		for ($i = 0; $i < 4; $i++) {
			array_push($perf, $result[0][$i]);
		}
		return $perf;	

	}

	public function bookTicket($user, $performance){
		$this->conn->beginTransaction();
		$movieTitle = $performance[0];
		$pDate = $performance[1];
		$availSeats = $performance[3];
		$insert = "insert into Reservations(userName, movieTitle, pDate) values (?,?,?)";
		$update = "update performances set availSeats=? where movieTitle=? and pDate =?";
		$query = "select id from reservations order by id desc limit 1";
		$id = -1;
		if($availSeats >0){
			$nr1 = $this->executeUpdate($insert, array($user, $movieTitle, $pDate));
			if($nr1 == 1){
				$nr2 = $this->executeUpdate($update, array($availSeats-1, $movieTitle, $pDate));
				if($nr2 == 1){
					$idp = $this->executeQuery($query, array());
					$this->conn->commit();
					$id = (int)$idp[0][0];
				} else {
					$this->conn->rollback();
					return $id;
				}
			} else {
				$this->conn->rollback();
				return $id;
			}
		}
		return $id;
	}
}
?>
