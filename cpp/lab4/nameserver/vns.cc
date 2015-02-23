#include <utility>
#include <vector>
#include <iostream>
#include <algorithm>
#include "vns.h"

using namespace std;

VNS::VNS() {
	dnsTable = vector<pair<HostName, IPAddress>>();
}

void VNS::insert(const HostName& hn, const IPAddress& ip) {
	auto p = make_pair(hn, ip);
	dnsTable.push_back(p);
}

bool VNS::remove(const HostName& hn) {
	auto pred = [hn](pair<HostName, IPAddress> p){return hn == p.first; };
	auto toRemove = remove_if(dnsTable.begin(), dnsTable.end(), pred);
	
	if(toRemove == dnsTable.end()){
		return false;
	}else{
		dnsTable.erase(toRemove);
		return true;
	}
}

IPAddress VNS::lookup(const HostName& hn) const {
	auto pred = [hn](pair<HostName, IPAddress> p){return hn == p.first; };
	auto res = find_if(dnsTable.begin(), dnsTable.end(), pred);
	if (res == dnsTable.end()) {
		return NON_EXISTING_ADDRESS;
	}else{
		return res.second;
	}
}