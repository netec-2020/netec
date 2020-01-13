
parser start {
	return  parse_ethernet;
}

#define ETHERTYPE_IPV4 0x0800

parser parse_ethernet {
	extract(ethernet1);
	extract(ethernet2);
	return select(ethernet1.dstAddr1) {
		0x11 : parse_ipv4;
		default: ingress;
	}
}

#define IP_PROT_TCP 0x06
#define IP_PROT_UDP 0x11

parser parse_ipv4 {
	extract(ipv4);
	return select(ipv4.protocol) {
		IP_PROT_TCP : pre_parse_tcp;
		IP_PROT_UDP : parse_udp;
		default: ingress;
	}

}

#define UDP_DPORT_NETEC 20000
parser parse_udp {
	extract(udp);
	set_metadata(meta.cksum_compensate,0);
	return select(udp.dstPort){
		UDP_DPORT_NETEC : parse_netec;
		default: ingress;
	}
}

parser pre_parse_tcp {
	return select(ipv4.totalLen){
		52 : parse_sack1;
		60 : parse_sack2;
		68 : parse_sack3;
		default : parse_tcp;
	}
}
/* server (sending data) port 20001 */
parser parse_tcp {
	extract(tcp);
	set_metadata(meta.cksum_compensate, 0);
	return select(tcp.srcPort){
		NETEC_DN_PORT : pre_parse_netec;
		default: ingress;
	}
}



parser pre_parse_netec {
	return select(tcp.flags){
		TCP_FLAG_ACK : parse_netec;
		TCP_FLAG_PA: parse_netec;
		TCP_FLAG_SA : ingress;
	}
}
parser parse_sack1 {
	extract(tcp);
	extract(sack1);
	set_metadata(meta.cksum_compensate, 0);
	return ingress;
}
parser parse_sack2 {
	extract(tcp);
	extract(sack1);
	extract(sack2);
	return ingress;
}
parser parse_sack3 {
	extract(tcp);
	extract(sack1);
	extract(sack2);
	extract(sack3);
	return ingress;
}

parser parse_netec {
	extract(netec);
	return ingress;
}


