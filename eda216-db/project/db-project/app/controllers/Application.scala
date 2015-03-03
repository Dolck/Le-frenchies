package controllers

import play.api._
import play.api.mvc._
import java.util.Date
import models._

object Application extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def pallet = Action {
  	println("Hej")
  	val p: Pallet = new Pallet(1, new Date(), "Cookie1", PalletStatus.Free)
    Ok(views.html.pallet(p.getInfoAsMap()))
  }

}
