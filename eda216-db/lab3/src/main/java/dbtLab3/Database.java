package dbtLab3;

import java.sql.*;
import java.util.*;

/**
 * Database is a class that specifies the interface to the movie database. Uses
 * JDBC and the MySQL Connector/J driver.
 */
public class Database {
	/**
	 * The database connection.
	 */
	private Connection conn;

	/**
	 * Create the database interface object. Connection to the database is
	 * performed later.
	 */
	public Database() {
		conn = null;
	}

	/**
	 * Open a connection to the database, using the specified user name and
	 * password.
	 * 
	 * @param userName
	 *            The user name.
	 * @param password
	 *            The user's password.
	 * @return true if the connection succeeded, false if the supplied user name
	 *         and password were not recognized. Returns false also if the JDBC
	 *         driver isn't found.
	 */
	public boolean openConnection(String userName, String password) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(
					"jdbc:mysql://puccini.cs.lth.se/" + userName, userName,
					password);
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * Close the connection to the database.
	 */
	public void closeConnection() {
		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
		}
		conn = null;
	}

	/**
	 * Check if the connection to the database has been established
	 * 
	 * @return true if the connection has been established
	 */
	public boolean isConnected() {
		return conn != null;
	}

	/* --- insert own code here --- */

	public boolean login(String userName){
		String sql = "select username from users where username =?";
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, userName);
			ResultSet rs = ps.executeQuery();
			return rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(ps != null)
					ps.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return false;
	}

	public ArrayList<String> getMovies(){
		String sql = "select title from movies";
		PreparedStatement ps = null;
		ArrayList<String> movies = new ArrayList<String>();
		try{
			ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				movies.add(rs.getString("title"));
			}
		}catch(SQLException e){
			e.printStackTrace();
		} finally {
			try{
				if(ps != null)
					ps.close();
			}catch (SQLException e){
				e.printStackTrace();
			}
		}
		return movies;
	}

	public ArrayList<String> getPerfDates(String movieTitle){
		String sql = "select pDate from performances where movieTitle=?";
		PreparedStatement ps = null;
		ArrayList<String> movies = new ArrayList<String>();
		try{
			ps = conn.prepareStatement(sql);
			ps.setString(1,movieTitle);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				movies.add(rs.getString("pDate"));
			}
		}catch(SQLException e){
			e.printStackTrace();
		} finally {
			try{
				if(ps != null)
					ps.close();
			}catch (SQLException e){
				e.printStackTrace();
			}
		}
		return movies;
	}

	public Performance getPerformance(String movieTitle, String date){
		String sql = "select movieTitle, pDate, theaterName, availSeats from performances where movieTitle=? and pDate=?";
		PreparedStatement ps = null;
		Performance output = null;
		try{
			ps = conn.prepareStatement(sql);
			ps.setString(1,movieTitle);
			java.sql.Date sqlDate = java.sql.Date.valueOf(date);
			ps.setDate(2, sqlDate);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				String oTitle = rs.getString("movieTitle");
				String oDate = rs.getString("pDate");
				String oTheater = rs.getString("theaterName");
				int oSeats = rs.getInt("availSeats");
				output = new Performance(oTitle, oDate, oTheater, oSeats);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} catch(IllegalArgumentException e) {
			e.printStackTrace();
		} finally {
			try{
				if(ps != null)
					ps.close();
			}catch (SQLException e){
				e.printStackTrace();
			}
		}
		return output;
	}
}
