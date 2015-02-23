#ifndef HNS_H
#define HNS_H

#include "nameserverinterface.h"

using namespace std;

class HNS : public nameserverinterface {
public:
	HNS();
	void insert(const HostName&, const IPAddress&);
	bool remove(const HostName&);
	IPAddress lookup(const HostName&) const;
private:
	unsigned long MAX_SIZE;
	vector<vector<HostName, IPAddress>> dnsTable;
	size_t hash(const HostName&) const;
};

#endif