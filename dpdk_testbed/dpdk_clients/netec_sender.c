/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2010-2015 Intel Corporation
 */

#include <stdint.h>
#include <inttypes.h>
#include <rte_eal.h>
#include <rte_ethdev.h>
#include <rte_cycles.h>
#include <rte_lcore.h>
#include <rte_mbuf.h>
#include <rte_ip.h>
#include <rte_udp.h>
#include <rte_udp.h>
#include <rte_timer.h>
#define TIMER_RESOLUTION_CYCLES 2399987461ULL
#define RX_RING_SIZE 1024
#define TX_RING_SIZE 1024

#define NUM_MBUFS 8191
#define MBUF_CACHE_SIZE 250
#define BURST_SIZE 32

static const struct rte_eth_conf port_conf_default = {
	.rxmode = {
		.max_rx_pkt_len = ETHER_MAX_LEN,
	},
};

/* basicfwd.c: Basic DPDK skeleton forwarding example. */

/*
 * Initializes a given port using global settings and with the RX buffers
 * coming from the mbuf_pool passed as a parameter.
 */
static inline int
port_init(uint16_t port, struct rte_mempool *mbuf_pool)
{
	struct rte_eth_conf port_conf = port_conf_default;
	const uint16_t rx_rings = 1, tx_rings = 1;
	uint16_t nb_rxd = RX_RING_SIZE;
	uint16_t nb_txd = TX_RING_SIZE;
	int retval;
	uint16_t q;
	struct rte_eth_dev_info dev_info;
	struct rte_eth_txconf txconf;

	if (!rte_eth_dev_is_valid_port(port))
		return -1;

	rte_eth_dev_info_get(port, &dev_info);
	if (dev_info.tx_offload_capa & DEV_TX_OFFLOAD_MBUF_FAST_FREE)
		port_conf.txmode.offloads |=
			DEV_TX_OFFLOAD_MBUF_FAST_FREE;

	/* Configure the Ethernet device. */
	retval = rte_eth_dev_configure(port, rx_rings, tx_rings, &port_conf);
	if (retval != 0)
		return retval;

	retval = rte_eth_dev_adjust_nb_rx_tx_desc(port, &nb_rxd, &nb_txd);
	if (retval != 0)
		return retval;

	/* Allocate and set up 1 RX queue per Ethernet port. */
	for (q = 0; q < rx_rings; q++) {
		retval = rte_eth_rx_queue_setup(port, q, nb_rxd,
				rte_eth_dev_socket_id(port), NULL, mbuf_pool);
		if (retval < 0)
			return retval;
	}

	txconf = dev_info.default_txconf;
	txconf.offloads = port_conf.txmode.offloads;
	/* Allocate and set up 1 TX queue per Ethernet port. */
	for (q = 0; q < tx_rings; q++) {
		retval = rte_eth_tx_queue_setup(port, q, nb_txd,
				rte_eth_dev_socket_id(port), &txconf);
		if (retval < 0)
			return retval;
	}

	/* Start the Ethernet port. */
	retval = rte_eth_dev_start(port);
	if (retval < 0)
		return retval;

	/* Display the port MAC address. */
	struct ether_addr addr;
	rte_eth_macaddr_get(port, &addr);
	printf("Port %u MAC: %02" PRIx8 " %02" PRIx8 " %02" PRIx8
			   " %02" PRIx8 " %02" PRIx8 " %02" PRIx8 "\n",
			port,
			addr.addr_bytes[0], addr.addr_bytes[1],
			addr.addr_bytes[2], addr.addr_bytes[3],
			addr.addr_bytes[4], addr.addr_bytes[5]);

	/* Enable RX in promiscuous mode for the Ethernet device. */
	rte_eth_promiscuous_enable(port);

	return 0;
}
struct ipv4_5tuple {
    uint32_t ip_dst;
    uint32_t ip_src;
    uint16_t port_dst;
    uint16_t port_src;
    uint8_t  proto;
};
uint32_t h = 0;
uint32_t w = 32;
struct rte_mempool *mbuf_pool;
struct rte_mbuf* build_packet(struct ipv4_5tuple* ip_5tuple,uint32_t ii) {
    struct rte_mbuf* probing_packet;
    struct ether_hdr *eth_hdr;
    struct ipv4_hdr *iph;
    struct udp_hdr *udp_h;
    char* payload;
    probing_packet = rte_pktmbuf_alloc(mbuf_pool);
    if (!probing_packet) {
        printf("ecmp: probing_packet alloc failed!\n");
    }
    eth_hdr = (struct ether_hdr *) rte_pktmbuf_append(probing_packet, sizeof(struct ether_hdr));
    iph = (struct ipv4_hdr *)rte_pktmbuf_append(probing_packet, sizeof(struct ipv4_hdr));
    udp_h = (struct udp_hdr *) rte_pktmbuf_append(probing_packet,sizeof(struct udp_hdr));
    //a packet has minimum size 64B
    payload = (char*) rte_pktmbuf_append(probing_packet,1400);
    eth_hdr->ether_type =  rte_cpu_to_be_16(ETHER_TYPE_IPv4);
    //eth_hdr->ether_type =  rte_cpu_to_be_16(ETHER_TYPE_ARP);
    //eth_hdr->ether_type =  0;
    //printf("%x\n",eth_hdr->ether_type);
    //ether_addr_copy(&interface_MAC, &eth_hdr->d_addr);
    struct ether_addr addr;
    rte_eth_macaddr_get(0, &addr);
    ether_addr_copy(&addr, &eth_hdr->s_addr);
    /*printf("Port %u MAC: %02" PRIx8 " %02" PRIx8 " %02" PRIx8
                           " %02" PRIx8 " %02" PRIx8 " %02" PRIx8 "\n",
                       1,
                        addr.addr_bytes[0], addr.addr_bytes[1],
                        addr.addr_bytes[2], addr.addr_bytes[3],
                        addr.addr_bytes[4], addr.addr_bytes[5]);
    */

    /*
    ether_addr_copy(&eth_hdr->d_addr, &addr);
    printf("Port %u MAC: %02" PRIx8 " %02" PRIx8 " %02" PRIx8
                           " %02" PRIx8 " %02" PRIx8 " %02" PRIx8 "\n",
                        1,
                        addr.addr_bytes[0], addr.addr_bytes[1],
                        addr.addr_bytes[2], addr.addr_bytes[3],
                        addr.addr_bytes[4], addr.addr_bytes[5]);
    */	
    memset((char *)iph, 0, sizeof(struct ipv4_hdr));
    //static uint32_t ip = 0;
    //iph->dst_addr=rte_cpu_to_be_32(probing_ip);
    iph->version_ihl = (4 << 4) | 5;
    iph->total_length = rte_cpu_to_be_16(52);
    iph->packet_id= 0xd84c;/* NO USE */
    iph->time_to_live=4;
    iph->next_proto_id = 0x6;
    //iph->total_length= rte_cpu_to_be_16(sizeof(struct ipv4_hdr));
    //printf("%x\n",ck1);
    //printf("%x\n",ck2);

    if (ip_5tuple == NULL) {
        iph->src_addr=rte_cpu_to_be_32(0);
        udp_h->src_port = rte_cpu_to_be_16(0);
        udp_h->dst_port = rte_cpu_to_be_16(12345);
        *((uint32_t*)payload) = ii;
    }
    else {
        iph->src_addr=rte_cpu_to_be_32(ip_5tuple->ip_src);
        udp_h->src_port = rte_cpu_to_be_16(ip_5tuple->port_src);
        udp_h->dst_port = rte_cpu_to_be_16(ip_5tuple->port_dst);
        *((struct ipv4_5tuple**)(payload+4)) = ip_5tuple;
    }

    iph->hdr_checksum = 0;
    uint16_t ck1 = rte_ipv4_cksum(iph);  
    //uint16_t ck2 = ipv4_hdr_cksum(iph);
    iph->hdr_checksum = ck1;

    //dump_ip_hdr(iph);

    //printf("debug: ip_5tuple %lx\n", ip_5tuple);
    //printf("debug: test bpp %x\n", *((uint32_t*)(payload+4)));
    //printf("debug: payload %lx\n", *((struct ipv4_5tuple**)(payload+4)));

    /*
    udp_h->src_port = 10000;
    udp_h->dst_port = 10001;
    udp_h->dgram_len = 26;
    udp_h->dgram_cksum = 0;
    rte_ipv4_udpudp_cksum(iph,udp_h);
    rte_pktmbuf_dump(stdout,probing_packet,100);
    */
    return probing_packet;
}
static unsigned long long tx_bytes = 0;
static unsigned long long last_tx_bytes = 0;
static struct rte_timer manager_timer;
manager_timer_cb(__attribute__((unused)) struct rte_timer *tim,
         __attribute__((unused)) void *arg)
{
	//printf("%llu\n",(last_tx_bytes - tx_bytes)*8  );
	printf("%llu\n",(tx_bytes - last_tx_bytes)*8/ (1024*1024*1024));
	last_tx_bytes = tx_bytes;
}

/*
 * The lcore main. This is the main thread that does the work, reading from
 * an input port and writing to an output port.
 */
static __attribute__((noreturn)) void
lcore_main(void)
{
	rte_timer_subsystem_init();
	rte_timer_init(&manager_timer);
	rte_timer_reset(
        &manager_timer, rte_get_timer_hz(), PERIODICAL,
        rte_lcore_id(), manager_timer_cb, NULL
    );

	uint16_t port;

	/*
	 * Check that the port is on the same NUMA node as the polling thread
	 * for best performance.
	 */
	RTE_ETH_FOREACH_DEV(port)
		printf("%d\n", port);


	printf("\nCore %u forwarding packets. [Ctrl+C to quit]\n",
			rte_lcore_id());

	/* Run until the application is quit or killed. */
	int first = 1;
	for (;;) {
			uint64_t prev_tsc = 0, cur_tsc , diff_tsc;
        cur_tsc = rte_rdtsc();
        diff_tsc = cur_tsc - prev_tsc;
        if (diff_tsc > TIMER_RESOLUTION_CYCLES/100) {
            rte_timer_manage();
            prev_tsc = cur_tsc;
        }
			port = 0;
			/* Get burst of RX packets, from first port of pair. */
			struct rte_mbuf *bufs[BURST_SIZE];
			const uint16_t nb_rx = rte_eth_rx_burst(port, 0,
					bufs, BURST_SIZE);
			
			uint32_t i;
			uint32_t final_ack = 0;
			for (i = 0;i < nb_rx;i++){
				struct rte_mbuf* mbuf = bufs[i];
				struct ether_hdr* eth_h = (struct ether_hdr*)rte_pktmbuf_mtod(mbuf, struct ether_hdr *);
				struct ipv4_hdr *ip_hdr = (struct ipv4_hdr*)((char*)eth_h + sizeof(struct ether_hdr));
				struct udp_hdr *udph = (struct udp_hdr*)((char*)ip_hdr + sizeof(struct ipv4_hdr));
				char* payload = (char*)ip_hdr
						+ sizeof(struct ipv4_hdr)
						+ sizeof(struct udp_hdr);

    			uint32_t ack = *((uint32_t*)payload);
				//printf("%d\n",ack);
				if(udph->src_port == 1234){
					final_ack = ack;
				}
				rte_pktmbuf_free(bufs[i]);
				
			}
			if(first){
				first = 0;
				final_ack = w;
			}
			//printf("%d, %d\n",h,  final_ack);
			
			//printf("%d, %d\n",h,  final_ack);	
			if(h < final_ack){
				
				struct rte_mbuf *bufss[final_ack - h];

				for(i = 0;i < final_ack - h;i++){
					bufss[i] = build_packet(NULL,h+i);
					tx_bytes += bufss[i]->data_len;
				}
				/* Send burst of TX packets, to second port of pair. */
				const uint16_t nb_tx = rte_eth_tx_burst(port, 0,
						bufss, final_ack - h);
				h += nb_tx;		
				
					
				if (unlikely(nb_tx < final_ack - h)) {
					uint16_t buf;
					for (buf = nb_tx; buf < final_ack - h; buf++)
						rte_pktmbuf_free(bufss[buf]);
				}		
			}
		

			
	}
}

/*
 * The main function, which does initialization and calls the per-lcore
 * functions.
 */
int
main(int argc, char *argv[])
{
	
	unsigned nb_ports;
	uint16_t portid;

	/* Initialize the Environment Abstraction Layer (EAL). */
	int ret = rte_eal_init(argc, argv);
	if (ret < 0)
		rte_exit(EXIT_FAILURE, "Error with EAL initialization\n");

	argc -= ret;
	argv += ret;

	/* Check that there is an even number of ports to send/receive on. */
	nb_ports = rte_eth_dev_count_avail();

	/* Creates a new mempool in memory to hold the mbufs. */
	mbuf_pool = rte_pktmbuf_pool_create("MBUF_POOL", NUM_MBUFS * 20,
		MBUF_CACHE_SIZE, 0, RTE_MBUF_DEFAULT_BUF_SIZE, rte_socket_id());

	if (mbuf_pool == NULL)
		rte_exit(EXIT_FAILURE, "Cannot create mbuf pool\n");

	/* Initialize all ports. */
	RTE_ETH_FOREACH_DEV(portid)
		if (port_init(portid, mbuf_pool) != 0)
			rte_exit(EXIT_FAILURE, "Cannot init port %"PRIu16 "\n",
					portid);

	if (rte_lcore_count() > 1)
		printf("\nWARNING: Too many lcores enabled. Only 1 used.\n");

	/* Call lcore_main on the master core only. */
	lcore_main();

	return 0;
}
