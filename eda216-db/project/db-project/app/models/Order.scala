package models

import java.util.Date

class OrderDetails(val cookie: String, val nbrPallets: Int, var pllts: Int){
	val cookieName: String = cookie
	val nbrReqPallets: Int = nbrPallets
	var pallets: Int = pllts
}

class Order(val id: Int, val incomeDate: Date, val delivDate: Date, val custName: String, val custAddress: String, val oDetails: Array[OrderDetails])  {
	val oId: Int = id
	val iDate: Date = incomeDate
	val dDate: Date = delivDate
	val cName: String = custName
	val cAddress: String = custAddress
	val details: Array[OrderDetails] = oDetails

	def getAllCookies():String = {
		var s:String = ""
		for(od <- details){
			s += (od.cookieName + ", ")
		}
		s = s.substring(0,s.lastIndexOf(','))
		return s
	}
}
