package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import java.util.Date
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets(from: Date, to: Date, cookie: String, status: PalletStatus.Value): List[(Pallet)] = 
    DB.withConnection { implicit c =>
    val query = SQL(
      """
      SELECT *
      FROM pallets
      WHERE (prodTime BETWEEN {from} AND {to}) AND 
      ({cookie} LIKE '' OR cookieName = {cookie}) AND 
      ({status} LIKE 'Any' OR status = {status});
      """
    ).on("from" -> from, "to" -> to, "cookie" -> cookie, "status" -> status.toString)
    return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"), 
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          row[Int]("orderId"))
        ).toList 
  }

  def getPallet(id: Int): Pallet = DB.withConnection { implicit c => 
    SQL(
        """
        SELECT *
        FROM pallets
        WHERE id = {id}
        """
       ).on('id -> id)

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
      row[String]("cName"),
      row[String]("cAddress"),
      new Array[OrderDetails] (10)
    )).toList;
  }

  def getOrder(id: Int): Order = DB.withConnection { implicit c =>
    SQL(
        """
            SELECT *
            FROM orders
            WHERE id = {id}
        """
    ).on('id' -> id)
    return query().map(row => new Order(
      row[Int]("orderId"),
      row[Date]("incomeDate"),
      row[Date]("delivDate"),
      row[String]("cName"),
      row[String]("cAddress"),
      new Array[OrderDetails] (10)
    )).toList;
  }

}
