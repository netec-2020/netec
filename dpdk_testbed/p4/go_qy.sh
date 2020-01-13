#!/bin/bash

bash ./fast_build.sh pkgsrc/qy/payload_test.p4

pkill run_p4_tests.sh
./run_p4_tests.sh -p payload_test -t pkgsrc/qy/&

pkill run_sw
./run_switchd.sh -p payload_test
