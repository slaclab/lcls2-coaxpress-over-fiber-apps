##############################################################################
## This file is part of 'PGP PCIe APP DEV'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'PGP PCIe APP DEV', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

set_property USER_SLR_ASSIGNMENT SLR2 [get_cells {U_Hsio}]

#### Base Clocks
create_generated_clock -name clk156 [get_pins {U_axilClk/PllGen.U_Pll/CLKOUT0}]
create_generated_clock -name clk25  [get_pins {U_axilClk/PllGen.U_Pll/CLKOUT1}]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets U_axilClk/clkOut[1]]

create_generated_clock -name clk238 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_MMCM.U_238MHz/MmcmGen.U_Mmcm/CLKOUT0}]
create_generated_clock -name clk371 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_MMCM.U_371MHz/MmcmGen.U_Mmcm/CLKOUT0}]

create_generated_clock -name clk119 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_refClkDiv2/O}]
create_generated_clock -name clk186 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_refClkDiv2/O}]

#### GT Out Clocks
create_clock -name timingGtRxOutClk0  -period 8.403 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTY/*/RXOUTCLK}]

create_generated_clock -name timingGtTxOutClk0 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTY/*/TXOUTCLK}]

# create_generated_clock -name timingTxOutClk0 \
    # [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_refClkDiv2/O}]

create_clock -name timingGtRxOutClk1  -period 5.384 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].REAL_PCIE.U_GTY/*/RXOUTCLK}]

create_generated_clock -name timingGtTxOutClk1 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].REAL_PCIE.U_GTY/*/TXOUTCLK}]

# create_generated_clock -name timingTxOutClk1 \
    # [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_refClkDiv2/O}]


#### Cascaded clock muxing - GEN_VEC[0] RX mux
create_generated_clock -name muxRxClk119 \
    -divide_by 1 -add -master_clock clk119 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/O}]

create_generated_clock -name muxTimingGtRxOutClk0 \
    -divide_by 1 -add -master_clock timingGtRxOutClk0 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingGtRxOutClk0 -group muxRxClk119
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/CE*}]

#### Cascaded clock muxing - GEN_VEC[0] TX mux
create_generated_clock -name muxTxClk119 \
    -divide_by 1 -add -master_clock clk119 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/O}]

create_generated_clock -name muxTimingTxOutClk0 \
    -divide_by 1 -add -master_clock clk119 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingTxOutClk0 -group muxTxClk119
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/CE*}]


##### Cascaded clock muxing - GEN_VEC[1] RX mux
create_generated_clock -name muxRxClk186 \
    -divide_by 1 -add -master_clock clk186 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/O}]

create_generated_clock -name muxTimingGtRxOutClk1 \
    -divide_by 1 -add -master_clock timingGtRxOutClk1 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingGtRxOutClk1 -group muxRxClk186
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/CE*}]

##### Cascaded clock muxing - GEN_VEC[1] TX mux
create_generated_clock -name muxTxClk186 \
    -divide_by 1 -add -master_clock clk186 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/O}]

create_generated_clock -name muxTimingTxOutClk1 \
    -divide_by 1 -add -master_clock clk186 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingTxOutClk1 -group muxTxClk186
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/CE*}]


###### Cascaded clock muxing - Final RX mux
create_generated_clock -name casMuxRxClk119 \
    -divide_by 1 -add -master_clock muxRxClk119 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxTimingGtRxOutClk0 \
    -divide_by 1 -add -master_clock muxTimingGtRxOutClk0 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxRxClk186 \
    -divide_by 1 -add -master_clock muxRxClk186 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxTimingGtRxOutClk1 \
    -divide_by 1 -add -master_clock muxTimingGtRxOutClk1 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

set_clock_groups -physically_exclusive \
    -group casMuxRxClk119 \
    -group casMuxTimingGtRxOutClk0 \
    -group casMuxRxClk186 \
    -group casMuxTimingGtRxOutClk1

set_false_path -to [get_pins {*/U_TimingRx/U_RXCLK/CE*}]

###### Cascaded clock muxing - Final TX mux
create_generated_clock -name casMuxTxClk119 \
    -divide_by 1 -add -master_clock muxTxClk119 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTimingTxOutClk0 \
    -divide_by 1 -add -master_clock muxTimingTxOutClk0 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTxClk186 \
    -divide_by 1 -add -master_clock muxTxClk186 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTimingTxOutClk1 \
    -divide_by 1 -add -master_clock muxTimingTxOutClk1 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

set_clock_groups -physically_exclusive \
    -group casMuxTxClk119 \
    -group casMuxTimingTxOutClk0 \
    -group casMuxTxClk186 \
    -group casMuxTimingTxOutClk1

set_false_path -to [get_pins {*/U_TimingRx/U_TXCLK/CE*}]

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks {clk156}] \
    -group [get_clocks -include_generated_clocks {timingGtRxOutClk0}] \
    -group [get_clocks -include_generated_clocks {timingGtRxOutClk1}] \
    -group [get_clocks -include_generated_clocks {timingGtTxOutClk0}] \
    -group [get_clocks -include_generated_clocks {timingGtTxOutClk1}] \
    -group [get_clocks -include_generated_clocks {clk238}] \
    -group [get_clocks -include_generated_clocks {clk371}] \
    -group [get_clocks -include_generated_clocks {dmaClk}]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_axilClk/PllGen.U_Pll/CLKOUT1]] -group [get_clocks -of_objects [get_pins U_axilClk/PllGen.U_Pll/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_TimingRx/GEN_VEC[0].U_refClkDiv2/O}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTY/LOCREF_G.U_TimingGtyCore/inst/gen_gtwizard_gtye4_top.TimingGty_fixedlat_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLKPCS}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_GT/inst/i_CoaXPressOverFiberGtyUsIp_gt/inst/gen_gtwizard_gtye4_top.CoaXPressOverFiberGtyUsIp_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[29].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[*].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]

set_clock_groups -asynchronous -group [get_clocks casMuxRxClk119] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks casMuxRxClk186] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks casMuxTimingGtRxOutClk0] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks casMuxTimingGtRxOutClk1] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[1].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[2].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[0].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]] -group [get_clocks -of_objects [get_pins {U_Hsio/U_CXP/GEN_LANE[3].GEN_CXPOF.U_CXPOF/U_phyClk312/PllGen.U_Pll/CLKOUT0}]]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Mig/GEN_MIG1.U_Mig1/U_MIG/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins U_Core/REAL_PCIE.U_AxiPciePhy/U_AxiPcie/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Mig/GEN_MIG2.U_Mig2/U_MIG/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins U_Core/REAL_PCIE.U_AxiPciePhy/U_AxiPcie/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Mig/GEN_MIG3.U_Mig3/U_MIG/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins U_Core/REAL_PCIE.U_AxiPciePhy/U_AxiPcie/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Mig/U_Mig0/U_MIG/inst/u_ddr4_infrastructure/gen_mmcme4.u_mmcme_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins U_Core/REAL_PCIE.U_AxiPciePhy/U_AxiPcie/inst/pcie4_ip_i/inst/gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]]
