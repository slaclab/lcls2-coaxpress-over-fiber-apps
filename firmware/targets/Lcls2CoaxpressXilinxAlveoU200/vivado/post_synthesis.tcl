##############################################################################
## This file is part of 'Simple-10GbE-RUDP-KCU105-Example'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'Simple-10GbE-RUDP-KCU105-Example', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

##############################
# Get variables and procedures
##############################
source -quiet $::env(RUCKUS_DIR)/vivado_env_var.tcl
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

######################################################
# Bypass the debug chipscope generation via return cmd
# ELSE ... comment out the return to include chipscope
######################################################
return

############################
## Open the synthesis design
############################
open_run synth_1

##############################################################################
##############################################################################
##############################################################################

###############################
## Set the name of the ILA core
###############################
set ilaName u_ila_0

##################
## Create the core
##################
CreateDebugCore ${ilaName}

#######################
## Set the record depth
#######################
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_Hsio/axilClk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_QPLL/pllLock[*]}
ConfigProbe ${ilaName} {U_Hsio/U_QPLL/pllReset[*]}
ConfigProbe ${ilaName} {U_Hsio/U_QPLL/stableRst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/axilReadMaster[araddr][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/axilWriteMaster[awaddr][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/axilWriteMaster[wdata][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/configTimerSize[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilReadSlave][rdata][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilReadSlave][rresp][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilWriteSlave][bresp][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[timer][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/axilReadMaster[arvalid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/axilReadMaster[rready]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilReadSlave][arready]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilReadSlave][rvalid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilWriteSlave][awready]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilWriteSlave][bvalid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/r[axilWriteSlave][wready]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/rxRstSync}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisMaster[tKeep][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisMaster[tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/TX_FIFO/sAxisSlave[tReady]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/rxMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/rxMaster[tData][*]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}

##############################################################################
##############################################################################
##############################################################################

###############################
## Set the name of the ILA core
###############################
set ilaName u_ila_1

##################
## Create the core
##################
CreateDebugCore ${ilaName}

#######################
## Set the record depth
#######################
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txClk[0]}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/cfgTxMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/cfgTxMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txDecodeData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txEncodeData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/cfgTxMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/cfgTxSlave[tReady]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/gearboxReady}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/swTrig}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/trigger}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txDecodeDataK}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txEncodeValid}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txRate}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txStrobe}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txTrig}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/txTrigDrop}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r_reg[heartbeatCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r_reg[txIdleCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r_reg[txTrigCnt][*]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}
