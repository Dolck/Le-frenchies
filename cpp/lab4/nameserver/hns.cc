#include "hns.h"

using namespace std;

HNS::HNS(unsigned long ms) : MAX_SIZE(ms) {
	dnsTable = vector<vector<std::pair<HostName, IPAddress>>>(MAX_SIZE);
}

void HNS::insert(const HostName& hn, const IPAddress& ip) {
	size_t h = hsh(hn);
	auto p = make_pair(hn, ip);
	dnsTable[hsh].push_back(p);
}

bool HNS::remove(const HostName& hn) {
	//TODO: implement
	return false;
}

IPAddress HNS::lookup(const HostName& hn) const {
	//TODO: implement
	return NON_EXISTING_ADDRESS;
}

size_t HNS::hsh(const HostName& hn) const {
	std::hash<std::string> hash_fn;
	std::size_t str_hash = hash_fn(hn);
	return str_hash % MAX_SIZE;
}
