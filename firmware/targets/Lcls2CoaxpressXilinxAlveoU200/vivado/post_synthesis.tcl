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
set_property C_DATA_DEPTH 8192 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxClk}

#######################
## Set the debug Probes
#######################

ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/xgmiiRxc[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/xgmiiRxd[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxDataK][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxData][1][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxDataK][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[rxData][0][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_Bridge/U_Rx/r[errDet]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[dbgCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/GEN_LANE[0].U_Lane/r[errDet]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/numOfLane[*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[lane][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[pipeMaster][tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[pipeMaster][tUser][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[pipeMaster][tKeep][*]} 0 15
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[pipeMaster][tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[pipeMaster][tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/pipeSlave[tReady]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[0][tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[0][tKeep][*]} 0 15
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[1][tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[1][tKeep][*]} 0 15
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[2][tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[2][tKeep][*]} 0 15
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[3][tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[3][tKeep][*]} 0 15
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[*][tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxMasters[*][tLast]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/r[rxSlaves][*][tReady]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Mux/rxFsmRst}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/rxMaster[tData][*]} 0 127
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/rxMaster[tKeep][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/rxMaster[tValid]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/rxSlave[tReady]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[hdrCnt][*]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[hdr][pixelF][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[hdr][dsizeL][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[hdr][xSize][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[hdr][ySize][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[state][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[wrd][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dCnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[yCnt][*]}

ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dbg][errDet]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dbg][wrd][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dbg][cnt][*]}
ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dbg][maker][*]}

# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][0][tData][*]} 0 127
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][0][tKeep][*]} 0 15
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][0][tLast]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][0][tValid]}

# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][1][tData][*]} 0 127
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][1][tKeep][*]} 0 15
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][1][tLast]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/r[dataMasters][1][tValid]}

# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/dataMaster[tData][*]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/dataMaster[tKeep][*]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/dataMaster[tLast]}
# ConfigProbe ${ilaName} {U_Hsio/U_CXP/U_Core/U_Rx/U_Fsm/dataMaster[tValid]}

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}
