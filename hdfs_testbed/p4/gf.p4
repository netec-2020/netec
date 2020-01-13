
header_type netec_t{
	fields {
		type_ : 16;
		index : 32 ;
     
		data_0 : 16;
         
		data_1 : 16;
         
		data_2 : 16;
         
		data_3 : 16;
         
		data_4 : 16;
         
		data_5 : 16;
         
		data_6 : 16;
         
		data_7 : 16;
         
		data_8 : 16;
         
		data_9 : 16;
         
		data_10 : 16;
         
		data_11 : 16;
         
		data_12 : 16;
         
		data_13 : 16;
         
		data_14 : 16;
         
		data_15 : 16;
         
		data_16 : 16;
         
		data_17 : 16;
         
		data_18 : 16;
         
		data_19 : 16;
         
		data_20 : 16;
         
		data_21 : 16;
         
		data_22 : 16;
         
		data_23 : 16;
         
		data_24 : 16;
         
		data_25 : 16;
         
		data_26 : 16;
         
		data_27 : 16;
         
	}
}
header netec_t netec;
     
field_list l4_with_netec_list {
	ipv4.srcAddr;
    ipv4.dstAddr;
	meta.l4_proto;
	udp.srcPort;
	udp.dstPort; 
	udp.length_;
	netec_meta.index;
	netec_meta.type_;
     
	netec_meta.res_0;
     
	netec_meta.res_1;
     
	netec_meta.res_2;
     
	netec_meta.res_3;
     
	netec_meta.res_4;
     
	netec_meta.res_5;
     
	netec_meta.res_6;
     
	netec_meta.res_7;
     
	netec_meta.res_8;
     
	netec_meta.res_9;
     
	netec_meta.res_10;
     
	netec_meta.res_11;
     
	netec_meta.res_12;
     
	netec_meta.res_13;
     
	netec_meta.res_14;
     
	netec_meta.res_15;
     
	netec_meta.res_16;
     
	netec_meta.res_17;
     
	netec_meta.res_18;
     
	netec_meta.res_19;
     
	netec_meta.res_20;
     
	netec_meta.res_21;
     
	netec_meta.res_22;
     
	netec_meta.res_23;
     
	netec_meta.res_24;
     
	netec_meta.res_25;
     
	netec_meta.res_26;
     
	netec_meta.res_27;
     
	meta.cksum_compensate;
}
field_list_calculation l4_with_netec_checksum {
    input {
        l4_with_netec_list;
    }
    algorithm : csum16;
    output_width : 16;
}

calculated_field udp.checksum  {
	update l4_with_netec_checksum;
} 
// AUTOGEN
register r_xor_0{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_0{
	reg : r_xor_0;
	update_lo_1_value : register_lo ^ netec.data_0;
	output_value : alu_lo;
	output_dst : netec_meta.res_0;
}
table t_xor_0{
	actions{a_xor_0;}
	default_action : a_xor_0();
}
action a_xor_0(){
	s_xor_0.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_1{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_1{
	reg : r_xor_1;
	update_lo_1_value : register_lo ^ netec.data_1;
	output_value : alu_lo;
	output_dst : netec_meta.res_1;
}
table t_xor_1{
	actions{a_xor_1;}
	default_action : a_xor_1();
}
action a_xor_1(){
	s_xor_1.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_2{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_2{
	reg : r_xor_2;
	update_lo_1_value : register_lo ^ netec.data_2;
	output_value : alu_lo;
	output_dst : netec_meta.res_2;
}
table t_xor_2{
	actions{a_xor_2;}
	default_action : a_xor_2();
}
action a_xor_2(){
	s_xor_2.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_3{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_3{
	reg : r_xor_3;
	update_lo_1_value : register_lo ^ netec.data_3;
	output_value : alu_lo;
	output_dst : netec_meta.res_3;
}
table t_xor_3{
	actions{a_xor_3;}
	default_action : a_xor_3();
}
action a_xor_3(){
	s_xor_3.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_4{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_4{
	reg : r_xor_4;
	update_lo_1_value : register_lo ^ netec.data_4;
	output_value : alu_lo;
	output_dst : netec_meta.res_4;
}
table t_xor_4{
	actions{a_xor_4;}
	default_action : a_xor_4();
}
action a_xor_4(){
	s_xor_4.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_5{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_5{
	reg : r_xor_5;
	update_lo_1_value : register_lo ^ netec.data_5;
	output_value : alu_lo;
	output_dst : netec_meta.res_5;
}
table t_xor_5{
	actions{a_xor_5;}
	default_action : a_xor_5();
}
action a_xor_5(){
	s_xor_5.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_6{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_6{
	reg : r_xor_6;
	update_lo_1_value : register_lo ^ netec.data_6;
	output_value : alu_lo;
	output_dst : netec_meta.res_6;
}
table t_xor_6{
	actions{a_xor_6;}
	default_action : a_xor_6();
}
action a_xor_6(){
	s_xor_6.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_7{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_7{
	reg : r_xor_7;
	update_lo_1_value : register_lo ^ netec.data_7;
	output_value : alu_lo;
	output_dst : netec_meta.res_7;
}
table t_xor_7{
	actions{a_xor_7;}
	default_action : a_xor_7();
}
action a_xor_7(){
	s_xor_7.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_8{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_8{
	reg : r_xor_8;
	update_lo_1_value : register_lo ^ netec.data_8;
	output_value : alu_lo;
	output_dst : netec_meta.res_8;
}
table t_xor_8{
	actions{a_xor_8;}
	default_action : a_xor_8();
}
action a_xor_8(){
	s_xor_8.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_9{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_9{
	reg : r_xor_9;
	update_lo_1_value : register_lo ^ netec.data_9;
	output_value : alu_lo;
	output_dst : netec_meta.res_9;
}
table t_xor_9{
	actions{a_xor_9;}
	default_action : a_xor_9();
}
action a_xor_9(){
	s_xor_9.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_10{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_10{
	reg : r_xor_10;
	update_lo_1_value : register_lo ^ netec.data_10;
	output_value : alu_lo;
	output_dst : netec_meta.res_10;
}
table t_xor_10{
	actions{a_xor_10;}
	default_action : a_xor_10();
}
action a_xor_10(){
	s_xor_10.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_11{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_11{
	reg : r_xor_11;
	update_lo_1_value : register_lo ^ netec.data_11;
	output_value : alu_lo;
	output_dst : netec_meta.res_11;
}
table t_xor_11{
	actions{a_xor_11;}
	default_action : a_xor_11();
}
action a_xor_11(){
	s_xor_11.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_12{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_12{
	reg : r_xor_12;
	update_lo_1_value : register_lo ^ netec.data_12;
	output_value : alu_lo;
	output_dst : netec_meta.res_12;
}
table t_xor_12{
	actions{a_xor_12;}
	default_action : a_xor_12();
}
action a_xor_12(){
	s_xor_12.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_13{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_13{
	reg : r_xor_13;
	update_lo_1_value : register_lo ^ netec.data_13;
	output_value : alu_lo;
	output_dst : netec_meta.res_13;
}
table t_xor_13{
	actions{a_xor_13;}
	default_action : a_xor_13();
}
action a_xor_13(){
	s_xor_13.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_14{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_14{
	reg : r_xor_14;
	update_lo_1_value : register_lo ^ netec.data_14;
	output_value : alu_lo;
	output_dst : netec_meta.res_14;
}
table t_xor_14{
	actions{a_xor_14;}
	default_action : a_xor_14();
}
action a_xor_14(){
	s_xor_14.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_15{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_15{
	reg : r_xor_15;
	update_lo_1_value : register_lo ^ netec.data_15;
	output_value : alu_lo;
	output_dst : netec_meta.res_15;
}
table t_xor_15{
	actions{a_xor_15;}
	default_action : a_xor_15();
}
action a_xor_15(){
	s_xor_15.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_16{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_16{
	reg : r_xor_16;
	update_lo_1_value : register_lo ^ netec.data_16;
	output_value : alu_lo;
	output_dst : netec_meta.res_16;
}
table t_xor_16{
	actions{a_xor_16;}
	default_action : a_xor_16();
}
action a_xor_16(){
	s_xor_16.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_17{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_17{
	reg : r_xor_17;
	update_lo_1_value : register_lo ^ netec.data_17;
	output_value : alu_lo;
	output_dst : netec_meta.res_17;
}
table t_xor_17{
	actions{a_xor_17;}
	default_action : a_xor_17();
}
action a_xor_17(){
	s_xor_17.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_18{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_18{
	reg : r_xor_18;
	update_lo_1_value : register_lo ^ netec.data_18;
	output_value : alu_lo;
	output_dst : netec_meta.res_18;
}
table t_xor_18{
	actions{a_xor_18;}
	default_action : a_xor_18();
}
action a_xor_18(){
	s_xor_18.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_19{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_19{
	reg : r_xor_19;
	update_lo_1_value : register_lo ^ netec.data_19;
	output_value : alu_lo;
	output_dst : netec_meta.res_19;
}
table t_xor_19{
	actions{a_xor_19;}
	default_action : a_xor_19();
}
action a_xor_19(){
	s_xor_19.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_20{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_20{
	reg : r_xor_20;
	update_lo_1_value : register_lo ^ netec.data_20;
	output_value : alu_lo;
	output_dst : netec_meta.res_20;
}
table t_xor_20{
	actions{a_xor_20;}
	default_action : a_xor_20();
}
action a_xor_20(){
	s_xor_20.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_21{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_21{
	reg : r_xor_21;
	update_lo_1_value : register_lo ^ netec.data_21;
	output_value : alu_lo;
	output_dst : netec_meta.res_21;
}
table t_xor_21{
	actions{a_xor_21;}
	default_action : a_xor_21();
}
action a_xor_21(){
	s_xor_21.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_22{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_22{
	reg : r_xor_22;
	update_lo_1_value : register_lo ^ netec.data_22;
	output_value : alu_lo;
	output_dst : netec_meta.res_22;
}
table t_xor_22{
	actions{a_xor_22;}
	default_action : a_xor_22();
}
action a_xor_22(){
	s_xor_22.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_23{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_23{
	reg : r_xor_23;
	update_lo_1_value : register_lo ^ netec.data_23;
	output_value : alu_lo;
	output_dst : netec_meta.res_23;
}
table t_xor_23{
	actions{a_xor_23;}
	default_action : a_xor_23();
}
action a_xor_23(){
	s_xor_23.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_24{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_24{
	reg : r_xor_24;
	update_lo_1_value : register_lo ^ netec.data_24;
	output_value : alu_lo;
	output_dst : netec_meta.res_24;
}
table t_xor_24{
	actions{a_xor_24;}
	default_action : a_xor_24();
}
action a_xor_24(){
	s_xor_24.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_25{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_25{
	reg : r_xor_25;
	update_lo_1_value : register_lo ^ netec.data_25;
	output_value : alu_lo;
	output_dst : netec_meta.res_25;
}
table t_xor_25{
	actions{a_xor_25;}
	default_action : a_xor_25();
}
action a_xor_25(){
	s_xor_25.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_26{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_26{
	reg : r_xor_26;
	update_lo_1_value : register_lo ^ netec.data_26;
	output_value : alu_lo;
	output_dst : netec_meta.res_26;
}
table t_xor_26{
	actions{a_xor_26;}
	default_action : a_xor_26();
}
action a_xor_26(){
	s_xor_26.execute_stateful_alu(meta.index);
}
         
// AUTOGEN
register r_xor_27{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_27{
	reg : r_xor_27;
	update_lo_1_value : register_lo ^ netec.data_27;
	output_value : alu_lo;
	output_dst : netec_meta.res_27;
}
table t_xor_27{
	actions{a_xor_27;}
	default_action : a_xor_27();
}
action a_xor_27(){
	s_xor_27.execute_stateful_alu(meta.index);
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
     
action fill_netec_fields(){
     
    modify_field(netec.data_0,netec_meta.res_0);
     
    modify_field(netec.data_1,netec_meta.res_1);
     
    modify_field(netec.data_2,netec_meta.res_2);
     
    modify_field(netec.data_3,netec_meta.res_3);
     
    modify_field(netec.data_4,netec_meta.res_4);
     
    modify_field(netec.data_5,netec_meta.res_5);
     
    modify_field(netec.data_6,netec_meta.res_6);
     
    modify_field(netec.data_7,netec_meta.res_7);
     
    modify_field(netec.data_8,netec_meta.res_8);
     
    modify_field(netec.data_9,netec_meta.res_9);
     
    modify_field(netec.data_10,netec_meta.res_10);
     
    modify_field(netec.data_11,netec_meta.res_11);
     
    modify_field(netec.data_12,netec_meta.res_12);
     
    modify_field(netec.data_13,netec_meta.res_13);
     
    modify_field(netec.data_14,netec_meta.res_14);
     
    modify_field(netec.data_15,netec_meta.res_15);
     
    modify_field(netec.data_16,netec_meta.res_16);
     
    modify_field(netec.data_17,netec_meta.res_17);
     
    modify_field(netec.data_18,netec_meta.res_18);
     
    modify_field(netec.data_19,netec_meta.res_19);
     
    modify_field(netec.data_20,netec_meta.res_20);
     
    modify_field(netec.data_21,netec_meta.res_21);
     
    modify_field(netec.data_22,netec_meta.res_22);
     
    modify_field(netec.data_23,netec_meta.res_23);
     
    modify_field(netec.data_24,netec_meta.res_24);
     
    modify_field(netec.data_25,netec_meta.res_25);
     
    modify_field(netec.data_26,netec_meta.res_26);
     
    modify_field(netec.data_27,netec_meta.res_27);
     
}
     
header_type netec_meta_t{
	fields{
        type_ : 16;

		index : 32;
        temp : 16;
     
        res_0 : 16;
        temp_0 : 32;
         
        res_1 : 16;
        temp_1 : 32;
         
        res_2 : 16;
        temp_2 : 32;
         
        res_3 : 16;
        temp_3 : 32;
         
        res_4 : 16;
        temp_4 : 32;
         
        res_5 : 16;
        temp_5 : 32;
         
        res_6 : 16;
        temp_6 : 32;
         
        res_7 : 16;
        temp_7 : 32;
         
        res_8 : 16;
        temp_8 : 32;
         
        res_9 : 16;
        temp_9 : 32;
         
        res_10 : 16;
        temp_10 : 32;
         
        res_11 : 16;
        temp_11 : 32;
         
        res_12 : 16;
        temp_12 : 32;
         
        res_13 : 16;
        temp_13 : 32;
         
        res_14 : 16;
        temp_14 : 32;
         
        res_15 : 16;
        temp_15 : 32;
         
        res_16 : 16;
        temp_16 : 32;
         
        res_17 : 16;
        temp_17 : 32;
         
        res_18 : 16;
        temp_18 : 32;
         
        res_19 : 16;
        temp_19 : 32;
         
        res_20 : 16;
        temp_20 : 32;
         
        res_21 : 16;
        temp_21 : 32;
         
        res_22 : 16;
        temp_22 : 32;
         
        res_23 : 16;
        temp_23 : 32;
         
        res_24 : 16;
        temp_24 : 32;
         
        res_25 : 16;
        temp_25 : 32;
         
        res_26 : 16;
        temp_26 : 32;
         
        res_27 : 16;
        temp_27 : 32;
         
    }
}
     

register r_log_table_0{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_0{
    width : 16;
    instance_count : 131072;
}

table t_get_log_0{
	actions{
		a_get_log_0;
	}
	default_action:a_get_log_0;
}
blackbox stateful_alu s_log_table_0{
	reg : r_log_table_0;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_0;
}
action a_get_log_0(){
	s_log_table_0.execute_stateful_alu(netec.data_0);
}
table t_log_add_0{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_0;
		a_log_mod_0;
	}
	default_action:a_log_add_0();
}
action a_log_add_0(){
	add_to_field(netec_meta.temp_0,meta.coeff);
}

action a_log_mod_0(){
    modify_field(netec_meta.temp_0,netec.index);
}
table t_get_ilog_0{
	actions{
		a_get_ilog_0;
	}
	default_action:a_get_ilog_0;
}
blackbox stateful_alu s_ilog_table_0{
	reg : r_ilog_table_0;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_0;
}
action a_get_ilog_0(){
	s_ilog_table_0.execute_stateful_alu(netec_meta.temp_0);
}

         

register r_log_table_1{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_1{
    width : 16;
    instance_count : 131072;
}

table t_get_log_1{
	actions{
		a_get_log_1;
	}
	default_action:a_get_log_1;
}
blackbox stateful_alu s_log_table_1{
	reg : r_log_table_1;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_1;
}
action a_get_log_1(){
	s_log_table_1.execute_stateful_alu(netec.data_1);
}
table t_log_add_1{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_1;
		a_log_mod_1;
	}
	default_action:a_log_add_1();
}
action a_log_add_1(){
	add_to_field(netec_meta.temp_1,meta.coeff);
}

action a_log_mod_1(){
    modify_field(netec_meta.temp_1,netec.index);
}
table t_get_ilog_1{
	actions{
		a_get_ilog_1;
	}
	default_action:a_get_ilog_1;
}
blackbox stateful_alu s_ilog_table_1{
	reg : r_ilog_table_1;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_1;
}
action a_get_ilog_1(){
	s_ilog_table_1.execute_stateful_alu(netec_meta.temp_1);
}

         

register r_log_table_2{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_2{
    width : 16;
    instance_count : 131072;
}

table t_get_log_2{
	actions{
		a_get_log_2;
	}
	default_action:a_get_log_2;
}
blackbox stateful_alu s_log_table_2{
	reg : r_log_table_2;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_2;
}
action a_get_log_2(){
	s_log_table_2.execute_stateful_alu(netec.data_2);
}
table t_log_add_2{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_2;
		a_log_mod_2;
	}
	default_action:a_log_add_2();
}
action a_log_add_2(){
	add_to_field(netec_meta.temp_2,meta.coeff);
}

action a_log_mod_2(){
    modify_field(netec_meta.temp_2,netec.index);
}
table t_get_ilog_2{
	actions{
		a_get_ilog_2;
	}
	default_action:a_get_ilog_2;
}
blackbox stateful_alu s_ilog_table_2{
	reg : r_ilog_table_2;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_2;
}
action a_get_ilog_2(){
	s_ilog_table_2.execute_stateful_alu(netec_meta.temp_2);
}

         

register r_log_table_3{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_3{
    width : 16;
    instance_count : 131072;
}

table t_get_log_3{
	actions{
		a_get_log_3;
	}
	default_action:a_get_log_3;
}
blackbox stateful_alu s_log_table_3{
	reg : r_log_table_3;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_3;
}
action a_get_log_3(){
	s_log_table_3.execute_stateful_alu(netec.data_3);
}
table t_log_add_3{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_3;
		a_log_mod_3;
	}
	default_action:a_log_add_3();
}
action a_log_add_3(){
	add_to_field(netec_meta.temp_3,meta.coeff);
}

action a_log_mod_3(){
    modify_field(netec_meta.temp_3,netec.index);
}
table t_get_ilog_3{
	actions{
		a_get_ilog_3;
	}
	default_action:a_get_ilog_3;
}
blackbox stateful_alu s_ilog_table_3{
	reg : r_ilog_table_3;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_3;
}
action a_get_ilog_3(){
	s_ilog_table_3.execute_stateful_alu(netec_meta.temp_3);
}

         

register r_log_table_4{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_4{
    width : 16;
    instance_count : 131072;
}

table t_get_log_4{
	actions{
		a_get_log_4;
	}
	default_action:a_get_log_4;
}
blackbox stateful_alu s_log_table_4{
	reg : r_log_table_4;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_4;
}
action a_get_log_4(){
	s_log_table_4.execute_stateful_alu(netec.data_4);
}
table t_log_add_4{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_4;
		a_log_mod_4;
	}
	default_action:a_log_add_4();
}
action a_log_add_4(){
	add_to_field(netec_meta.temp_4,meta.coeff);
}

action a_log_mod_4(){
    modify_field(netec_meta.temp_4,netec.index);
}
table t_get_ilog_4{
	actions{
		a_get_ilog_4;
	}
	default_action:a_get_ilog_4;
}
blackbox stateful_alu s_ilog_table_4{
	reg : r_ilog_table_4;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_4;
}
action a_get_ilog_4(){
	s_ilog_table_4.execute_stateful_alu(netec_meta.temp_4);
}

         

register r_log_table_5{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_5{
    width : 16;
    instance_count : 131072;
}

table t_get_log_5{
	actions{
		a_get_log_5;
	}
	default_action:a_get_log_5;
}
blackbox stateful_alu s_log_table_5{
	reg : r_log_table_5;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_5;
}
action a_get_log_5(){
	s_log_table_5.execute_stateful_alu(netec.data_5);
}
table t_log_add_5{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_5;
		a_log_mod_5;
	}
	default_action:a_log_add_5();
}
action a_log_add_5(){
	add_to_field(netec_meta.temp_5,meta.coeff);
}

action a_log_mod_5(){
    modify_field(netec_meta.temp_5,netec.index);
}
table t_get_ilog_5{
	actions{
		a_get_ilog_5;
	}
	default_action:a_get_ilog_5;
}
blackbox stateful_alu s_ilog_table_5{
	reg : r_ilog_table_5;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_5;
}
action a_get_ilog_5(){
	s_ilog_table_5.execute_stateful_alu(netec_meta.temp_5);
}

         

register r_log_table_6{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_6{
    width : 16;
    instance_count : 131072;
}

table t_get_log_6{
	actions{
		a_get_log_6;
	}
	default_action:a_get_log_6;
}
blackbox stateful_alu s_log_table_6{
	reg : r_log_table_6;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_6;
}
action a_get_log_6(){
	s_log_table_6.execute_stateful_alu(netec.data_6);
}
table t_log_add_6{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_6;
		a_log_mod_6;
	}
	default_action:a_log_add_6();
}
action a_log_add_6(){
	add_to_field(netec_meta.temp_6,meta.coeff);
}

action a_log_mod_6(){
    modify_field(netec_meta.temp_6,netec.index);
}
table t_get_ilog_6{
	actions{
		a_get_ilog_6;
	}
	default_action:a_get_ilog_6;
}
blackbox stateful_alu s_ilog_table_6{
	reg : r_ilog_table_6;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_6;
}
action a_get_ilog_6(){
	s_ilog_table_6.execute_stateful_alu(netec_meta.temp_6);
}

         

register r_log_table_7{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_7{
    width : 16;
    instance_count : 131072;
}

table t_get_log_7{
	actions{
		a_get_log_7;
	}
	default_action:a_get_log_7;
}
blackbox stateful_alu s_log_table_7{
	reg : r_log_table_7;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_7;
}
action a_get_log_7(){
	s_log_table_7.execute_stateful_alu(netec.data_7);
}
table t_log_add_7{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_7;
		a_log_mod_7;
	}
	default_action:a_log_add_7();
}
action a_log_add_7(){
	add_to_field(netec_meta.temp_7,meta.coeff);
}

action a_log_mod_7(){
    modify_field(netec_meta.temp_7,netec.index);
}
table t_get_ilog_7{
	actions{
		a_get_ilog_7;
	}
	default_action:a_get_ilog_7;
}
blackbox stateful_alu s_ilog_table_7{
	reg : r_ilog_table_7;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_7;
}
action a_get_ilog_7(){
	s_ilog_table_7.execute_stateful_alu(netec_meta.temp_7);
}

         

register r_log_table_8{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_8{
    width : 16;
    instance_count : 131072;
}

table t_get_log_8{
	actions{
		a_get_log_8;
	}
	default_action:a_get_log_8;
}
blackbox stateful_alu s_log_table_8{
	reg : r_log_table_8;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_8;
}
action a_get_log_8(){
	s_log_table_8.execute_stateful_alu(netec.data_8);
}
table t_log_add_8{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_8;
		a_log_mod_8;
	}
	default_action:a_log_add_8();
}
action a_log_add_8(){
	add_to_field(netec_meta.temp_8,meta.coeff);
}

action a_log_mod_8(){
    modify_field(netec_meta.temp_8,netec.index);
}
table t_get_ilog_8{
	actions{
		a_get_ilog_8;
	}
	default_action:a_get_ilog_8;
}
blackbox stateful_alu s_ilog_table_8{
	reg : r_ilog_table_8;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_8;
}
action a_get_ilog_8(){
	s_ilog_table_8.execute_stateful_alu(netec_meta.temp_8);
}

         

register r_log_table_9{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_9{
    width : 16;
    instance_count : 131072;
}

table t_get_log_9{
	actions{
		a_get_log_9;
	}
	default_action:a_get_log_9;
}
blackbox stateful_alu s_log_table_9{
	reg : r_log_table_9;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_9;
}
action a_get_log_9(){
	s_log_table_9.execute_stateful_alu(netec.data_9);
}
table t_log_add_9{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_9;
		a_log_mod_9;
	}
	default_action:a_log_add_9();
}
action a_log_add_9(){
	add_to_field(netec_meta.temp_9,meta.coeff);
}

action a_log_mod_9(){
    modify_field(netec_meta.temp_9,netec.index);
}
table t_get_ilog_9{
	actions{
		a_get_ilog_9;
	}
	default_action:a_get_ilog_9;
}
blackbox stateful_alu s_ilog_table_9{
	reg : r_ilog_table_9;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_9;
}
action a_get_ilog_9(){
	s_ilog_table_9.execute_stateful_alu(netec_meta.temp_9);
}

         

register r_log_table_10{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_10{
    width : 16;
    instance_count : 131072;
}

table t_get_log_10{
	actions{
		a_get_log_10;
	}
	default_action:a_get_log_10;
}
blackbox stateful_alu s_log_table_10{
	reg : r_log_table_10;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_10;
}
action a_get_log_10(){
	s_log_table_10.execute_stateful_alu(netec.data_10);
}
table t_log_add_10{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_10;
		a_log_mod_10;
	}
	default_action:a_log_add_10();
}
action a_log_add_10(){
	add_to_field(netec_meta.temp_10,meta.coeff);
}

action a_log_mod_10(){
    modify_field(netec_meta.temp_10,netec.index);
}
table t_get_ilog_10{
	actions{
		a_get_ilog_10;
	}
	default_action:a_get_ilog_10;
}
blackbox stateful_alu s_ilog_table_10{
	reg : r_ilog_table_10;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_10;
}
action a_get_ilog_10(){
	s_ilog_table_10.execute_stateful_alu(netec_meta.temp_10);
}

         

register r_log_table_11{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_11{
    width : 16;
    instance_count : 131072;
}

table t_get_log_11{
	actions{
		a_get_log_11;
	}
	default_action:a_get_log_11;
}
blackbox stateful_alu s_log_table_11{
	reg : r_log_table_11;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_11;
}
action a_get_log_11(){
	s_log_table_11.execute_stateful_alu(netec.data_11);
}
table t_log_add_11{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_11;
		a_log_mod_11;
	}
	default_action:a_log_add_11();
}
action a_log_add_11(){
	add_to_field(netec_meta.temp_11,meta.coeff);
}

action a_log_mod_11(){
    modify_field(netec_meta.temp_11,netec.index);
}
table t_get_ilog_11{
	actions{
		a_get_ilog_11;
	}
	default_action:a_get_ilog_11;
}
blackbox stateful_alu s_ilog_table_11{
	reg : r_ilog_table_11;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_11;
}
action a_get_ilog_11(){
	s_ilog_table_11.execute_stateful_alu(netec_meta.temp_11);
}

         

register r_log_table_12{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_12{
    width : 16;
    instance_count : 131072;
}

table t_get_log_12{
	actions{
		a_get_log_12;
	}
	default_action:a_get_log_12;
}
blackbox stateful_alu s_log_table_12{
	reg : r_log_table_12;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_12;
}
action a_get_log_12(){
	s_log_table_12.execute_stateful_alu(netec.data_12);
}
table t_log_add_12{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_12;
		a_log_mod_12;
	}
	default_action:a_log_add_12();
}
action a_log_add_12(){
	add_to_field(netec_meta.temp_12,meta.coeff);
}

action a_log_mod_12(){
    modify_field(netec_meta.temp_12,netec.index);
}
table t_get_ilog_12{
	actions{
		a_get_ilog_12;
	}
	default_action:a_get_ilog_12;
}
blackbox stateful_alu s_ilog_table_12{
	reg : r_ilog_table_12;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_12;
}
action a_get_ilog_12(){
	s_ilog_table_12.execute_stateful_alu(netec_meta.temp_12);
}

         

register r_log_table_13{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_13{
    width : 16;
    instance_count : 131072;
}

table t_get_log_13{
	actions{
		a_get_log_13;
	}
	default_action:a_get_log_13;
}
blackbox stateful_alu s_log_table_13{
	reg : r_log_table_13;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_13;
}
action a_get_log_13(){
	s_log_table_13.execute_stateful_alu(netec.data_13);
}
table t_log_add_13{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_13;
		a_log_mod_13;
	}
	default_action:a_log_add_13();
}
action a_log_add_13(){
	add_to_field(netec_meta.temp_13,meta.coeff);
}

action a_log_mod_13(){
    modify_field(netec_meta.temp_13,netec.index);
}
table t_get_ilog_13{
	actions{
		a_get_ilog_13;
	}
	default_action:a_get_ilog_13;
}
blackbox stateful_alu s_ilog_table_13{
	reg : r_ilog_table_13;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_13;
}
action a_get_ilog_13(){
	s_ilog_table_13.execute_stateful_alu(netec_meta.temp_13);
}

         

register r_log_table_14{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_14{
    width : 16;
    instance_count : 131072;
}

table t_get_log_14{
	actions{
		a_get_log_14;
	}
	default_action:a_get_log_14;
}
blackbox stateful_alu s_log_table_14{
	reg : r_log_table_14;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_14;
}
action a_get_log_14(){
	s_log_table_14.execute_stateful_alu(netec.data_14);
}
table t_log_add_14{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_14;
		a_log_mod_14;
	}
	default_action:a_log_add_14();
}
action a_log_add_14(){
	add_to_field(netec_meta.temp_14,meta.coeff);
}

action a_log_mod_14(){
    modify_field(netec_meta.temp_14,netec.index);
}
table t_get_ilog_14{
	actions{
		a_get_ilog_14;
	}
	default_action:a_get_ilog_14;
}
blackbox stateful_alu s_ilog_table_14{
	reg : r_ilog_table_14;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_14;
}
action a_get_ilog_14(){
	s_ilog_table_14.execute_stateful_alu(netec_meta.temp_14);
}

         

register r_log_table_15{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_15{
    width : 16;
    instance_count : 131072;
}

table t_get_log_15{
	actions{
		a_get_log_15;
	}
	default_action:a_get_log_15;
}
blackbox stateful_alu s_log_table_15{
	reg : r_log_table_15;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_15;
}
action a_get_log_15(){
	s_log_table_15.execute_stateful_alu(netec.data_15);
}
table t_log_add_15{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_15;
		a_log_mod_15;
	}
	default_action:a_log_add_15();
}
action a_log_add_15(){
	add_to_field(netec_meta.temp_15,meta.coeff);
}

action a_log_mod_15(){
    modify_field(netec_meta.temp_15,netec.index);
}
table t_get_ilog_15{
	actions{
		a_get_ilog_15;
	}
	default_action:a_get_ilog_15;
}
blackbox stateful_alu s_ilog_table_15{
	reg : r_ilog_table_15;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_15;
}
action a_get_ilog_15(){
	s_ilog_table_15.execute_stateful_alu(netec_meta.temp_15);
}

         

register r_log_table_16{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_16{
    width : 16;
    instance_count : 131072;
}

table t_get_log_16{
	actions{
		a_get_log_16;
	}
	default_action:a_get_log_16;
}
blackbox stateful_alu s_log_table_16{
	reg : r_log_table_16;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_16;
}
action a_get_log_16(){
	s_log_table_16.execute_stateful_alu(netec.data_16);
}
table t_log_add_16{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_16;
		a_log_mod_16;
	}
	default_action:a_log_add_16();
}
action a_log_add_16(){
	add_to_field(netec_meta.temp_16,meta.coeff);
}

action a_log_mod_16(){
    modify_field(netec_meta.temp_16,netec.index);
}
table t_get_ilog_16{
	actions{
		a_get_ilog_16;
	}
	default_action:a_get_ilog_16;
}
blackbox stateful_alu s_ilog_table_16{
	reg : r_ilog_table_16;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_16;
}
action a_get_ilog_16(){
	s_ilog_table_16.execute_stateful_alu(netec_meta.temp_16);
}

         

register r_log_table_17{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_17{
    width : 16;
    instance_count : 131072;
}

table t_get_log_17{
	actions{
		a_get_log_17;
	}
	default_action:a_get_log_17;
}
blackbox stateful_alu s_log_table_17{
	reg : r_log_table_17;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_17;
}
action a_get_log_17(){
	s_log_table_17.execute_stateful_alu(netec.data_17);
}
table t_log_add_17{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_17;
		a_log_mod_17;
	}
	default_action:a_log_add_17();
}
action a_log_add_17(){
	add_to_field(netec_meta.temp_17,meta.coeff);
}

action a_log_mod_17(){
    modify_field(netec_meta.temp_17,netec.index);
}
table t_get_ilog_17{
	actions{
		a_get_ilog_17;
	}
	default_action:a_get_ilog_17;
}
blackbox stateful_alu s_ilog_table_17{
	reg : r_ilog_table_17;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_17;
}
action a_get_ilog_17(){
	s_ilog_table_17.execute_stateful_alu(netec_meta.temp_17);
}

         

register r_log_table_18{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_18{
    width : 16;
    instance_count : 131072;
}

table t_get_log_18{
	actions{
		a_get_log_18;
	}
	default_action:a_get_log_18;
}
blackbox stateful_alu s_log_table_18{
	reg : r_log_table_18;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_18;
}
action a_get_log_18(){
	s_log_table_18.execute_stateful_alu(netec.data_18);
}
table t_log_add_18{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_18;
		a_log_mod_18;
	}
	default_action:a_log_add_18();
}
action a_log_add_18(){
	add_to_field(netec_meta.temp_18,meta.coeff);
}

action a_log_mod_18(){
    modify_field(netec_meta.temp_18,netec.index);
}
table t_get_ilog_18{
	actions{
		a_get_ilog_18;
	}
	default_action:a_get_ilog_18;
}
blackbox stateful_alu s_ilog_table_18{
	reg : r_ilog_table_18;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_18;
}
action a_get_ilog_18(){
	s_ilog_table_18.execute_stateful_alu(netec_meta.temp_18);
}

         

register r_log_table_19{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_19{
    width : 16;
    instance_count : 131072;
}

table t_get_log_19{
	actions{
		a_get_log_19;
	}
	default_action:a_get_log_19;
}
blackbox stateful_alu s_log_table_19{
	reg : r_log_table_19;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_19;
}
action a_get_log_19(){
	s_log_table_19.execute_stateful_alu(netec.data_19);
}
table t_log_add_19{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_19;
		a_log_mod_19;
	}
	default_action:a_log_add_19();
}
action a_log_add_19(){
	add_to_field(netec_meta.temp_19,meta.coeff);
}

action a_log_mod_19(){
    modify_field(netec_meta.temp_19,netec.index);
}
table t_get_ilog_19{
	actions{
		a_get_ilog_19;
	}
	default_action:a_get_ilog_19;
}
blackbox stateful_alu s_ilog_table_19{
	reg : r_ilog_table_19;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_19;
}
action a_get_ilog_19(){
	s_ilog_table_19.execute_stateful_alu(netec_meta.temp_19);
}

         

register r_log_table_20{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_20{
    width : 16;
    instance_count : 131072;
}

table t_get_log_20{
	actions{
		a_get_log_20;
	}
	default_action:a_get_log_20;
}
blackbox stateful_alu s_log_table_20{
	reg : r_log_table_20;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_20;
}
action a_get_log_20(){
	s_log_table_20.execute_stateful_alu(netec.data_20);
}
table t_log_add_20{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_20;
		a_log_mod_20;
	}
	default_action:a_log_add_20();
}
action a_log_add_20(){
	add_to_field(netec_meta.temp_20,meta.coeff);
}

action a_log_mod_20(){
    modify_field(netec_meta.temp_20,netec.index);
}
table t_get_ilog_20{
	actions{
		a_get_ilog_20;
	}
	default_action:a_get_ilog_20;
}
blackbox stateful_alu s_ilog_table_20{
	reg : r_ilog_table_20;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_20;
}
action a_get_ilog_20(){
	s_ilog_table_20.execute_stateful_alu(netec_meta.temp_20);
}

         

register r_log_table_21{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_21{
    width : 16;
    instance_count : 131072;
}

table t_get_log_21{
	actions{
		a_get_log_21;
	}
	default_action:a_get_log_21;
}
blackbox stateful_alu s_log_table_21{
	reg : r_log_table_21;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_21;
}
action a_get_log_21(){
	s_log_table_21.execute_stateful_alu(netec.data_21);
}
table t_log_add_21{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_21;
		a_log_mod_21;
	}
	default_action:a_log_add_21();
}
action a_log_add_21(){
	add_to_field(netec_meta.temp_21,meta.coeff);
}

action a_log_mod_21(){
    modify_field(netec_meta.temp_21,netec.index);
}
table t_get_ilog_21{
	actions{
		a_get_ilog_21;
	}
	default_action:a_get_ilog_21;
}
blackbox stateful_alu s_ilog_table_21{
	reg : r_ilog_table_21;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_21;
}
action a_get_ilog_21(){
	s_ilog_table_21.execute_stateful_alu(netec_meta.temp_21);
}

         

register r_log_table_22{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_22{
    width : 16;
    instance_count : 131072;
}

table t_get_log_22{
	actions{
		a_get_log_22;
	}
	default_action:a_get_log_22;
}
blackbox stateful_alu s_log_table_22{
	reg : r_log_table_22;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_22;
}
action a_get_log_22(){
	s_log_table_22.execute_stateful_alu(netec.data_22);
}
table t_log_add_22{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_22;
		a_log_mod_22;
	}
	default_action:a_log_add_22();
}
action a_log_add_22(){
	add_to_field(netec_meta.temp_22,meta.coeff);
}

action a_log_mod_22(){
    modify_field(netec_meta.temp_22,netec.index);
}
table t_get_ilog_22{
	actions{
		a_get_ilog_22;
	}
	default_action:a_get_ilog_22;
}
blackbox stateful_alu s_ilog_table_22{
	reg : r_ilog_table_22;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_22;
}
action a_get_ilog_22(){
	s_ilog_table_22.execute_stateful_alu(netec_meta.temp_22);
}

         

register r_log_table_23{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_23{
    width : 16;
    instance_count : 131072;
}

table t_get_log_23{
	actions{
		a_get_log_23;
	}
	default_action:a_get_log_23;
}
blackbox stateful_alu s_log_table_23{
	reg : r_log_table_23;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_23;
}
action a_get_log_23(){
	s_log_table_23.execute_stateful_alu(netec.data_23);
}
table t_log_add_23{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_23;
		a_log_mod_23;
	}
	default_action:a_log_add_23();
}
action a_log_add_23(){
	add_to_field(netec_meta.temp_23,meta.coeff);
}

action a_log_mod_23(){
    modify_field(netec_meta.temp_23,netec.index);
}
table t_get_ilog_23{
	actions{
		a_get_ilog_23;
	}
	default_action:a_get_ilog_23;
}
blackbox stateful_alu s_ilog_table_23{
	reg : r_ilog_table_23;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_23;
}
action a_get_ilog_23(){
	s_ilog_table_23.execute_stateful_alu(netec_meta.temp_23);
}

         

register r_log_table_24{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_24{
    width : 16;
    instance_count : 131072;
}

table t_get_log_24{
	actions{
		a_get_log_24;
	}
	default_action:a_get_log_24;
}
blackbox stateful_alu s_log_table_24{
	reg : r_log_table_24;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_24;
}
action a_get_log_24(){
	s_log_table_24.execute_stateful_alu(netec.data_24);
}
table t_log_add_24{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_24;
		a_log_mod_24;
	}
	default_action:a_log_add_24();
}
action a_log_add_24(){
	add_to_field(netec_meta.temp_24,meta.coeff);
}

action a_log_mod_24(){
    modify_field(netec_meta.temp_24,netec.index);
}
table t_get_ilog_24{
	actions{
		a_get_ilog_24;
	}
	default_action:a_get_ilog_24;
}
blackbox stateful_alu s_ilog_table_24{
	reg : r_ilog_table_24;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_24;
}
action a_get_ilog_24(){
	s_ilog_table_24.execute_stateful_alu(netec_meta.temp_24);
}

         

register r_log_table_25{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_25{
    width : 16;
    instance_count : 131072;
}

table t_get_log_25{
	actions{
		a_get_log_25;
	}
	default_action:a_get_log_25;
}
blackbox stateful_alu s_log_table_25{
	reg : r_log_table_25;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_25;
}
action a_get_log_25(){
	s_log_table_25.execute_stateful_alu(netec.data_25);
}
table t_log_add_25{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_25;
		a_log_mod_25;
	}
	default_action:a_log_add_25();
}
action a_log_add_25(){
	add_to_field(netec_meta.temp_25,meta.coeff);
}

action a_log_mod_25(){
    modify_field(netec_meta.temp_25,netec.index);
}
table t_get_ilog_25{
	actions{
		a_get_ilog_25;
	}
	default_action:a_get_ilog_25;
}
blackbox stateful_alu s_ilog_table_25{
	reg : r_ilog_table_25;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_25;
}
action a_get_ilog_25(){
	s_ilog_table_25.execute_stateful_alu(netec_meta.temp_25);
}

         

register r_log_table_26{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_26{
    width : 16;
    instance_count : 131072;
}

table t_get_log_26{
	actions{
		a_get_log_26;
	}
	default_action:a_get_log_26;
}
blackbox stateful_alu s_log_table_26{
	reg : r_log_table_26;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_26;
}
action a_get_log_26(){
	s_log_table_26.execute_stateful_alu(netec.data_26);
}
table t_log_add_26{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_26;
		a_log_mod_26;
	}
	default_action:a_log_add_26();
}
action a_log_add_26(){
	add_to_field(netec_meta.temp_26,meta.coeff);
}

action a_log_mod_26(){
    modify_field(netec_meta.temp_26,netec.index);
}
table t_get_ilog_26{
	actions{
		a_get_ilog_26;
	}
	default_action:a_get_ilog_26;
}
blackbox stateful_alu s_ilog_table_26{
	reg : r_ilog_table_26;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_26;
}
action a_get_ilog_26(){
	s_ilog_table_26.execute_stateful_alu(netec_meta.temp_26);
}

         

register r_log_table_27{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_27{
    width : 16;
    instance_count : 131072;
}

table t_get_log_27{
	actions{
		a_get_log_27;
	}
	default_action:a_get_log_27;
}
blackbox stateful_alu s_log_table_27{
	reg : r_log_table_27;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_27;
}
action a_get_log_27(){
	s_log_table_27.execute_stateful_alu(netec.data_27);
}
table t_log_add_27{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_27;
		a_log_mod_27;
	}
	default_action:a_log_add_27();
}
action a_log_add_27(){
	add_to_field(netec_meta.temp_27,meta.coeff);
}

action a_log_mod_27(){
    modify_field(netec_meta.temp_27,netec.index);
}
table t_get_ilog_27{
	actions{
		a_get_ilog_27;
	}
	default_action:a_get_ilog_27;
}
blackbox stateful_alu s_ilog_table_27{
	reg : r_ilog_table_27;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_27;
}
action a_get_ilog_27(){
	s_ilog_table_27.execute_stateful_alu(netec_meta.temp_27);
}

         
control gf_multiply {
     
        apply(t_get_log_0);
         
        apply(t_get_log_1);
         
        apply(t_get_log_2);
         
        apply(t_get_log_3);
         
        apply(t_get_log_4);
         
        apply(t_get_log_5);
         
        apply(t_get_log_6);
         
        apply(t_get_log_7);
         
        apply(t_get_log_8);
         
        apply(t_get_log_9);
         
        apply(t_get_log_10);
         
        apply(t_get_log_11);
         
        apply(t_get_log_12);
         
        apply(t_get_log_13);
         
        apply(t_get_log_14);
         
        apply(t_get_log_15);
         
        apply(t_get_log_16);
         
        apply(t_get_log_17);
         
        apply(t_get_log_18);
         
        apply(t_get_log_19);
         
        apply(t_get_log_20);
         
        apply(t_get_log_21);
         
        apply(t_get_log_22);
         
        apply(t_get_log_23);
         
        apply(t_get_log_24);
         
        apply(t_get_log_25);
         
        apply(t_get_log_26);
         
        apply(t_get_log_27);
         
        apply(t_log_add_0);
         
        apply(t_log_add_1);
         
        apply(t_log_add_2);
         
        apply(t_log_add_3);
         
        apply(t_log_add_4);
         
        apply(t_log_add_5);
         
        apply(t_log_add_6);
         
        apply(t_log_add_7);
         
        apply(t_log_add_8);
         
        apply(t_log_add_9);
         
        apply(t_log_add_10);
         
        apply(t_log_add_11);
         
        apply(t_log_add_12);
         
        apply(t_log_add_13);
         
        apply(t_log_add_14);
         
        apply(t_log_add_15);
         
        apply(t_log_add_16);
         
        apply(t_log_add_17);
         
        apply(t_log_add_18);
         
        apply(t_log_add_19);
         
        apply(t_log_add_20);
         
        apply(t_log_add_21);
         
        apply(t_log_add_22);
         
        apply(t_log_add_23);
         
        apply(t_log_add_24);
         
        apply(t_log_add_25);
         
        apply(t_log_add_26);
         
        apply(t_log_add_27);
         
        if(netec.data_0 != 0)
            apply(t_get_ilog_0);
         
        if(netec.data_1 != 0)
            apply(t_get_ilog_1);
         
        if(netec.data_2 != 0)
            apply(t_get_ilog_2);
         
        if(netec.data_3 != 0)
            apply(t_get_ilog_3);
         
        if(netec.data_4 != 0)
            apply(t_get_ilog_4);
         
        if(netec.data_5 != 0)
            apply(t_get_ilog_5);
         
        if(netec.data_6 != 0)
            apply(t_get_ilog_6);
         
        if(netec.data_7 != 0)
            apply(t_get_ilog_7);
         
        if(netec.data_8 != 0)
            apply(t_get_ilog_8);
         
        if(netec.data_9 != 0)
            apply(t_get_ilog_9);
         
        if(netec.data_10 != 0)
            apply(t_get_ilog_10);
         
        if(netec.data_11 != 0)
            apply(t_get_ilog_11);
         
        if(netec.data_12 != 0)
            apply(t_get_ilog_12);
         
        if(netec.data_13 != 0)
            apply(t_get_ilog_13);
         
        if(netec.data_14 != 0)
            apply(t_get_ilog_14);
         
        if(netec.data_15 != 0)
            apply(t_get_ilog_15);
         
        if(netec.data_16 != 0)
            apply(t_get_ilog_16);
         
        if(netec.data_17 != 0)
            apply(t_get_ilog_17);
         
        if(netec.data_18 != 0)
            apply(t_get_ilog_18);
         
        if(netec.data_19 != 0)
            apply(t_get_ilog_19);
         
        if(netec.data_20 != 0)
            apply(t_get_ilog_20);
         
        if(netec.data_21 != 0)
            apply(t_get_ilog_21);
         
        if(netec.data_22 != 0)
            apply(t_get_ilog_22);
         
        if(netec.data_23 != 0)
            apply(t_get_ilog_23);
         
        if(netec.data_24 != 0)
            apply(t_get_ilog_24);
         
        if(netec.data_25 != 0)
            apply(t_get_ilog_25);
         
        if(netec.data_26 != 0)
            apply(t_get_ilog_26);
         
        if(netec.data_27 != 0)
            apply(t_get_ilog_27);
         
}
    
