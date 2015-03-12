package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import java.util.Date
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets(from: Date, to: Date, cookie: String, status: String): List[(Pallet)] = 
    DB.withConnection { implicit c =>
    val query = SQL(
      """
      SELECT *
      FROM pallets
      WHERE (prodTime BETWEEN {from} AND {to}) AND 
      ({cookie} LIKE '' OR cookieName = {cookie}) AND 
      ({status} LIKE 'any' OR status = {status});
      """
    ).on("from" -> from, "to" -> to, "cookie" -> cookie, "status" -> status)
    return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"), 
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          row[Int]("orderId"))
        ).toList 
  }

  def getPallet(id: Int): Pallet = DB.withConnection { implicit c => 
    val query = SQL(
        """
        SELECT *
        FROM pallets
        WHERE id = {id}
        """
       ).on('id -> id)
      return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"),
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          row[Int]("orderId"))
        ).toList.head
  }
  
  def changePalletStatus(id: Int, newStatus: PalletStatus.Value): Int = 
    DB.withConnection { implicit c =>
      SQL(
          """
          UPDATE pallets
          SET status = {newStatus}
          WHERE id = {id}
          """
         ).on('id -> id, 'newStatus -> newStatus.toString).executeUpdate()
    }

    //TODO: transaction check if resources available else rollback
  def createPallet(cookieName: String, status: PalletStatus.Value, orderId: Int): Int = 
    DB.withTransaction { implicit c =>
    //get required resources for pallet

    //check if resources available

    //delete resources


      SQL(
          """
          INSERT INTO pallets (prodTime, cookieName, status, orderId)
          VALUES ('now()', {cookieName}, {status}, {orderId})
          """
         ).on('cookieName -> cookieName, 'status -> status.toString, 'orderId -> orderId).executeUpdate()
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
    )).toList
  }

 def getOrder(id: Int): Order = DB.withConnection { implicit c =>
    val query = SQL(
        """
            SELECT *
            FROM orders
            WHERE orderId = {id}
        """
    ).on('id -> id)
    return query().map(row => new Order(
      row[Int]("orderId"),
      row[Date]("incomeDate"),
      row[Date]("delivDate"),
      row[String]("cName"),
      row[String]("cAddress"),
      new Array[OrderDetails] (10)
    )).toList.head
 }

  def getOrderDetails(orderId: Int): List[(OrderDetails)] = DB.withConnection {
    implicit c => 
    val count = (cookieName: String) => SQL(
      """
      SELECT count(*)
      FROM pallets
      WHERE orderId = {orderId} AND cookieName = {cookieName}
      """
    ).on('orderId -> orderId, 'cookieName -> cookieName).apply
    
    val query = SQL(
      """
      SELECT cookieName, nbrPallets
      FROM orderDetails
      WHERE orderId = {orderId}
      """
    ).on('orderid -> orderId)
    
    return query().map(row => new OrderDetails(
      row[String]("cookieName"), 
      row[Int]("nbrPallets"), 
      (count(row[String]("cookieName")).map(rw => 
        rw[Int]("count(*)")).toList.head))).toList
  }

























}
