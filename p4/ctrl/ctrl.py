# Copyright 2013-present Barefoot Networks, Inc.
# # Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Simple PTF test for basic_switching.p4
"""
import logging
import os
import pd_base_tests
import pltfm_pm_rpc
import pal_rpc
import random
import sys
import time
import unittest

from netec.p4_pd_rpc.ttypes import *
from pltfm_pm_rpc.ttypes import *
from pal_rpc.ttypes import *
from ptf import config
from ptf.testutils import *
from ptf.thriftutils import *
from res_pd_rpc.ttypes import *

this_dir = os.path.dirname(os.path.abspath(__file__))

# Front Panel Ports
#   List of front panel ports to use. Each front panel port has 4 channels.
#   Port 1 is broken to 1/0, 1/1, 1/2, 1/3. Test uses 2 ports.
#
#   ex: ["1/0", "1/1"]
#
fp_ports = ["1/0","2/0","3/0", "4/0"]
def portToPipe(port):
    return port >> 7

def portToPipeLocalId(port):
    return port & 0x7F

def portToBitIdx(port):
    pipe = portToPipe(port)
    index = portToPipeLocalId(port)
    return 72 * pipe + index

def BitIdxToPort(index):
    pipe = index / 72
    local_port = index % 72
    return (pipe << 7) | local_port

def set_port_map(indicies):
    bit_map = [0] * ((288+7)/8)
    for i in indicies:
        index = portToBitIdx(i)
        bit_map[index/8] = (bit_map[index/8] | (1 << (index%8))) & 0xFF
    return bytes_to_string(bit_map)

def set_lag_map(indicies):
    bit_map = [0] * ((256+7)/8)
    for i in indicies:
        bit_map[i/8] = (bit_map[i/8] | (1 << (i%8))) & 0xFF
    return bytes_to_string(bit_map)

class L2Test(pd_base_tests.ThriftInterfaceDataPlane):
    def __init__(self):
        pd_base_tests.ThriftInterfaceDataPlane.__init__(self,
                                                        ["netec"])

    # The setUp() method is used to prepare the test fixture. Typically
    # you would use it to establich connection to the Thrift server.
    #
    # You can also put the initial device configuration there. However,
    # if during this process an error is encountered, it will be considered
    # as a test error (meaning the test is incorrect),
    # rather than a test failure
    def setUp(self):
        # initialize the connection
        pd_base_tests.ThriftInterfaceDataPlane.setUp(self)
        self.sess_hdl = self.conn_mgr.client_init()
        self.dev_tgt = DevTarget_t(0, hex_to_i16(0xFFFF))
        self.devPorts = []

        self.platform_type = "mavericks"
        board_type = self.pltfm_pm.pltfm_pm_board_type_get()
        if re.search("0x0234|0x1234|0x4234|0x5234", hex(board_type)):
            self.platform_type = "mavericks"
        elif re.search("0x2234|0x3234", hex(board_type)):
            self.platform_type = "montara"

        # get the device ports from front panel ports
        try:
            for fpPort in fp_ports:
                port, chnl = fpPort.split("/")
                devPort = \
                    self.pal.pal_port_front_panel_port_to_dev_port_get(0,
                                                                    int(port),
                                                                    int(chnl))
                self.devPorts.append(devPort)

            if test_param_get('setup') == True or (test_param_get('setup') != True
                and test_param_get('cleanup') != True):

                # add and enable the platform ports
                for i in self.devPorts:
                    self.pal.pal_port_add(0, i,
                                        pal_port_speed_t.BF_SPEED_40G,
                                        pal_fec_type_t.BF_FEC_TYP_NONE)
                    self.pal.pal_port_enable(0, i)
                self.conn_mgr.complete_operations(self.sess_hdl)
        except Exception as e:
            pass


        self.client.t_l2_forward_table_add_with_a_l2_forward(self.sess_hdl, self.dev_tgt,
            netec_t_l2_forward_match_spec_t(ethernet1_dstAddr1=0x68,ethernet2_dstAddr2=macAddr_to_string("91:d0:61:b4:c4")),
            netec_a_l2_forward_action_spec_t(action_port=136)
            )

        self.client.t_l2_forward_table_add_with_a_l2_forward(self.sess_hdl, self.dev_tgt,
            netec_t_l2_forward_match_spec_t(ethernet1_dstAddr1=0x68,ethernet2_dstAddr2=macAddr_to_string("91:d0:61:12:3a")),
            netec_a_l2_forward_action_spec_t(action_port=128)
            )

    
        self.client.t_l2_forward_table_add_with_a_l2_forward(self.sess_hdl, self.dev_tgt,
            netec_t_l2_forward_match_spec_t(ethernet1_dstAddr1=0x68,ethernet2_dstAddr2=macAddr_to_string("91:d0:61:12:5a")),
            netec_a_l2_forward_action_spec_t(action_port=144)
            )    
            

        self.client.t_l2_forward_table_add_with_a_l2_forward(self.sess_hdl, self.dev_tgt,
            netec_t_l2_forward_match_spec_t(ethernet1_dstAddr1=0x68,ethernet2_dstAddr2=macAddr_to_string("91:d0:61:12:4b")),
            netec_a_l2_forward_action_spec_t(action_port=152)
            )

        # t_modify_ip table
        self.client.t_modify_ip_table_add_with_a_modify_ip(self.sess_hdl, self.dev_tgt,
            netec_t_modify_ip_match_spec_t(eg_intr_md_egress_port=136),
            netec_a_modify_ip_action_spec_t(
                action_dip=ipv4Addr_to_i32("10.0.0.3"),
                action_sip=ipv4Addr_to_i32("10.0.0.10"),
                action_smac=macAddr_to_string("0b:22:33:44:55:66"),
                action_mac1=0x68,
                action_mac2=macAddr_to_string("91:d0:61:b4:c4")
            )
        )
        print self.client.t_modify_ip_table_add_with_a_modify_ip(self.sess_hdl, self.dev_tgt,
            netec_t_modify_ip_match_spec_t(eg_intr_md_egress_port=128),
            netec_a_modify_ip_action_spec_t(
                action_dip=ipv4Addr_to_i32("10.0.0.4"),
                action_sip=ipv4Addr_to_i32("10.0.0.10"),
                action_smac=macAddr_to_string("0b:22:33:44:55:66"),
                action_mac1=0x68,
                action_mac2=macAddr_to_string("91:d0:61:12:3a")
            )
        )
        print self.client.t_modify_ip_table_add_with_a_modify_ip(self.sess_hdl, self.dev_tgt,
            netec_t_modify_ip_match_spec_t(eg_intr_md_egress_port=144),
            netec_a_modify_ip_action_spec_t(
                action_dip=ipv4Addr_to_i32("10.0.0.5"),
                action_sip=ipv4Addr_to_i32("10.0.0.10"),
                action_smac=macAddr_to_string("0b:22:33:44:55:66"),
                action_mac1=0x68,
                action_mac2=macAddr_to_string("91:d0:61:12:5a")
            )
        )
        print self.client.t_modify_ip_table_add_with_a_modify_ip(self.sess_hdl, self.dev_tgt,
            netec_t_modify_ip_match_spec_t(eg_intr_md_egress_port=152),
            netec_a_modify_ip_action_spec_t(
                action_dip=ipv4Addr_to_i32("10.0.0.6"),
                action_sip=ipv4Addr_to_i32("10.0.0.10"),
                action_smac=macAddr_to_string("0b:22:33:44:55:66"),
                action_mac1=0x68,
                action_mac2=macAddr_to_string("91:d0:61:12:4b")
            )
        )
        # t_dn_rs_seq table
        self.client.t_dn_rs_seq_table_add_with_a_dn_rs_seq(self.sess_hdl, self.dev_tgt,
            netec_t_dn_rs_seq_match_spec_t(meta_dn_port_for_seq=128),
            netec_a_dn_rs_seq_action_spec_t(action_dn_index=0)
        )
        self.client.t_dn_rs_seq_table_add_with_a_dn_rs_seq(self.sess_hdl, self.dev_tgt,
            netec_t_dn_rs_seq_match_spec_t(meta_dn_port_for_seq=144),
            netec_a_dn_rs_seq_action_spec_t(action_dn_index=1)
        )
        self.client.t_dn_rs_seq_table_add_with_a_dn_rs_seq(self.sess_hdl, self.dev_tgt,
            netec_t_dn_rs_seq_match_spec_t(meta_dn_port_for_seq=152),
            netec_a_dn_rs_seq_action_spec_t(action_dn_index=2)
        )

        # self.client.t_get_coeff_table_add_with_a_get_coeff(self.sess_hdl,self.dev_tgt,
        #                                 netec_t_get_coeff_match_spec_t(ipv4_srcAddr=ipv4Addr_to_i32("10.0.0.4")),
        #                                 netec_a_get_coeff_action_spec_t(action_coeff=237))

        # self.client.t_get_coeff_table_add_with_a_get_coeff(self.sess_hdl,self.dev_tgt,
        #                                 netec_t_get_coeff_match_spec_t(ipv4_srcAddr=ipv4Addr_to_i32("10.0.0.5")),
        #                                 netec_a_get_coeff_action_spec_t(action_coeff=33889))
        # self.client.t_get_coeff_table_add_with_a_get_coeff(self.sess_hdl,self.dev_tgt,
        #                                 netec_t_get_coeff_match_spec_t(ipv4_srcAddr=ipv4Addr_to_i32("10.0.0.6")),
        #                                 netec_a_get_coeff_action_spec_t(action_coeff=49594))


        # log table
        # count = 8
        # for i in range(count):
        #     getattr(self.client,"t_log_add_%s_table_add_with_a_log_mod_%s" %(i,i))(self.sess_hdl,self.dev_tgt,eval("netec_t_log_add_%s_match_spec_t" % (i))(netec_type_=2))


        print "Configuring Mcast"

        mc_sess_hdl = self.mc.mc_create_session()
        mgrp_hdl = self.mc.mc_mgrp_create(mc_sess_hdl, 0, 666)
        l1_hdl1 = self.mc.mc_node_create(mc_sess_hdl, 0, 1, set_port_map([128]), set_lag_map([]))
        l1_hdl2 = self.mc.mc_node_create(mc_sess_hdl, 0, 2, set_port_map([136]), set_lag_map([]))
        l1_hdl3 = self.mc.mc_node_create(mc_sess_hdl, 0, 3, set_port_map([144]), set_lag_map([]))
        l1_hdl4 = self.mc.mc_node_create(mc_sess_hdl, 0, 4, set_port_map([152]), set_lag_map([]))

        self.mc.mc_associate_node(mc_sess_hdl, 0, mgrp_hdl, l1_hdl1, 0, 0)
        # self.mc.mc_associate_node(mc_sess_hdl, 0, mgrp_hdl, l1_hdl2, 0, 0)
        self.mc.mc_associate_node(mc_sess_hdl, 0, mgrp_hdl, l1_hdl3, 0, 0)
        self.mc.mc_associate_node(mc_sess_hdl, 0, mgrp_hdl, l1_hdl4, 0, 0)
        self.mc.mc_complete_operations(mc_sess_hdl)

    	print "Finish Configuring Mcast"



    def runTest(self):
		#self.client.bypass1_set_default_action_bypass1_action(self.sess_hdl,self.dev_tgt);
		#self.client.bypass2_set_default_action_bypass2_action(self.sess_hdl,self.dev_tgt);
        hw_sync_flag = netec_register_flags_t(read_hw_sync = True)
        while(True):
            a = int(input())
            # print self.client.register_read_r_finish(self.sess_hdl,self.dev_tgt, a,hw_sync_flag)
            print self.client.register_read_r_test(self.sess_hdl,self.dev_tgt, 0, hw_sync_flag)

            # pass
        # ilog table
        # while(True):
        #     index = int(input("index: "))
        #     print self.client.register_read_r_ilog_table_1(self.sess_hdl,self.dev_tgt,index,hw_sync_flag);

    # Use this method to return the DUT to the initial state by cleaning
    # all the configuration and clearing up the connection
    def tearDown(self):
        try:
            print("Clearing table entries")
            for table in self.entries.keys():
                delete_func = "self.client." + table + "_table_delete"
                for entry in self.entries[table]:
                    exec delete_func + "(self.sess_hdl, self.dev, entry)"
        except:
            print("Error while cleaning up. ")
            print("You might need to restart the driver")
        finally:
            self.conn_mgr.complete_operations(self.sess_hdl)
            self.conn_mgr.client_cleanup(self.sess_hdl)
            print("Closed Session %d" % self.sess_hdl)
            pd_base_tests.ThriftInterfaceDataPlane.tearDown(self)
