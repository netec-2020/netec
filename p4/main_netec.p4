


/* network protocol */
#define TCP_FLAG_SYN 0x02
#define TCP_FLAG_ACK 0x10
#define TCP_FLAG_SA 0x12
#define TCP_FLAG_PA 0x18
#define IP_HEADER_LENGTH -20

/* configuration */
#define SWITCH_IP 0x0A00000A  /* 10.0.0.10 */

#define NETEC_DN_PORT 9866

#define DN_COUNT 3
#define FLOW_COUNT 2

#define CLIENT_PORT 136
#define DN_PORT_1 128
#define DN_PORT_2 144
#define DN_PORT_3 152

// This is P4 sample source for basic_switching
#include "netec.p4"
#include "gf.p4"
#include "includes/headers.p4"
#include "includes/parser.p4"
#include <tofino/intrinsic_metadata.p4>
#include <tofino/stateful_alu_blackbox.p4>
#include <tofino/constants.p4>

header_type custom_metadata_t {
	fields {
		flag_finish : 1;
		cksum_compensate : 32;
		l4_proto : 16;
		tcpLength : 16;
		/* for reading DN's initial SEQ# */
		sa_from_dn : 1;
		dn_init_seq : 32;
		dn_port_for_seq : 32;
		sa_finish : 1;
		tcp_seq_no : 32;
		to_drop_in_egress : 1;
		normal_packet : 1 ;
	}
}
metadata custom_metadata_t meta;
action a_nop() {
}


action a_drop() {
    drop();
}

register r_finish{
	width : 8;
	instance_count : 32768;
}

table t_finish{
	actions{ a_finish; }
	default_action : a_finish();
	size : 1;
}

blackbox stateful_alu s_finish{
	reg : r_finish;
	condition_lo : register_lo < DN_COUNT - 1;
	update_lo_1_predicate : condition_lo;
	update_lo_1_value : register_lo + 1;
	update_lo_2_predicate: not condition_lo;
	update_lo_2_value : 0;

	update_hi_1_predicate : condition_lo;
	update_hi_1_value : 0;
	update_hi_2_predicate: not condition_lo;
	update_hi_2_value : 1;

	output_value : alu_hi;
	output_dst : meta.flag_finish;

}
action a_finish(){
	s_finish.execute_stateful_alu(netec.index);
}

table t_send_res{
	actions{ a_send_res; }
	default_action : a_send_res();
	size : 1;
}
/* modify source ip address to be dst ip */
action a_send_res(){
	modify_field(ig_intr_md_for_tm.ucast_egress_port, CLIENT_PORT);
	modify_field(ipv4.srcAddr, ipv4.dstAddr);
	// fill_netec_fields();
}


/* calculate tcp compensate
 * tcp length
 * netec index, type
 * tcp options for SYN and SYNACK
 */
table t_cksum_compensate_1{
	actions{ a_cksum_compensate_1; }
	default_action : a_cksum_compensate_1();
	size : 1;
}
action a_cksum_compensate_1(){
	add(meta.tcpLength, ipv4.totalLen, IP_HEADER_LENGTH/* negative */);
	modify_field(meta.l4_proto, ipv4.protocol);
	modify_field(meta.tcp_seq_no, tcp.seqNo);
}
table t_cksum_compensate_2{
	actions{ a_cksum_compensate_2; }
	default_action : a_cksum_compensate_2();
	size : 1;
}

action a_cksum_compensate_2(){
	//modify_field(meta.cksum_compensate, TCP_OPTION_MSS_COMPENSATE);
	modify_field(meta.cksum_compensate, 0x04080789);
}
/* multicast */
table t_multicast{
	actions{
		a_mcast;
	}
	default_action : a_mcast();
	size : 1;
}

action a_mcast(){
	/* TODO: multi-group configurable multicast */
	/* modify scr ip to be dst ip */
	modify_field(ig_intr_md_for_tm.mcast_grp_a, 666);
	modify_field(ipv4.srcAddr, ipv4.dstAddr);
}

/* mark that we need to store the SEQ# */
table t_mark_sa_from_dn{
	actions{ a_mark_sa_from_dn; }
	default_action : a_mark_sa_from_dn();
	size : 1;
}

action a_mark_sa_from_dn(){
	modify_field(meta.sa_from_dn, 1);
}

/* count how many SYN+ACK we have received */
register r_sa_count{
	width : 8;
	instance_count : 1;
}
table t_sa_count{
	reads {
		ipv4.dstAddr : exact;
	}
	actions{ a_sa_count; }
	default_action : a_sa_count();
	size : FLOW_COUNT;
}
action a_sa_count(flow_num){
	s_sa_count.execute_stateful_alu(flow_num);
}
blackbox stateful_alu s_sa_count{
	reg : r_sa_count;
	condition_lo : register_lo < (DN_COUNT - 1);
	update_lo_1_predicate : condition_lo;
	update_lo_1_value : register_lo + 1;
	update_lo_2_predicate: not condition_lo;
	update_lo_2_value : 0;

	update_hi_1_predicate : condition_lo;
	update_hi_1_value : 0;
	update_hi_2_predicate: not condition_lo;
	update_hi_2_value : 1;

	output_value : alu_hi;
	output_dst : meta.sa_finish;
}
/* modify tcp.seq to 0
 * modify egress port to be CLIENT's port
 * modify source ip address to be SWITCH_IP
 */
table t_send_sa{
	actions{ a_send_sa; }
	default_action : a_send_sa();
	size : 1;
}
/* modify source ip address to be dst ip */
action a_send_sa(){
	modify_field(ig_intr_md_for_tm.ucast_egress_port, CLIENT_PORT);
	modify_field(tcp.seqNo, 0);
	modify_field(ipv4.srcAddr, ipv4.dstAddr);
}

table t_set_drop_in_egress_table{
	actions{ a_set_drop_in_egress_table; }
	default_action : a_set_drop_in_egress_table();
	size : 1;
}
action a_set_drop_in_egress_table(){
	modify_field(ig_intr_md_for_tm.ucast_egress_port, 136);
	modify_field(meta.to_drop_in_egress, 1);
}

table t_l2_forward{
	reads{
		ethernet1.dstAddr1 : exact;
		ethernet2.dstAddr2 : exact;
	}
	actions{
		a_l2_forward;
		a_nop;
	}
	default_action:a_nop();
}
action a_l2_forward(port){
	modify_field(meta.normal_packet,1);
	modify_field(ig_intr_md_for_tm.ucast_egress_port, port);
}



/************************ BEHAVIOR ************************
 * packets from CLIENT to DN:
 * on SYN: 1) Multicast, establish connection with all DNs
 * on ACK/PSH+ACK: 1) Multicast to all DNs
 *                 2) [EGRESS] modify ACK# to match each DN's SEQ#
 *
 * packets from DN to CLIENT
 * on SYN+ACK: 1) [EGRESS] store SEQ# (difference between SEQ# & 0) of all DNs
 *             2) wait until all DNs to reply
 *             3) reply SYN+ACK to client with seq#0
 * on ACK(data): 1) if not index-expected, drop it
 *               2) if it's the 1st,
 *        calculate the calibrated SEQ# and store data
 *                  if it's the 2nd,
 *        data xor
 *                  if it's the 3rd,
 *        data xor and send out (with right SEQ#), index-expected++
 */

/**************************************************/
/**************** INGRESS pipeline ****************/
control ingress {


	if(valid(tcp)){
		/* calculate tcp length for checksum */
		apply(t_cksum_compensate_1);
		if(tcp.flags == TCP_FLAG_SYN or tcp.flags == TCP_FLAG_SA){
			/* TCP options */
			apply(t_cksum_compensate_2);
		}
	} else {
		apply(t_l2_forward);
	}



	if(tcp.dstPort == NETEC_DN_PORT){
		/* packets from client
		 * always multicast to all datanodes
		 */
		if(tcp.flags == TCP_FLAG_SYN){
			/* SYN
			 * do nothing
			 */
		}else{
			/* ACK or PSH+ACK
			 * do nothing in INGRESS
			 * [EGRESS] modify ACK# to match each DN's SEQ#
			 */
		}
		apply(t_multicast);
	}else if(tcp.srcPort == NETEC_DN_PORT){
		/* packets from DNs */
		if(tcp.flags == TCP_FLAG_SA){
			/* SYN + ACK */
			apply(t_sa_count);
			if(meta.sa_finish == 1){
				apply(t_send_sa);
			}
			else{
				/* to-be-dropped packets also need to
				 * get into egress pipeline
				 */
				apply(t_set_drop_in_egress_table);
			}
		}else if(valid(netec)){
			/* set finish flag */
			apply(t_finish);
			/* calculate */
			gf_multiply();
			xor();
			/* if finish, fill in data and send out */
			if(meta.flag_finish == 1){
				apply(t_send_res);
			}
			else{
				/* to-be-dropped packets also need to
				 * get into egress pipeline
				 */
				apply(t_set_drop_in_egress_table);
			}
		}
	}
}

/**************************************************/
/***** tables and actions for EGRESS pipeline *****/
/* use egress_port to identify target DN
 * in order to read target DN's SEQ#
 */
table t_use_target_as_dn_port{
	actions{ a_use_target_as_dn_port; }
	default_action : a_use_target_as_dn_port();
	size : 1;
}
action a_use_target_as_dn_port(){
	modify_field(meta.dn_port_for_seq, eg_intr_md.egress_port);
}
/* use ingress_port to identify source DN
 * in order to read source DN's SEQ#
 */
table t_use_src_as_dn_port{
	actions{ a_use_src_as_dn_port; }
	default_action : a_use_src_as_dn_port();
	size : 1;
}
action a_use_src_as_dn_port(){
	modify_field(meta.dn_port_for_seq, ig_intr_md.ingress_port);
}
/* write DN's SEQ# if TCP SYN+ACK
 * read initial SEQ# if not SYN+ACK
 */
@pragma stage 1
table t_dn_rs_seq{
	reads{
		/* ND's port number */
		meta.dn_port_for_seq : exact;
		ipv4.dstAddr : exact;
	}
	actions{ a_dn_rs_seq; a_nop; }
	default_action : a_nop();
	size : 256;
}
action a_dn_rs_seq(dn_index){
	s_rs_seq.execute_stateful_alu(dn_index);
}
register r_dn_rs_seq{
	width : 32;
	instance_count : 100; /* the number of DNs */
}
blackbox stateful_alu s_rs_seq{
	reg : r_dn_rs_seq;
	condition_lo : meta.sa_from_dn == 1;
	/* if TCP SYN+ACK from DN, store seq# */
	update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.tcp_seq_no;
	/* else, read only */
	update_lo_2_predicate : not condition_lo;
	update_lo_2_value : register_lo;

	output_value : alu_lo;
	output_dst : meta.dn_init_seq;
}


/* modify ACK# for packets from client to DNs */
table t_modify_ack_to_DNs{
	actions{ a_modify_ack_to_DNs; }
	default_action : a_modify_ack_to_DNs();
	size : 1;
}
action a_modify_ack_to_DNs(){
	add_to_field(tcp.ackNo, meta.dn_init_seq);
	//add_to_field(tcp_option.sack_l, meta.dn_init_seq);
	//add_to_field(tcp_option.sack_r, meta.dn_init_seq);
}

table t_modify_sack_to_DNs{
	actions{ a_modify_sack_to_DNs; }
	default_action : a_modify_sack_to_DNs();
	size : 1;
}
action a_modify_sack_to_DNs(){
	//add_to_field(tcp.ackNo, meta.dn_init_seq);
	add_to_field(sack1.sack_l, meta.dn_init_seq);
	add_to_field(sack1.sack_r, meta.dn_init_seq);
}

table t_modify_sack2_to_DNs{
	actions{ a_modify_sack2_to_DNs; }
	default_action : a_modify_sack2_to_DNs();
	size : 1;
}
action a_modify_sack2_to_DNs(){
	//add_to_field(tcp.ackNo, meta.dn_init_seq);
	add_to_field(sack2.sack_l, meta.dn_init_seq);
	add_to_field(sack2.sack_r, meta.dn_init_seq);
}
table t_modify_sack3_to_DNs{
	actions{ a_modify_sack3_to_DNs; }
	default_action : a_modify_sack3_to_DNs();
	size : 1;
}
action a_modify_sack3_to_DNs(){
	//add_to_field(tcp.ackNo, meta.dn_init_seq);
	add_to_field(sack3.sack_l, meta.dn_init_seq);
	add_to_field(sack3.sack_r, meta.dn_init_seq);
}
/* modify SEQ# for data packets from DNs to client */
table t_modify_seq_to_client{
	actions{ a_modify_seq_to_client; }
	default_action : a_modify_seq_to_client();
	size : 1;
}
action a_modify_seq_to_client(){
	subtract_from_field(tcp.seqNo, meta.dn_init_seq);
}

table t_modify_ip{
	reads{
		eg_intr_md.egress_port : exact;
	}
	actions{ a_modify_ip; a_drop; }
	default_action : a_drop();
	size : 256;
}
action a_modify_ip(dip, smac, mac1, mac2){
	modify_field(ipv4.dstAddr, dip);
	modify_field(ethernet2.srcAddr,smac);
	modify_field(ethernet1.dstAddr1, mac1);
	modify_field(ethernet2.dstAddr2, mac2);
}
table t_drop_table{
	actions{ a_drop; }
	default_action : a_drop();
	size : 1;
}

/*************************************************/
/**************** EGRESS pipeline ****************/
control egress {

	/***************** store or read DNs' SEQ# *****************/
	/* if packets from DNs */
	if(tcp.srcPort == NETEC_DN_PORT){
		/* packets from DNs */
		if(tcp.flags == TCP_FLAG_SA){
			/* SYN + ACK */
			/* mark that we need to store the SEQ# */
			apply(t_mark_sa_from_dn);
		}
	}
	/* SEQ# of DNs */
	if(tcp.dstPort == NETEC_DN_PORT){
		/* from client */
		apply(t_use_target_as_dn_port);
	}else if(tcp.srcPort == NETEC_DN_PORT){
		/* from DNs */
		apply(t_use_src_as_dn_port);
	}
	/* read/store SEQ#
	 * read when packets are from client (read all three of them)
	 *   or when the packet is from DNs and is not SYN+ACK
	 * store when the packet is from DNs and is SYN+ACK
	 */
	apply(t_dn_rs_seq);
	/* modify ACK# to match each DN's SEQ# when multicasting */
	if(tcp.dstPort == NETEC_DN_PORT and tcp.flags != TCP_FLAG_SYN){
		/* packets from client, needs to modify ACK# */
		apply(t_modify_ack_to_DNs);
		if(valid(sack1)){
			apply(t_modify_sack_to_DNs);
		}
		if(valid(sack2)){
			apply(t_modify_sack2_to_DNs);
		}
		if(valid(sack3)){
			apply(t_modify_sack3_to_DNs);
		}

	}
	/* modify SEQ# to match initial SEQ#(0) when sending data to client */
	if(meta.flag_finish == 1){
		apply(t_modify_seq_to_client);
	}

	/* modify dst_ip and dst_mac
	 * according to egress port
	 */
	if(meta.to_drop_in_egress == 0){
		apply(t_modify_ip);
	}else{
		apply(t_drop_table);
	}
}


