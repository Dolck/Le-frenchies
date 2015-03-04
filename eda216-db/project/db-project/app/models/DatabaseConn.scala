package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import java.util.Date
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets(): List[(Pallet)] = DB.withConnection { implicit c =>
    val query = SQL(
      """
      SELECT *
      FROM pallets;
      """
    )
    return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"), 
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          row[Int]("orderId"))
        ).toList 
  }

  def getOrders(): List[(Order)] = DB.withConnection {
    implicit c =>
    val query = SQL(
      """
        SELECT *
        FROM orders;
      """
    );
    return query().map(row => new Order(
      row[Int]("orderId"),
      row[Date]("incomeDate"),
      row[Date]("delivDate"),
      row[String]("custName"),
      row[String]("custAddress"),
      new Array[OrderDetails] (10)
    )).toList;
  }


}
