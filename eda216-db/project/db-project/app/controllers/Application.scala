package controllers

import play.api._
import play.api.mvc._

object Application extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def pallet = Action {
    Ok(views.html.index("This is a pallet"))
  }

}
