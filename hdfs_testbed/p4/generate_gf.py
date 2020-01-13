# Autogen gf multi module

def main():
    count = 28
    print """
header_type netec_t{
	fields {
		type_ : 16;
		index : 32 ;
    """,
    for i in range(count):
        print """
		data_%s : 16;
        """ % (i),
    print """
	}
}
header netec_t netec;
    """,
    print """
field_list l4_with_netec_list {
	ipv4.srcAddr;
    ipv4.dstAddr;
	meta.l4_proto;
	udp.srcPort;
	udp.dstPort; 
	udp.length_;
	netec_meta.index;
	netec_meta.type_;
    """,
    for i in range(count):
        print"""
	netec_meta.res_%s;
    """ %(i),
    print """
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
}""",
    for i in range(count):
        s = """
// AUTOGEN
register r_xor_%s{
	width : 16;
	instance_count : 65536;
}
blackbox stateful_alu s_xor_%s{
	reg : r_xor_%s;
	update_lo_1_value : register_lo ^ netec.data_%s;
	output_value : alu_lo;
	output_dst : netec_meta.res_%s;
}
table t_xor_%s{
	actions{a_xor_%s;}
	default_action : a_xor_%s();
}
action a_xor_%s(){
	s_xor_%s.execute_stateful_alu(meta.index);
}
        """ % (i,i,i,i,i,i,i,i,i,i)
        print s,
    print """
control xor {
    """,
    for i in range (count):
        s = """
    apply(t_xor_%s);
    """ % (i)
        print s,
    print """
}
    """,

    print """
action fill_netec_fields(){
    """,
    for i in range(count):
        s = """
    modify_field(netec.data_%s,netec_meta.res_%s);
    """ % (i,i)
        print s,
    print """
}
    """,

    print """
header_type netec_meta_t{
	fields{
        type_ : 16;

		index : 32;
        temp : 16;
    """,
    for i in range(count):
        print """
        res_%s : 16;
        temp_%s : 32;
        """ % (i,i),
    print """
    }
}
    """,

    for i in range(count):
        print """

register r_log_table_%s{
	width : 16;
	instance_count : 65536;
}
register r_ilog_table_%s{
    width : 16;
    instance_count : 131072;
}

table t_get_log_%s{
	actions{
		a_get_log_%s;
	}
	default_action:a_get_log_%s;
}
blackbox stateful_alu s_log_table_%s{
	reg : r_log_table_%s;
    condition_lo : netec.type_ == 1;
    update_lo_1_predicate: condition_lo;
	update_lo_1_value:meta.temp2;
    update_lo_2_predicate: not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec_meta.temp_%s;
}
action a_get_log_%s(){
	s_log_table_%s.execute_stateful_alu(netec.data_%s);
}
table t_log_add_%s{
    reads{
        netec.type_:exact;
    }
	actions{
		a_log_add_%s;
		a_log_mod_%s;
	}
	default_action:a_log_add_%s();
}
action a_log_add_%s(){
	add_to_field(netec_meta.temp_%s,meta.coeff);
}

action a_log_mod_%s(){
    modify_field(netec_meta.temp_%s,netec.index);
}
table t_get_ilog_%s{
	actions{
		a_get_ilog_%s;
	}
	default_action:a_get_ilog_%s;
}
blackbox stateful_alu s_ilog_table_%s{
	reg : r_ilog_table_%s;
    condition_lo: netec.type_ == 2;
    update_lo_1_predicate : condition_lo;
	update_lo_1_value : meta.temp;
    update_lo_2_predicate : not condition_lo;
	update_lo_2_value:register_lo;
	output_value : register_lo;
	output_dst : netec.data_%s;
}
action a_get_ilog_%s(){
	s_ilog_table_%s.execute_stateful_alu(netec_meta.temp_%s);
}

        """ % (i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i),
    print """
control gf_multiply {
    """,
    for i in range (count):
        print """
        apply(t_get_log_%s);
        """ % (i),
    for i in range (count):
        print """
        apply(t_log_add_%s);
        """ % (i),
    for i in range (count):
        print """
        if(netec.data_%s != 0)
            apply(t_get_ilog_%s);
        """ % (i,i),
    print """
}
    """,


if __name__ == '__main__':
    main()

