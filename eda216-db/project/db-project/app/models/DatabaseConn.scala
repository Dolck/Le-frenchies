package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets() = DB.withConnection { implicit c =>
    val pallets = SQL(
        """
        SELECT *
        FROM pallets;
        """
       )
    val palletsAsList = pallets().map(row => row[String]("palletId") -> row[String]("cookieName")).toList
  }
}
