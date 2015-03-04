package models

import java.util.Date

class OrderDetails(val cookie: String, val nbrPallets: Int, var pllts: Array[Pallet]){
	val cookieName: String = cookie
	val nbrReqPallets: Int = nbrPallets
	var pallets: Array[Pallet] = pllts
}

class Order(val id: Int, val incomeDate: Date, val delivDate: Date, val custName: String, val custAddress: String, val oDetails: Array[OrderDetails])  {
	val oId: Int = id
	val iDate: Date = incomeDate
	val dDate: Date = delivDate
	val cName: String = custName
	val cAddress: String = custAddress
	val details: Array[OrderDetails] = oDetails
}
