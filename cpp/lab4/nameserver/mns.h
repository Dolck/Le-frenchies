#ifndef MNS_H
#define MNS_H

#include <map>
#include "nameserverinterface.h"

using namespace std;

class MNS : public NameServerInterface {
public:
	MNS();
	void insert(const HostName&, const IPAddress&);
	bool remove(const HostName&);
	IPAddress lookup(const HostName&) const;
private:
	map<HostName, IPAddress> dnsTable;
};

#endif
