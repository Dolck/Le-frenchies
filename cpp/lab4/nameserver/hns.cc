#include "hns.h"

using namespace std;

HNS::HNS(unsigned long ms) : MAX_SIZE(ms) {
	dnsTable = vector<vector<pair<HostName, IPAddress>>>(MAX_SIZE);
}

void HNS::insert(const HostName& hn, const IPAddress& ip) {
	//TODO: implement
}

bool HNS::remove(const HostName& hn) {
	//TODO: implement
	return false;
}

IPAddress HNS::lookup(const HostName& hn) const {
	//TODO: implement
	return NON_EXISTING_ADDRESS;
}

size_t HNS::hash(const HostName& hn) const {
   return hash<string>()(hn);
}
