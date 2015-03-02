package models

import play.api.Play.current
import play.api.mvc._
import play.api.db._
import anorm._
import anorm.SqlParser._

object DatabaseConn{
  def getPallets() = DB.withConnection { implicit c =>
    SQL(
        """
        SELECT palletId
        FROM pallets;
        """
       ).execute()
  }
}
