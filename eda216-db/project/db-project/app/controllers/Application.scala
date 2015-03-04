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
  	//Dateformat: YYYYY-MM-DD + 'T' + HH:mm
  	var format: DateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm")
  	var fDate: Date = new Date()
  	fDate = format.parse("1900-01-01T00:00")
  	var tDate: Date = new Date() //Just really big and small default values
  	tDate = format.parse("2100-01-01T00:00")
  	if(fromDate != ""){
  		try { 
			fDate = format.parse(fromDate)
  		} catch {
			case e: Exception => println("formatting exception fromDate: " + fDate)
  		}
  	}
  	if(toDate != ""){
  		try { 
			tDate = format.parse(toDate)
  		} catch {
			case e: Exception => println("formatting exception toDate: " + tDate)
  		}
  	}

  	//Call database and retreive list of pallets here

  	//temp data:
  	val p1: Pallet = new Pallet(1, new Date(), "Cookie", PalletStatus.free, 101)
  	val p2: Pallet = new Pallet(2, new Date(), "Cookie", PalletStatus.free, 102)
  	val p3: Pallet = new Pallet(3, new Date(), "Cookie", PalletStatus.free, 103)
  	val p4: Pallet = new Pallet(4, new Date(), "Cookie", PalletStatus.free, 104)
  	val ps = Array(p1, p2, p3, p4)
  	
  	val fd:String = format.format(fDate)
  	val td:String = format.format(tDate)

  	Ok(views.html.palletList(ps, fd, td, status, cookie))

  }

  def pallet(id: Int) = Action {
  	//Retreive pallet from database here
  	val p: Pallet = new Pallet(id, new Date(), "Cookie1", PalletStatus.free, 101)
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

  def listOrders = Action {

    Ok("lists orders")
  }
}
