package dbtLab3;

public class Performance {
	public String movieTitle;
	public String date;
	public String theater;
	public int availSeats;

	public Performance(String movieTitle, String date, String theater, int availSeats){
		this.movieTitle = movieTitle;
		this.date = date;
		this.theater = theater;
		this.availSeats = availSeats;
	}
}