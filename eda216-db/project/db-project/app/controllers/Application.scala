package controllers

import play.api._
import play.api.mvc._
import java.util.Date
import models._
import play.api.data._
import play.api.data.Forms._

object Application extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def pallet(id: Int) = Action {
  	val p: Pallet = new Pallet(id, new Date(), "Cookie1", PalletStatus.Free)
    Ok(views.html.pallet(p))
  }

  val palletForm = Form(
    tuple(
      "status" -> text,
      "id" -> text
    )
  )

  def updatePallet = Action { implicit request =>
    val (status, id) = palletForm.bindFromRequest.get
    //Call database here and update pallet status
    //Then show pallet view again
    Ok("Pallet updated")
  }

}
