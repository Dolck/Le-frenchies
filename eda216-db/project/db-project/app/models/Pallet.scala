package models

object PalletStatus extends Enumeration {
	val free, blocked, ordered, delivered = Value
}

import java.util.Date
import PalletStatus._

class Pallet(val id: Int, val prodTime: Date, val cookieName: String, var status: PalletStatus.Value, val orderId: Int, val delivDate: Date = null, val cName : String = "", val cAddress : String = "")  {
	val pId: Int = id
	val pProdTime: Date = prodTime
	val pCookie: String = cookieName
	var pStatus: PalletStatus.Value = status
	val oId: Int = orderId
    var pDelivDate: Date= delivDate
    var pCName: String = cName
    var pCAddress: String = cAddress

	def getInfoAsMap(): Map[String,String] = {
		val info = Map("Id" -> pId.toString,
					"Production time" -> pProdTime.toString,
					"Cookie name" -> pCookie,
					"Status" -> pStatus.toString,
					"OrderId" -> oId.toString)
		return info
	}
}
