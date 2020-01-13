// AutoGen
// NetEC data field count: 28
// data width: 32

#define TCP_OPTION_MSS_COMPENSATE 0x02040076 /* MSS 118 */


header_type netec_t{
	fields {
		type_ : 16;
		index : 32;

		data_0 : 32;
		data_1 : 32;
		data_2 : 32;
		data_3 : 32;
		data_4 : 32;
		data_5 : 32;
		data_6 : 32;
		data_7 : 32;
		data_8 : 32;
		data_9 : 32;
		data_10 : 32;
		data_11 : 32;
		data_12 : 32;
		data_13 : 32;
		data_14 : 32;
		data_15 : 32;
		data_16 : 32;
		data_17 : 32;
		data_18 : 32;
		data_19 : 32;
		data_20 : 32;
		data_21 : 32;
		data_22 : 32;
		data_23 : 32;
		data_24 : 32;
		data_25 : 32;
		data_26 : 32;
		data_27 : 32;

	}
}
header netec_t netec;


field_list l4_with_netec_list_udp {
	ipv4.srcAddr;
	ipv4.dstAddr;
	//TOFINO: A bug about alignments, the eight zeroes seem not working. We comment out the protocol field (often unchanged) to get around this bug. The TCP checksum now works fine.
	//8'0;
	//ipv4.protocol;
	meta.l4_proto;
	udp.srcPort;
	udp.dstPort;
	udp.length_;
	netec.index;
	netec.type_;

	netec.data_0;
	netec.data_1;
	netec.data_2;
	netec.data_3;
	netec.data_4;
	netec.data_5;
	netec.data_6;
	netec.data_7;
	netec.data_8;
	netec.data_9;
	netec.data_10;
	netec.data_11;
	netec.data_12;
	netec.data_13;
	netec.data_14;
	netec.data_15;
	netec.data_16;
	netec.data_17;
	netec.data_18;
	netec.data_19;
	netec.data_20;
	netec.data_21;
	netec.data_22;
	netec.data_23;
	netec.data_24;
	netec.data_25;
	netec.data_26;
	netec.data_27;
	meta.cksum_compensate;
}

field_list l4_with_netec_list_tcp {
	ipv4.srcAddr;
	ipv4.dstAddr;
	meta.l4_proto;
	meta.tcpLength;
	tcp.srcPort;
	tcp.dstPort;
	tcp.seqNo;
	tcp.ackNo;
	tcp.dataOffset;
	tcp.res;
	tcp.flags;
	tcp.window;
	tcp.urgentPtr;
	sack1.nop1;
	sack1.sack_l;
	sack1.sack_r;
	sack2.sack_l;
	sack2.sack_r;
	sack3.sack_l;
	sack3.sack_r;
	netec.index;
	netec.type_;
	netec.data_0;
	netec.data_1;
	netec.data_2;
	netec.data_3;
	netec.data_4;
	netec.data_5;
	netec.data_6;
	netec.data_7;
	netec.data_8;
	netec.data_9;
	netec.data_10;
	netec.data_11;
	netec.data_12;
	netec.data_13;
	netec.data_14;
	netec.data_15;
	netec.data_16;
	netec.data_17;
	netec.data_18;
	netec.data_19;
	netec.data_20;
	netec.data_21;
	netec.data_22;
	netec.data_23;
	netec.data_24;
	netec.data_25;
	netec.data_26;
	netec.data_27;

}

field_list_calculation l4_with_netec_checksum {
    input {
        l4_with_netec_list_tcp;
    }
    algorithm : csum16;
    output_width : 16;
}

calculated_field tcp.checksum  {
	update l4_with_netec_checksum;
	verify l4_with_netec_checksum;
}

// AUTOGEN
register r_xor_0{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_0{
	reg : r_xor_0;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_0;

    update_hi_1_value : register_lo ^ netec.data_0;
	output_value : alu_hi;
	output_dst : netec.data_0;
}
@pragma stage 4
table t_xor_0{
	actions{a_xor_0;}
	default_action : a_xor_0();
    size : 1;
}
action a_xor_0(){
	s_xor_0.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_1{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_1{
	reg : r_xor_1;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_1;

    update_hi_1_value : register_lo ^ netec.data_1;
	output_value : alu_hi;
	output_dst : netec.data_1;
}
@pragma stage 5
table t_xor_1{
	actions{a_xor_1;}
	default_action : a_xor_1();
    size : 1;
}
action a_xor_1(){
	s_xor_1.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_2{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_2{
	reg : r_xor_2;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_2;

    update_hi_1_value : register_lo ^ netec.data_2;
	output_value : alu_hi;
	output_dst : netec.data_2;
}
@pragma stage 5
table t_xor_2{
	actions{a_xor_2;}
	default_action : a_xor_2();
    size : 1;
}
action a_xor_2(){
	s_xor_2.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_3{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_3{
	reg : r_xor_3;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_3;

    update_hi_1_value : register_lo ^ netec.data_3;
	output_value : alu_hi;
	output_dst : netec.data_3;
}
@pragma stage 5
table t_xor_3{
	actions{a_xor_3;}
	default_action : a_xor_3();
    size : 1;
}
action a_xor_3(){
	s_xor_3.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_4{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_4{
	reg : r_xor_4;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_4;

    update_hi_1_value : register_lo ^ netec.data_4;
	output_value : alu_hi;
	output_dst : netec.data_4;
}
@pragma stage 5
table t_xor_4{
	actions{a_xor_4;}
	default_action : a_xor_4();
    size : 1;
}
action a_xor_4(){
	s_xor_4.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_5{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_5{
	reg : r_xor_5;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_5;

    update_hi_1_value : register_lo ^ netec.data_5;
	output_value : alu_hi;
	output_dst : netec.data_5;
}
@pragma stage 6
table t_xor_5{
	actions{a_xor_5;}
	default_action : a_xor_5();
    size : 1;
}
action a_xor_5(){
	s_xor_5.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_6{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_6{
	reg : r_xor_6;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_6;

    update_hi_1_value : register_lo ^ netec.data_6;
	output_value : alu_hi;
	output_dst : netec.data_6;
}
@pragma stage 6
table t_xor_6{
	actions{a_xor_6;}
	default_action : a_xor_6();
    size : 1;
}
action a_xor_6(){
	s_xor_6.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_7{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_7{
	reg : r_xor_7;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_7;

    update_hi_1_value : register_lo ^ netec.data_7;
	output_value : alu_hi;
	output_dst : netec.data_7;
}
@pragma stage 6
table t_xor_7{
	actions{a_xor_7;}
	default_action : a_xor_7();
    size : 1;
}
action a_xor_7(){
	s_xor_7.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_8{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_8{
	reg : r_xor_8;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_8;

    update_hi_1_value : register_lo ^ netec.data_8;
	output_value : alu_hi;
	output_dst : netec.data_8;
}
@pragma stage 6
table t_xor_8{
	actions{a_xor_8;}
	default_action : a_xor_8();
    size : 1;
}
action a_xor_8(){
	s_xor_8.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_9{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_9{
	reg : r_xor_9;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_9;

    update_hi_1_value : register_lo ^ netec.data_9;
	output_value : alu_hi;
	output_dst : netec.data_9;
}
@pragma stage 7
table t_xor_9{
	actions{a_xor_9;}
	default_action : a_xor_9();
    size : 1;
}
action a_xor_9(){
	s_xor_9.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_10{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_10{
	reg : r_xor_10;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_10;

    update_hi_1_value : register_lo ^ netec.data_10;
	output_value : alu_hi;
	output_dst : netec.data_10;
}
@pragma stage 7
table t_xor_10{
	actions{a_xor_10;}
	default_action : a_xor_10();
    size : 1;
}
action a_xor_10(){
	s_xor_10.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_11{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_11{
	reg : r_xor_11;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_11;

    update_hi_1_value : register_lo ^ netec.data_11;
	output_value : alu_hi;
	output_dst : netec.data_11;
}
@pragma stage 7
table t_xor_11{
	actions{a_xor_11;}
	default_action : a_xor_11();
    size : 1;
}
action a_xor_11(){
	s_xor_11.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_12{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_12{
	reg : r_xor_12;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_12;

    update_hi_1_value : register_lo ^ netec.data_12;
	output_value : alu_hi;
	output_dst : netec.data_12;
}
@pragma stage 7
table t_xor_12{
	actions{a_xor_12;}
	default_action : a_xor_12();
    size : 1;
}
action a_xor_12(){
	s_xor_12.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_13{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_13{
	reg : r_xor_13;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_13;

    update_hi_1_value : register_lo ^ netec.data_13;
	output_value : alu_hi;
	output_dst : netec.data_13;
}
@pragma stage 8
table t_xor_13{
	actions{a_xor_13;}
	default_action : a_xor_13();
    size : 1;
}
action a_xor_13(){
	s_xor_13.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_14{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_14{
	reg : r_xor_14;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_14;

    update_hi_1_value : register_lo ^ netec.data_14;
	output_value : alu_hi;
	output_dst : netec.data_14;
}
@pragma stage 8
table t_xor_14{
	actions{a_xor_14;}
	default_action : a_xor_14();
    size : 1;
}
action a_xor_14(){
	s_xor_14.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_15{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_15{
	reg : r_xor_15;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_15;

    update_hi_1_value : register_lo ^ netec.data_15;
	output_value : alu_hi;
	output_dst : netec.data_15;
}
@pragma stage 8
table t_xor_15{
	actions{a_xor_15;}
	default_action : a_xor_15();
    size : 1;
}
action a_xor_15(){
	s_xor_15.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_16{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_16{
	reg : r_xor_16;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_16;

    update_hi_1_value : register_lo ^ netec.data_16;
	output_value : alu_hi;
	output_dst : netec.data_16;
}
@pragma stage 8
table t_xor_16{
	actions{a_xor_16;}
	default_action : a_xor_16();
    size : 1;
}
action a_xor_16(){
	s_xor_16.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_17{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_17{
	reg : r_xor_17;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_17;

    update_hi_1_value : register_lo ^ netec.data_17;
	output_value : alu_hi;
	output_dst : netec.data_17;
}
@pragma stage 9
table t_xor_17{
	actions{a_xor_17;}
	default_action : a_xor_17();
    size : 1;
}
action a_xor_17(){
	s_xor_17.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_18{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_18{
	reg : r_xor_18;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_18;

    update_hi_1_value : register_lo ^ netec.data_18;
	output_value : alu_hi;
	output_dst : netec.data_18;
}
@pragma stage 9
table t_xor_18{
	actions{a_xor_18;}
	default_action : a_xor_18();
    size : 1;
}
action a_xor_18(){
	s_xor_18.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_19{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_19{
	reg : r_xor_19;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_19;

    update_hi_1_value : register_lo ^ netec.data_19;
	output_value : alu_hi;
	output_dst : netec.data_19;
}
@pragma stage 9
table t_xor_19{
	actions{a_xor_19;}
	default_action : a_xor_19();
    size : 1;
}
action a_xor_19(){
	s_xor_19.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_20{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_20{
	reg : r_xor_20;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_20;

    update_hi_1_value : register_lo ^ netec.data_20;
	output_value : alu_hi;
	output_dst : netec.data_20;
}
@pragma stage 9
table t_xor_20{
	actions{a_xor_20;}
	default_action : a_xor_20();
    size : 1;
}
action a_xor_20(){
	s_xor_20.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_21{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_21{
	reg : r_xor_21;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_21;

    update_hi_1_value : register_lo ^ netec.data_21;
	output_value : alu_hi;
	output_dst : netec.data_21;
}
@pragma stage 10
table t_xor_21{
	actions{a_xor_21;}
	default_action : a_xor_21();
    size : 1;
}
action a_xor_21(){
	s_xor_21.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_22{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_22{
	reg : r_xor_22;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_22;

    update_hi_1_value : register_lo ^ netec.data_22;
	output_value : alu_hi;
	output_dst : netec.data_22;
}
@pragma stage 10
table t_xor_22{
	actions{a_xor_22;}
	default_action : a_xor_22();
    size : 1;
}
action a_xor_22(){
	s_xor_22.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_23{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_23{
	reg : r_xor_23;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_23;

    update_hi_1_value : register_lo ^ netec.data_23;
	output_value : alu_hi;
	output_dst : netec.data_23;
}
@pragma stage 10
table t_xor_23{
	actions{a_xor_23;}
	default_action : a_xor_23();
    size : 1;
}
action a_xor_23(){
	s_xor_23.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_24{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_24{
	reg : r_xor_24;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_24;

    update_hi_1_value : register_lo ^ netec.data_24;
	output_value : alu_hi;
	output_dst : netec.data_24;
}
@pragma stage 10
table t_xor_24{
	actions{a_xor_24;}
	default_action : a_xor_24();
    size : 1;
}
action a_xor_24(){
	s_xor_24.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_25{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_25{
	reg : r_xor_25;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_25;

    update_hi_1_value : register_lo ^ netec.data_25;
	output_value : alu_hi;
	output_dst : netec.data_25;
}
@pragma stage 11
table t_xor_25{
	actions{a_xor_25;}
	default_action : a_xor_25();
    size : 1;
}
action a_xor_25(){
	s_xor_25.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_26{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_26{
	reg : r_xor_26;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_26;

    update_hi_1_value : register_lo ^ netec.data_26;
	output_value : alu_hi;
	output_dst : netec.data_26;
}
@pragma stage 11
table t_xor_26{
	actions{a_xor_26;}
	default_action : a_xor_26();
    size : 1;
}
action a_xor_26(){
	s_xor_26.execute_stateful_alu(netec.index);
}

// AUTOGEN
register r_xor_27{
	width : 32;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_27{
	reg : r_xor_27;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ netec.data_27;

    update_hi_1_value : register_lo ^ netec.data_27;
	output_value : alu_hi;
	output_dst : netec.data_27;
}
@pragma stage 11
table t_xor_27{
	actions{a_xor_27;}
	default_action : a_xor_27();
    size : 1;
}
action a_xor_27(){
	s_xor_27.execute_stateful_alu(netec.index);
}

control xor {

	apply(t_xor_0);
	apply(t_xor_1);
	apply(t_xor_2);
	apply(t_xor_3);
	apply(t_xor_4);
	apply(t_xor_5);
	apply(t_xor_6);
	apply(t_xor_7);
	apply(t_xor_8);
	apply(t_xor_9);
	apply(t_xor_10);
	apply(t_xor_11);
	apply(t_xor_12);
	apply(t_xor_13);
	apply(t_xor_14);
	apply(t_xor_15);
	apply(t_xor_16);
	apply(t_xor_17);
	apply(t_xor_18);
	apply(t_xor_19);
	apply(t_xor_20);
	apply(t_xor_21);
	apply(t_xor_22);
	apply(t_xor_23);
	apply(t_xor_24);
	apply(t_xor_25);
	apply(t_xor_26);
	apply(t_xor_27);

}
