package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets(): List[(Int,String)] = DB.withConnection { implicit c =>
    val query = SQL(
      """
      SELECT *
      FROM pallets;
      """
    )
    return query().map(row => row[Int]("id") -> row[String]("cookieName")).toList
  }
}
