# Autogen xor buffer tables and related modules

data_count_per_header = 42

def netec_data_instance_name(index):
    if index < data_count_per_header:
        return "netec.data_%s" % index
    elif index >= data_count_per_header:
        return "netec_%s.data_%s" % (index / data_count_per_header + 1, index)

def print_header(count, data_width):
    print """
header_type netec_t{
\tfields {
\t\ttype_ : 16;
\t\tindex : 32;\n"""

    for i in range(min(count, data_count_per_header)):
        print """\t\tdata_%s : %s;\n""" % (i, data_width),
    print """
\t}
}
header netec_t netec;
"""

    for i in range(2, (count - 1) / data_count_per_header + 2):
        print """
header_type netec_%s_t{
    fields {""" % i
        for j in range(data_count_per_header * (i - 1), count):
            print """\t\tdata_%s : %s;\n""" % (j, data_width),
        print """\t}\n}"""

        print """header netec_%s_t netec_%s;\n""" % (i, i)

def print_checksum(count):
    # udp
    print """
field_list l4_with_netec_list_udp {
\tipv4.srcAddr;
\tipv4.dstAddr;
\t//TOFINO: A bug about alignments, the eight zeroes seem not working. We comment out the protocol field (often unchanged) to get around this bug. The TCP checksum now works fine.
\t//8'0;
\t//ipv4.protocol;
\tmeta.l4_proto;
\tudp.srcPort;
\tudp.dstPort;
\tudp.length_;
\tnetec.index;
\tnetec.type_;
"""

    for i in range(count):
        print """\t%s;""" % netec_data_instance_name(i)

    print """\tmeta.cksum_compensate;\n}"""

    # tcp
    print """
field_list l4_with_netec_list_tcp {
\tipv4.srcAddr;
\tipv4.dstAddr;
\tmeta.l4_proto;
\tmeta.tcpLength;
\ttcp.srcPort;
\ttcp.dstPort;
\ttcp.seqNo;
\ttcp.ackNo;
\ttcp.dataOffset;
\ttcp.res;
\ttcp.flags;
\ttcp.window;
\ttcp.urgentPtr;
\tsack1.nop1;
\tsack1.sack_l;
\tsack1.sack_r;
\tsack2.sack_l;
\tsack2.sack_r;
\tsack3.sack_l;
\tsack3.sack_r;
\tnetec.index;
\tnetec.type_;\n""",
    for i in range(count):
        print """\t%s;""" % netec_data_instance_name(i)

    print """\n}"""
    print """
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
}"""

def print_xor(count, data_width):

    for i in range(count):
        s = """
// AUTOGEN
register r_xor_%s{
	width : %s;
	instance_count : 32768;
}
blackbox stateful_alu s_xor_%s{
	reg : r_xor_%s;
    condition_lo : meta.flag_finish == 1;
    update_lo_1_predicate : condition_lo; /* the third packet */
	update_lo_1_value : 0;
    update_lo_1_predicate : not condition_lo; /* the first/second packet */
	update_lo_1_value : register_lo ^ %s;

    update_hi_1_value : register_lo ^ %s;
	output_value : alu_hi;
	output_dst : %s;
}
@pragma stage %s
table t_xor_%s{
	actions{a_xor_%s;}
	default_action : a_xor_%s();
    size : 1;
}
action a_xor_%s(){
	s_xor_%s.execute_stateful_alu(netec.index);
}
""" % (i, data_width, i, i, netec_data_instance_name(i), netec_data_instance_name(i), netec_data_instance_name(i), 11-(count-i)/4, i, i, i, i, i)
        print s,
    print """
control xor {\n"""

    for i in range (count):
        s = """\tapply(t_xor_%s);\n""" % (i)
        print s,
    print """
}
""",

def main():
    count = 28
    data_width = 32
    header_length = 6

    print """// AutoGen\n// NetEC data field count: %d\n// data width: %d\n""" % (count, data_width)

    packet_size = count * (data_width / 8) + 6
    print """#define TCP_OPTION_MSS_COMPENSATE 0x0204%04X /* MSS %d */\n""" % (packet_size, packet_size)

    print_header(count, data_width)
    print_checksum(count)
    print_xor(count, data_width)




if __name__ == '__main__':
    main()

