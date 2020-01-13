
Some parts that contain proprietary information are needed to show NetEC's *feasibility* on real hardwares. So we leave it here for revision purposes.



# Repo Structure

Files:

p4/generate_gf.py: script to generate gf lookup tables

p4/gf.p4: generated by the above script

p4/generate_netec.py : script to generate decoding buffer programs and EBSN control module

p4/netec.p4: generated by the above script

p4/main_netec.p4: main file of NetEC Data Plane; includes above two p4 files; implements one-to-many TCP proxy

p4/includes/: necessary headers and parsers.

p4/ctrl/: control APIs (proprietary, to be removed)

hadoop/: customized HDFS-EC policies.

dpdk_testbed/dpdk_clients: DPDK programs running NetEC simple version

dpdk_testbed/p4/: p4 program with simple EBSN mechanism.


# TODO
We are currently working on a simulator version (P4 Bmv2). 

Simulator version can be run directly on Linux to show feasibility.
