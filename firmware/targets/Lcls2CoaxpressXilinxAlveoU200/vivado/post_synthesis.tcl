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

ConfigProbe ${ilaName} {U_Hsio/U_QPLL/GtyUltraScaleQuadPll_Inst/qPllLock[*]}
ConfigProbe ${ilaName} {U_Hsio/U_QPLL/GtyUltraScaleQuadPll_Inst/qPllReset[*]}
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

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisMaster[tKeep][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisRst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisMaster[tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fifo/sAxisSlave[tReady]}

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
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/clk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/phyRst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/txLinkUp}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/txReset}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/txRst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/rxLinkUp}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/rxReset}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/rxRst}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/cfgMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/cfgMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigData][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigData][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigData][2][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigDataK][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigDataK][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txTrigDataK][2][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/r[txDataK][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/txTrig[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/cfgMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_Fsm/cfgSlave[tReady]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/r[txData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/r[xgmiiTxc][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/r[xgmiiTxd][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/txData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/txDataK[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeTx/rst}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[rxData][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[rxData][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[rxDataK][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[rxDataK][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/xgmiiRxc[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/xgmiiRxd[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_BridgeRx/r[armed]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}
