#include "mns.h"

using namespace std;

MNS::MNS() {
	dnsTable = map<HostName, IPAddress> ();
}

void MNS::insert(const HostName& hn, const IPAddress& ip) {
	dnsTable.insert(make_pair(hn, ip));
}

bool MNS::remove(const HostName& hn) {
	return dnsTable.erase(hn);
	/*auto it = dnsTable.find(hn);
	if(it == dnsTable.end()){
		return false
	}else{
		dnsTable.erase (it); 
		return true;
	}*/
}

IPAddress MNS::lookup(const HostName& hn) const {
	auto it = dnsTable.find(hn);
	if(it == dnsTable.end()){
		return NON_EXISTING_ADDRESS;
	}else{
		return (*it).second;
	}
}
