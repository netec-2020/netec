
header_type ethernet1_t {
	fields {
	dstAddr1 : 8;
	}
}
header ethernet1_t ethernet1;

header_type ethernet2_t {
	fields {
	dstAddr2 : 40;
	srcAddr : 48;
	etherType : 16;
	}
}

header ethernet2_t ethernet2;

header_type ipv4_t {
	fields {
	version : 4;
	ihl : 4;
	diffserv : 8;
	totalLen : 16;
	identification : 16;
	flags : 3;
	fragOffset : 13;
	ttl : 8;
	protocol : 8;
	hdrChecksum : 16;
	srcAddr : 32;
	dstAddr : 32;
	}
}
header_type udp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        length_ : 16;
        checksum : 16;
    }
}
header udp_t udp;


header ipv4_t ipv4;

field_list ipv4_checksum_list {
	ipv4.version;
	ipv4.ihl;
	ipv4.diffserv;
	ipv4.totalLen;
	ipv4.identification;
	ipv4.flags;
	ipv4.fragOffset;
	ipv4.ttl;
	ipv4.protocol;
	ipv4.srcAddr;
	ipv4.dstAddr;
}
field_list_calculation ipv4_checksum {
	input {
		ipv4_checksum_list;
	}
	algorithm : csum16;
	output_width : 16;
}

calculated_field ipv4.hdrChecksum  {
	verify ipv4_checksum;
	update ipv4_checksum;
}


header_type tcp_t {
	fields {
		srcPort : 16;
		dstPort : 16;
		seqNo : 32;
		ackNo : 32;
		dataOffset : 4;
        res : 6;
        flags : 6;
		window : 16;
		checksum : 16;
		urgentPtr : 16;
    }
}
header tcp_t tcp;

header_type tcp_option_t{
	fields {
		nop1 : 32;
		sack_l : 32;
		sack_r : 32;
	}
}
header tcp_option_t sack1;

header_type tcp_option_sack2_t{
	fields {
		sack_l:32;
		sack_r:32;
	}
}
header tcp_option_sack2_t sack2;

header_type tcp_option_sack3_t{
	fields {
		sack_l:32;
		sack_r:32;
	}
}
header tcp_option_sack3_t sack3;