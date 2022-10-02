-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Lcls2 Coaxpress Over Fiber XilinxAlveoU200
-------------------------------------------------------------------------------
-- This file is part of 'PGP PCIe APP DEV'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'PGP PCIe APP DEV', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiStreamPkg.all;
use surf.SsiPkg.all;

library lcls2_pgp_fw_lib;

library axi_pcie_core;
use axi_pcie_core.AxiPciePkg.all;
use axi_pcie_core.MigPkg.all;

library unisim;
use unisim.vcomponents.all;

entity Lcls2CoaxpressOverFiberXilinxAlveoU200 is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      ---------------------
      --  Application Ports
      ---------------------
      -- QSFP[0] Ports
      qsfp0RefClkP  : in    slv(1 downto 0);
      qsfp0RefClkN  : in    slv(1 downto 0);
      qsfp0RxP      : in    slv(3 downto 0);
      qsfp0RxN      : in    slv(3 downto 0);
      qsfp0TxP      : out   slv(3 downto 0);
      qsfp0TxN      : out   slv(3 downto 0);
      -- QSFP[1] Ports
      qsfp1RefClkP  : in    slv(1 downto 0);
      qsfp1RefClkN  : in    slv(1 downto 0);
      qsfp1RxP      : in    slv(3 downto 0);
      qsfp1RxN      : in    slv(3 downto 0);
      qsfp1TxP      : out   slv(3 downto 0);
      qsfp1TxN      : out   slv(3 downto 0);
      -- DDR Ports
      ddrClkP       : in    slv(3 downto 0);
      ddrClkN       : in    slv(3 downto 0);
      ddrOut        : out   DdrOutArray(3 downto 0);
      ddrInOut      : inout DdrInOutArray(3 downto 0);
      --------------
      --  Core Ports
      --------------
      -- System Ports
      userClkP      : in    sl;
      userClkN      : in    sl;
      i2cRstL       : out   sl;
      i2cScl        : inout sl;
      i2cSda        : inout sl;
      -- QSFP[1:0] Ports
      qsfpFs        : out   Slv2Array(1 downto 0);
      qsfpRefClkRst : out   slv(1 downto 0);
      qsfpRstL      : out   slv(1 downto 0);
      qsfpLpMode    : out   slv(1 downto 0);
      qsfpModSelL   : out   slv(1 downto 0);
      qsfpModPrsL   : in    slv(1 downto 0);
      -- PCIe Ports
      pciRstL       : in    sl;
      pciRefClkP    : in    sl;
      pciRefClkN    : in    sl;
      pciRxP        : in    slv(15 downto 0);
      pciRxN        : in    slv(15 downto 0);
      pciTxP        : out   slv(15 downto 0);
      pciTxN        : out   slv(15 downto 0));
end Lcls2CoaxpressOverFiberXilinxAlveoU200;

architecture top_level of Lcls2CoaxpressOverFiberXilinxAlveoU200 is

   constant DMA_AXIS_CONFIG_C : AxiStreamConfigType := ssiAxiStreamConfig(512/8);  -- 512-bit interface
   constant AXIL_CLK_FREQ_C   : real                := 156.25E+6;  -- units of Hz
   constant DMA_SIZE_C        : positive            := 1;

   constant BUFF_INDEX_C       : natural  := 0;
   constant HW_INDEX_C         : natural  := 1;
   constant APP_INDEX_C        : natural  := 2;
   constant NUM_AXIL_MASTERS_C : positive := 3;

   constant AXIL_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := (
      0               => (
         baseAddr     => x"0010_0000",
         addrBits     => 20,
         connectivity => x"FFFF"),
      1               => (
         baseAddr     => x"0080_0000",
         addrBits     => 22,
         connectivity => x"FFFF"),
      2               => (
         baseAddr     => x"00C0_0000",
         addrBits     => 22,
         connectivity => x"FFFF"));

   signal userClk156 : sl;
   signal userClk25  : sl;
   signal userRst25  : sl;

   signal axilClk          : sl;
   signal axilRst          : sl;
   signal axilReadMaster   : AxiLiteReadMasterType;
   signal axilReadSlave    : AxiLiteReadSlaveType;
   signal axilWriteMaster  : AxiLiteWriteMasterType;
   signal axilWriteSlave   : AxiLiteWriteSlaveType;
   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_MASTER_INIT_C);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)   := (others => AXI_LITE_READ_SLAVE_EMPTY_OK_C);
   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_MASTER_INIT_C);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_WRITE_SLAVE_EMPTY_OK_C);

   signal dmaClk        : sl;
   signal dmaRst        : sl;
   signal dmaObMasters  : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal dmaObSlaves   : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);
   signal dmaIbMasters  : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal dmaIbSlaves   : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);
   signal buffIbMasters : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal buffIbSlaves  : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);

   signal ddrClk          : slv(3 downto 0);
   signal ddrRst          : slv(3 downto 0);
   signal ddrReady        : slv(3 downto 0);
   signal ddrWriteMasters : AxiWriteMasterArray(3 downto 0);
   signal ddrWriteSlaves  : AxiWriteSlaveArray(3 downto 0);
   signal ddrReadMasters  : AxiReadMasterArray(3 downto 0);
   signal ddrReadSlaves   : AxiReadSlaveArray(3 downto 0);

   signal dataMaster     : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal dataSlave      : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;
   signal imageHdrMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal imageHdrSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;

   signal cfgIbMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal cfgIbSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;
   signal cfgObMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal cfgObSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;


   signal eventTrigMsgMasters : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal eventTrigMsgSlaves  : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);
   signal eventTrigMsgCtrl    : AxiStreamCtrlArray(DMA_SIZE_C-1 downto 0)   := (others => AXI_STREAM_CTRL_UNUSED_C);

   signal eventTimingMsgMasters : AxiStreamMasterArray(DMA_SIZE_C-1 downto 0) := (others => AXI_STREAM_MASTER_INIT_C);
   signal eventTimingMsgSlaves  : AxiStreamSlaveArray(DMA_SIZE_C-1 downto 0)  := (others => AXI_STREAM_SLAVE_FORCE_C);

begin

   ---------------------------
   -- AXI-Lite clock and Reset
   ---------------------------
   U_axilClk : entity surf.ClockManagerUltraScale
      generic map(
         TPD_G             => TPD_G,
         TYPE_G            => "PLL",
         INPUT_BUFG_G      => true,
         FB_BUFG_G         => true,
         RST_IN_POLARITY_G => '1',
         NUM_CLOCKS_G      => 2,
         -- MMCM attributes
         BANDWIDTH_G       => "OPTIMIZED",
         CLKIN_PERIOD_G    => 6.4,      -- 156.25 MHz
         CLKFBOUT_MULT_G   => 8,        -- 1.25GHz = 8 x 156.25 MHz
         CLKOUT0_DIVIDE_G  => 8,        -- 156.25MHz = 1.25GHz/8
         CLKOUT1_DIVIDE_G  => 50)       -- 25MHz = 1.25GHz/50
      port map(
         -- Clock Input
         clkIn     => userClk156,
         rstIn     => dmaRst,
         -- Clock Outputs
         clkOut(0) => axilClk,
         clkOut(1) => userClk25,
         -- Reset Outputs
         rstOut(0) => axilRst,
         rstOut(1) => userRst25);

   U_Core : entity axi_pcie_core.XilinxAlveoU200Core
      generic map (
         TPD_G             => TPD_G,
         BUILD_INFO_G      => BUILD_INFO_G,
         DMA_AXIS_CONFIG_G => DMA_AXIS_CONFIG_C,
         DMA_SIZE_G        => DMA_SIZE_C)
      port map (
         ------------------------
         --  Top Level Interfaces
         ------------------------
         userClk156     => userClk156,
         -- DMA Interfaces
         dmaClk         => dmaClk,
         dmaRst         => dmaRst,
         dmaObMasters   => dmaObMasters,
         dmaObSlaves    => dmaObSlaves,
         dmaIbMasters   => dmaIbMasters,
         dmaIbSlaves    => dmaIbSlaves,
         -- Application AXI-Lite Interfaces [0x00100000:0x00FFFFFF]
         appClk         => axilClk,
         appRst         => axilRst,
         appReadMaster  => axilReadMaster,
         appReadSlave   => axilReadSlave,
         appWriteMaster => axilWriteMaster,
         appWriteSlave  => axilWriteSlave,
         --------------
         --  Core Ports
         --------------
         -- System Ports
         userClkP       => userClkP,
         userClkN       => userClkN,
         i2cRstL        => i2cRstL,
         i2cScl         => i2cScl,
         i2cSda         => i2cSda,
         -- QSFP[1:0] Ports
         qsfpFs         => qsfpFs,
         qsfpRefClkRst  => qsfpRefClkRst,
         qsfpRstL       => qsfpRstL,
         qsfpLpMode     => qsfpLpMode,
         qsfpModSelL    => qsfpModSelL,
         qsfpModPrsL    => qsfpModPrsL,
         -- PCIe Ports
         pciRstL        => pciRstL,
         pciRefClkP     => pciRefClkP,
         pciRefClkN     => pciRefClkN,
         pciRxP         => pciRxP,
         pciRxN         => pciRxN,
         pciTxP         => pciTxP,
         pciTxN         => pciTxN);

   --------------------
   -- MIG[3:0] IP Cores
   --------------------
   U_Mig : entity axi_pcie_core.MigAll
      generic map (
         TPD_G => TPD_G)
      port map (
         extRst          => dmaRst,
         -- AXI MEM Interface
         axiClk          => ddrClk,
         axiRst          => ddrRst,
         axiReady        => ddrReady,
         axiWriteMasters => ddrWriteMasters,
         axiWriteSlaves  => ddrWriteSlaves,
         axiReadMasters  => ddrReadMasters,
         axiReadSlaves   => ddrReadSlaves,
         -- DDR Ports
         ddrClkP         => ddrClkP,
         ddrClkN         => ddrClkN,
         ddrOut          => ddrOut,
         ddrInOut        => ddrInOut);

   ---------------------
   -- AXI-Lite Crossbar
   ---------------------
   U_XBAR : entity surf.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => NUM_AXIL_MASTERS_C,
         MASTERS_CONFIG_G   => AXIL_CONFIG_C)
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMaster,
         sAxiWriteSlaves(0)  => axilWriteSlave,
         sAxiReadMasters(0)  => axilReadMaster,
         sAxiReadSlaves(0)   => axilReadSlave,
         mAxiWriteMasters    => axilWriteMasters,
         mAxiWriteSlaves     => axilWriteSlaves,
         mAxiReadMasters     => axilReadMasters,
         mAxiReadSlaves      => axilReadSlaves);

   -------------
   -- DMA Buffer
   -------------
   U_MigDmaBuffer : entity axi_pcie_core.MigDmaBuffer
      generic map (
         TPD_G             => TPD_G,
         DMA_SIZE_G        => DMA_SIZE_C,
         DMA_AXIS_CONFIG_G => DMA_AXIS_CONFIG_C,
         AXIL_BASE_ADDR_G  => AXIL_CONFIG_C(BUFF_INDEX_C).baseAddr)
      port map (
         -- AXI-Lite Interface (axilClk domain)
         axilClk          => axilClk,
         axilRst          => axilRst,
         axilReadMaster   => axilReadMasters(BUFF_INDEX_C),
         axilReadSlave    => axilReadSlaves(BUFF_INDEX_C),
         axilWriteMaster  => axilWriteMasters(BUFF_INDEX_C),
         axilWriteSlave   => axilWriteSlaves(BUFF_INDEX_C),
         -- Trigger Event streams (eventClk domain)
         eventClk         => axilClk,
         eventTrigMsgCtrl => eventTrigMsgCtrl,
         -- AXI Stream Interface (axisClk domain)
         axisClk          => dmaClk,
         axisRst          => dmaRst,
         sAxisMasters     => buffIbMasters,
         sAxisSlaves      => buffIbSlaves,
         mAxisMasters     => dmaIbMasters,
         mAxisSlaves      => dmaIbSlaves,
         -- DDR AXI MEM Interface
         ddrClk           => ddrClk,
         ddrRst           => ddrRst,
         ddrReady         => ddrReady,
         ddrWriteMasters  => ddrWriteMasters,
         ddrWriteSlaves   => ddrWriteSlaves,
         ddrReadMasters   => ddrReadMasters,
         ddrReadSlaves    => ddrReadSlaves);

   ---------------------
   -- Application Module
   ---------------------
   U_App : entity work.Application
      generic map (
         TPD_G             => TPD_G,
         DMA_AXIS_CONFIG_G => DMA_AXIS_CONFIG_C)
      port map (
         -- AXI-Lite Interface (axilClk domain)
         axilClk               => axilClk,
         axilRst               => axilRst,
         axilReadMaster        => axilReadMasters(APP_INDEX_C),
         axilReadSlave         => axilReadSlaves(APP_INDEX_C),
         axilWriteMaster       => axilWriteMasters(APP_INDEX_C),
         axilWriteSlave        => axilWriteSlaves(APP_INDEX_C),
         -- Data Interface (axilClk domain)
         dataMaster            => dataMaster,
         dataSlave             => dataSlave,
         imageHdrMaster        => imageHdrMaster,
         imageHdrSlave         => imageHdrSlave,
         -- Config Interface (axilClk domain)
         cfgIbMaster           => cfgIbMaster,
         cfgIbSlave            => cfgIbSlave,
         cfgObMaster           => cfgObMaster,
         cfgObSlave            => cfgObSlave,
         -- Trigger Event streams (axilClk domain)
         eventTrigMsgMaster   => eventTrigMsgMasters(0),
         eventTrigMsgSlave    => eventTrigMsgSlaves(0),
         eventTimingMsgMaster => eventTimingMsgMasters(0),
         eventTimingMsgSlave  => eventTimingMsgSlaves(0),
         -- DMA Interface (dmaClk domain)
         dmaClk                => dmaClk,
         dmaRst                => dmaRst,
         dmaObMaster          => dmaObMasters(0),
         dmaObSlave           => dmaObSlaves(0),
         dmaIbMaster          => buffIbMasters(0),
         dmaIbSlave           => buffIbSlaves(0));

   ------------------
   -- Hardware Module
   ------------------
   U_Hsio : entity work.Hsio
      generic map (
         TPD_G             => TPD_G,
         DMA_AXIS_CONFIG_G => DMA_AXIS_CONFIG_C,
         DMA_SIZE_G        => DMA_SIZE_C,
         AXIL_CLK_FREQ_G   => AXIL_CLK_FREQ_C,
         AXI_BASE_ADDR_G   => AXIL_CONFIG_C(HW_INDEX_C).baseAddr)
      port map (
         ------------------------
         --  Top Level Interfaces
         ------------------------
         -- Reference Clock and Reset
         userClk156            => axilClk,
         userClk25             => userClk25,
         userRst25             => userRst25,
         -- AXI-Lite Interface (axilClk domain)
         axilClk               => axilClk,
         axilRst               => axilRst,
         axilReadMaster        => axilReadMasters(HW_INDEX_C),
         axilReadSlave         => axilReadSlaves(HW_INDEX_C),
         axilWriteMaster       => axilWriteMasters(HW_INDEX_C),
         axilWriteSlave        => axilWriteSlaves(HW_INDEX_C),
         -- Data Interface (dataClk domain)
         dataClk               => axilClk,
         dataRst               => axilRst,
         dataMaster            => dataMaster,
         dataSlave             => dataSlave,
         imageHdrMaster        => imageHdrMaster,
         imageHdrSlave         => imageHdrSlave,
         -- Config Interface (cfgClk domain)
         cfgClk                => axilClk,
         cfgRst                => axilRst,
         cfgIbMaster           => cfgIbMaster,
         cfgIbSlave            => cfgIbSlave,
         cfgObMaster           => cfgObMaster,
         cfgObSlave            => cfgObSlave,
         -- Event interface
         eventClk              => axilClk,
         eventRst              => axilRst,
         eventTrigMsgMasters   => eventTrigMsgMasters,
         eventTrigMsgSlaves    => eventTrigMsgSlaves,
         eventTrigMsgCtrl      => eventTrigMsgCtrl,
         eventTimingMsgMasters => eventTimingMsgMasters,
         eventTimingMsgSlaves  => eventTimingMsgSlaves,
         ------------------
         --  Hardware Ports
         ------------------
         -- QSFP[0] Ports,
         qsfp0RefClkP          => qsfp0RefClkP,
         qsfp0RefClkN          => qsfp0RefClkN,
         qsfp0RxP              => qsfp0RxP,
         qsfp0RxN              => qsfp0RxN,
         qsfp0TxP              => qsfp0TxP,
         qsfp0TxN              => qsfp0TxN,
         -- QSFP[1] Ports
         qsfp1RefClkP          => qsfp1RefClkP,
         qsfp1RefClkN          => qsfp1RefClkN,
         qsfp1RxP              => qsfp1RxP,
         qsfp1RxN              => qsfp1RxN,
         qsfp1TxP              => qsfp1TxP,
         qsfp1TxN              => qsfp1TxN);

end top_level;
