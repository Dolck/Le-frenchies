#ifndef MNS_H
#define MNS_H

#include "nameserverinterface.h"
#include <map>

using namespace std;

class MNS : public nameserverinterface {
public:
	VNS();
	void insert(const HostName&, const IPAddress&);
	bool remove(const HostName&);
	IPAddress lookup(const HostName&) const;
private:
	map<HostName, IPAddress> dnsTable;
};

#endif