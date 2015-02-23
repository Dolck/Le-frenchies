#include "hns.h"

using namespace std;

HNS::HNS(unsigned long ms) : MAX_SIZE(ms) {
	dnsTable = vector<vector<std::pair<HostName, IPAddress>>>(MAX_SIZE);
}

void HNS::insert(const HostName& hn, const IPAddress& ip) {
	size_t h = hsh(hn);
	auto p = make_pair(hn, ip);
	dnsTable[h].push_back(p);
}

bool HNS::remove(const HostName& hn) {
  size_t h = hsh(hn);
  
  auto pred = [hn](pair<HostName, IPAddress> p){return hn == p.first; };
	auto toRemove = remove_if(dnsTable[h].begin(), dnsTable[h].end(), pred);
	
	if(toRemove == dnsTable[h].end()){
		return false;
	}else{
		dnsTable[h].erase(toRemove);
		return true;
	}
}

IPAddress HNS::lookup(const HostName& hn) const {
	size_t h = hsh(hn);
	auto tmp = dnsTable[h];
	
	auto pred = [hn](pair<HostName, IPAddress> p){return hn == p.first; };
	auto it = find_if(tmp.begin(), tmp.end(), pred);
	if (it == tmp.end()) {
		return NON_EXISTING_ADDRESS;
	}else{
		return (*it).second;
	}
}

size_t HNS::hsh(const HostName& hn) const {
	std::hash<std::string> hash_fn;
	std::size_t str_hash = hash_fn(hn);
	return str_hash % MAX_SIZE;
}
