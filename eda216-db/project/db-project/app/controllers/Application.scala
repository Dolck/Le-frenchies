package controllers

import play.api._
import play.api.mvc._
import java.util.Date
import models._
import play.api.data._
import play.api.data.Forms._
import java.text.DateFormat
import java.text.SimpleDateFormat

object Application extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def listPallets(fromDate: String, toDate: String, status: String, cookie: String) = Action {
  	var format: DateFormat = new SimpleDateFormat("yyyyMMdd:HHmmss")
  	var fDate: Date = new Date(Long.MinValue)
  	var tDate: Date = new Date(Long.MinValue)
  	if(fromDate != "")
		fDate = format.parse(fromDate)
  	if(toDate != "")
  		tDate = format.parse(toDate)
  	//Call database and retreive list of pallets

  	//temp data:
  	val p1: Pallet = new Pallet(1, new Date(), "Cookie", PalletStatus.Free)
  	val p2: Pallet = new Pallet(2, new Date(), "Cookie", PalletStatus.Free)
  	val p3: Pallet = new Pallet(3, new Date(), "Cookie", PalletStatus.Free)
  	val p4: Pallet = new Pallet(4, new Date(), "Cookie", PalletStatus.Free)
  	val ps = Array(p1, p2, p3, p4)
  	
  	Ok(views.html.palletList(ps))

  }

  def pallet(id: Int) = Action {
  	val p: Pallet = new Pallet(id, new Date(), "Cookie1", PalletStatus.Free)
    Ok(views.html.pallet(p))
  }

  def updatePallet = Action { implicit request =>
    val (status, id) = palletForm.bindFromRequest.get
    //Call database here and update pallet status
    //Then show pallet view again?
    Ok("Pallet updated")
  }

  val palletForm = Form(
    tuple(
      "status" -> text,
      "id" -> text
    )
  )
}
