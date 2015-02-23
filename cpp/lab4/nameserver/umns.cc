#include "umns.h"

using namespace std;

UMNS::UMNS() {
	dnsTable = map<HostName, IPAddress> ();
}

void UMNS::insert(const HostName& hn, const IPAddress& ip) {
	dnsTable.insert(hn, ip);
}

bool UMNS::remove(const HostName& hn) {
	return dnsTable.erase(hn);
}

IPAddress UMNS::lookup(const HostName& hn) const {
	auto it = dnsTable.find(hn);
	if(it == dnsTable.end()){
		return NON_EXISTING_ADDRESS;
	}else{
		return (*it).second;
	}
}
