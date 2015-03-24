package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import java.util.Date
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets(id: Int, from: Date, to: Date, cookie: String, status: String): List[(Pallet)] = 
    DB.withConnection { implicit c =>
    val query = SQL(
      """
      SELECT *
      FROM pallets
      WHERE (prodTime BETWEEN {from} AND {to}) AND 
      ({cookie} LIKE '' OR cookieName = {cookie}) AND 
      ({status} LIKE 'any' OR status = {status}) AND
      ({id} LIKE '-1' OR id = {id})
      """
    ).on("id" -> id, "from" -> from, "to" -> to, "cookie" -> cookie, "status" -> status)
    return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"), 
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          try{
            Some(row[Int]("orderId"))
          }catch{
            case e: Exception => None
            })
        ).toList 
  }

  def getPallet(id: Int): Pallet = DB.withConnection { implicit c => 
    val query = SQL(
        """
        SELECT *
        FROM pallets natural left join orders
        WHERE id = {id}
        """
       ).on('id -> id)
      return query().map(row => new Pallet(
          row[Int]("id"), 
          row[Date]("prodTime"),
          row[String]("cookieName"), 
          PalletStatus.withName(row[String]("status")), 
          try{
            Some(row[Int]("orderId"))
          }catch{
            case e:Exception => None
          },
          try{
            row[Date]("delivDate")
          }catch{
            case e:Exception => null
          },
          try{
            row[String]("cName")
          }catch{
            case e:Exception => ""
          },
          try{
            row[String]("cAddress")
          } catch {
            case e:Exception => ""
          }
        )
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
    //get required resources for pallet
    //check if resources available
    //delete resources

    def createPallet(cookieName: String, status: PalletStatus.Value, orderId: Int): Boolean = 
    DB.withConnection { implicit c =>
        c.setAutoCommit(false)
        try{
          val reqResources = SQL(
            """
            SELECT cookieName, recipeDetails.rawType, recipeDetails.quantity as reqQ, rawMaterials.quantity as availQ 
            FROM recipeDetails, rawMaterials 
            WHERE cookieName = {cookieName} and recipeDetails.rawType = rawMaterials.rawType
            """
          ).on('cookieName -> cookieName).apply
          val updateRes = (rawType: String, newQ: Int) => SQL(
            """
            UPDATE rawMaterials
            SET quantity = {newQ}
            WHERE rawType = {rawType}
            """
          ).on('newQ -> newQ, 'rawType -> rawType).executeUpdate()
          
          for (row <- reqResources){
            val rawType: String = row[String]("rawType")
            val newQ: Int = row[Int]("rawMaterials.quantity") - row[Int]("recipeDetails.quantity")
            updateRes(rawType, newQ)
          }
          var result = 0
          if (orderId > 0) {
            result = SQL(
              """
              INSERT INTO pallets (prodTime, cookieName, status, orderId)
              VALUES (now(), {cookieName}, {status}, {orderId})
              """
            ).on('cookieName -> cookieName, 'status -> status.toString, 'orderId -> orderId).executeUpdate() 
          }else{
            result = SQL(
              """
              INSERT INTO pallets (prodTime, cookieName, status)
              VALUES (now(), {cookieName}, {status})
              """
            ).on('cookieName -> cookieName, 'status -> status.toString).executeUpdate() 
          }
          c.commit()
          println("result" + result)
          return 1 == result
        } catch {
          case e: Exception => c.rollback()
          println(e)
          return false
        }
    }

  def getOrders(): List[(Order)] = DB.withConnection {
    implicit c =>
    val query = SQL(
      """
        SELECT *
        FROM orders
      """
    )
    return query().map(row => new Order(
      row[Int]("orderId"),
      row[Date]("incomeDate"),
      row[Date]("delivDate"),
      row[String]("cName"),
      row[String]("cAddress"),
      getOrderDetails(row[Int]("orderId"))
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
      getOrderDetails(row[Int]("orderId"))
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
    ).on('orderId -> orderId)
    
    return query().map(row => new OrderDetails(
      row[String]("cookieName"), 
      row[Int]("nbrPallets"), 
      (count(row[String]("cookieName")).map(rw => 
        rw[Int]("count(*)")).toList.head))).toList
  }

  def getCookies(): List[(String)] = DB.withConnection {
    implicit c => 
    val query = SQL(
      """
      SELECT cookieName
      FROM CookieNames
      """
    )
    return query().map(row => row[String]("cookieName")).toList
  }
























}
