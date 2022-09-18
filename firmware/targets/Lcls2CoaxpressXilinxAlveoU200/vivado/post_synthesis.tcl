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
# return

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
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/cfgRxMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Config/cfgRxMaster[tValid]}


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
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/clk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/cfgMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/cfgMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/r[txData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/r[txDataK][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/r[txTrigCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/txTrig[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/cfgMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/cfgSlave[tReady]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/r[forceIdle]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/txRst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_HsFsm/r[txTrigDrop]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/cfgMaster[tData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/cfgMaster[tUser][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[heartbeatCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txTrigData][5][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txIdleCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txTrigCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/cfgMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/cfgSlave[tReady]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[heartbeat]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txDataK]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txIdle]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txStrobe]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txTrig]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/r[txTrigDrop]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/txRate}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Tx/U_LsFsm/txTrig}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[cnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[txHsData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[txLsData][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txLsLaneEn[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[txLsDataK]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[xgmiiTxc][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[xgmiiTxd][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txHsData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txHsDataK[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txLsData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txLsDataK}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[txHsEnable]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[txLsRate]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/r[update]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/rst}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txHsEnable}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txLsRate}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/GEN_TX.U_Tx/txLsValid}

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
set ilaName u_ila_2

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
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/clk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxData][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxData][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxDataK][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxDataK][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/xgmiiRxc[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/xgmiiRxd[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[armed]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/rst}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[ackCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[dcnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[dsize][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/rxData[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/rxDataK[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[cfgMaster][tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[cfgMaster][tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[dataMaster][tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[dataMaster][tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/rxLinkUp}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/rxRst}

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
set ilaName u_ila_3

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
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/phyClk156}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/xgmiiTxd[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/xgmiiTxc[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/txReset}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/gt_reset_tx_done_out_0}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_GT/stat_tx*}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/xgmiiRxd[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/xgmiiRxc[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/rxReset}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/gt_reset_rx_done_out_0}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_GT/stat_rx_error_0[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_GT/stat_fec*}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_GT/stat_rx*}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/rxPhyRst}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/gtRxReset}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}