##############################################################################
## This file is part of 'PGP PCIe APP DEV'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'PGP PCIe APP DEV', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

set_property CONFIG_VOLTAGE 1.8                        [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable    [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE           [current_design]
set_property CONFIG_MODE SPIx4                         [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4           [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8          [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES        [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup         [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes       [current_design]

set_property USER_SLR_ASSIGNMENT SLR1 [get_cells {U_Hardware}]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells {U_HbmDmaBuffer}]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_axilClk/MmcmGen.U_Mmcm/CLKOUT0]] -group [get_clocks hbmRefClkP]

#######
# PGP #
#######

create_generated_clock -name pgp3PhyRxClk0 [get_pins {U_Hardware/U_Pgp/GEN_LANE[0].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk1 [get_pins {U_Hardware/U_Pgp/GEN_LANE[1].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk2 [get_pins {U_Hardware/U_Pgp/GEN_LANE[2].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk3 [get_pins {U_Hardware/U_Pgp/GEN_LANE[3].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk4 [get_pins {U_Hardware/U_Pgp/GEN_LANE[4].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk5 [get_pins {U_Hardware/U_Pgp/GEN_LANE[5].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk6 [get_pins {U_Hardware/U_Pgp/GEN_LANE[6].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]
create_generated_clock -name pgp3PhyRxClk7 [get_pins {U_Hardware/U_Pgp/GEN_LANE[7].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_generated_clock -name pgp3PhyTxClk0 [get_pins {U_Hardware/U_Pgp/GEN_LANE[0].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk1 [get_pins {U_Hardware/U_Pgp/GEN_LANE[1].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk2 [get_pins {U_Hardware/U_Pgp/GEN_LANE[2].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk3 [get_pins {U_Hardware/U_Pgp/GEN_LANE[3].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk4 [get_pins {U_Hardware/U_Pgp/GEN_LANE[4].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk5 [get_pins {U_Hardware/U_Pgp/GEN_LANE[5].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk6 [get_pins {U_Hardware/U_Pgp/GEN_LANE[6].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name pgp3PhyTxClk7 [get_pins {U_Hardware/U_Pgp/GEN_LANE[7].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

create_generated_clock -name pgp3PhyTxPcsClk0 [get_pins {U_Hardware/U_Pgp/GEN_LANE[0].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk1 [get_pins {U_Hardware/U_Pgp/GEN_LANE[1].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk2 [get_pins {U_Hardware/U_Pgp/GEN_LANE[2].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk3 [get_pins {U_Hardware/U_Pgp/GEN_LANE[3].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk4 [get_pins {U_Hardware/U_Pgp/GEN_LANE[4].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk5 [get_pins {U_Hardware/U_Pgp/GEN_LANE[5].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk6 [get_pins {U_Hardware/U_Pgp/GEN_LANE[6].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]
create_generated_clock -name pgp3PhyTxPcsClk7 [get_pins {U_Hardware/U_Pgp/GEN_LANE[7].U_Lane/U_Pgp/U_Pgp3GtyUsIpWrapper_1/GEN_10G.U_Pgp3GtyUsIp/inst/gen_gtwizard_gtye4_top.Pgp3GtyUsIp10G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[0].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]

######################
# Timing Constraints #
######################

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk0}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk0}] -group [get_clocks -include_generated_clocks {qsfp0RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk1}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk1}] -group [get_clocks -include_generated_clocks {qsfp0RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk2}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk2}] -group [get_clocks -include_generated_clocks {qsfp0RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk3}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk3}] -group [get_clocks -include_generated_clocks {qsfp0RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk4}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk4}] -group [get_clocks -include_generated_clocks {qsfp1RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk5}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk5}] -group [get_clocks -include_generated_clocks {qsfp1RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk6}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk6}] -group [get_clocks -include_generated_clocks {qsfp1RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyRxClk7}] -group [get_clocks -include_generated_clocks {pgp3PhyTxClk7}] -group [get_clocks -include_generated_clocks {qsfp1RefClkP1}] -group [get_clocks -include_generated_clocks {pciRefClkP}] -group [get_clocks -include_generated_clocks {userClkP}]

set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk0] -group [get_clocks pgp3PhyTxPcsClk0]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk1] -group [get_clocks pgp3PhyTxPcsClk1]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk2] -group [get_clocks pgp3PhyTxPcsClk2]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk3] -group [get_clocks pgp3PhyTxPcsClk3]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk4] -group [get_clocks pgp3PhyTxPcsClk4]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk5] -group [get_clocks pgp3PhyTxPcsClk5]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk6] -group [get_clocks pgp3PhyTxPcsClk6]
set_clock_groups -asynchronous  -group [get_clocks pgp3PhyTxClk7] -group [get_clocks pgp3PhyTxPcsClk7]

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk0}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk1}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk2}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk3}] -group [get_clocks -include_generated_clocks {dmaClk}]

set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk4}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk5}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk6}] -group [get_clocks -include_generated_clocks {dmaClk}]
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks {pgp3PhyTxClk7}] -group [get_clocks -include_generated_clocks {dmaClk}]
