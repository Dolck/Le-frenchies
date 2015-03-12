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

    var list = DatabaseConn.getPallets(fDate, tDate, cookie, status)
    println(list)
  	
  	val fd:String = format.format(fDate)
  	val td:String = format.format(tDate)

  	Ok(views.html.palletList(list, fd, td, status, cookie))

  }

  def pallet(id: Int) = Action {
    val p: Pallet = DatabaseConn.getPallet(id)
    Ok(views.html.pallet(p))
  }

  def updatePallet = Action { implicit request =>
    val (status, id) = palletForm.bindFromRequest.get
    DatabaseConn.changePalletStatus(id.toInt, PalletStatus.withName(status))
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
    val orders: List[Order] = DatabaseConn.getOrders

    Ok(views.html.orderList(orders))
  }

  def chooseCookie(oId: Int, statusmsg: String) = Action {
    /*val p1: Pallet = new Pallet(1, new Date(), "Tango", PalletStatus.free, 1)
    val od1: OrderDetails = new OrderDetails("Tango", 2, 1)
    val details: List[OrderDetails] = List(od1)*/
    val details: List[OrderDetails] = DatabaseConn.getOrderDetails(oId)

    Ok(views.html.order(details, oId, statusmsg))
  }

  def createPallet(cookieName: String, orderId: Int) = Action{
    val success: Boolean = DatabaseConn.createPallet(cookieName, PalletStatus.ordered, orderId)
    var msg: String = "Successfully created pallet"
    if(!success)
      msg = "Unable to create pallet, try again"
    Redirect(routes.Application.chooseCookie(orderId, msg))
  }

}
