#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

T_DIR=tests/lbh
T_PLAN=lbh.product.list

# Reporting dir: start fresh
R_DIR=${T_DIR}/report
rm -rf ${R_DIR} > /dev/null 2>&1
mkdir -p ${R_DIR}

rm -f ${T_DIR}/${T_PLAN}.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

./run.sh -Dlog_level.jmeter=DEBUG \
	-n -t ${T_DIR}/${T_PLAN}.jmx -l ${T_DIR}/${T_PLAN}.jtl -j ${T_DIR}/jmeter.log \
	-e -o ${R_DIR}

echo "==== jmeter.log ===="
cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
head -20 ${T_DIR}/${T_PLAN}.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"
