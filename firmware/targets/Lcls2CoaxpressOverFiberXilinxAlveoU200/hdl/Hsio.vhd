-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Hsio File
-------------------------------------------------------------------------------
-- Fiber Mapping to Hsio:
--    QSFP[0][0] = Coaxpress.Lane[0]
--    QSFP[0][1] = Coaxpress.Lane[1]
--    QSFP[0][2] = Coaxpress.Lane[2]
--    QSFP[0][3] = Coaxpress.Lane[3]
--    QSFP[1][0] = LCLS-I  Timing Receiver
--    QSFP[1][1] = LCLS-II Timing Receiver
--    QSFP[1][2] = Unused QSFP Link
--    QSFP[1][3] = Unused QSFP Link
-------------------------------------------------------------------------------
-- This file is part of LCLS2 PGP Firmware Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of LCLS2 PGP Firmware Library', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiStreamPkg.all;
use surf.CoaXPressPkg.all;

library lcls_timing_core;
use lcls_timing_core.TimingPkg.all;

library l2si_core;
use l2si_core.L2SiPkg.all;

-- Library that this module belongs to
library lcls2_pgp_fw_lib;

entity Hsio is
   generic (
      TPD_G             : time                 := 1 ns;
      DMA_AXIS_CONFIG_G : AxiStreamConfigType;
      AXIL_CLK_FREQ_G   : real                 := 156.25E+6;  -- units of Hz
      AXI_BASE_ADDR_G   : slv(31 downto 0)     := x"0080_0000";
      DMA_SIZE_G        : integer range 1 to 1 := 1);
   port (
      ------------------------
      --  Top Level Interfaces
      ------------------------
      -- Reference Clock and Reset
      userClk156            : in  sl;
      userClk25             : in  sl;
      userRst25             : in  sl;
      -- AXI-Lite Interface
      axilClk               : in  sl;
      axilRst               : in  sl;
      axilReadMaster        : in  AxiLiteReadMasterType;
      axilReadSlave         : out AxiLiteReadSlaveType;
      axilWriteMaster       : in  AxiLiteWriteMasterType;
      axilWriteSlave        : out AxiLiteWriteSlaveType;
      -- Data Interface (dataClk domain)
      dataClk               : in  sl;
      dataRst               : in  sl;
      dataMaster            : out AxiStreamMasterType;
      dataSlave             : in  AxiStreamSlaveType;
      imageHdrMaster        : out AxiStreamMasterType;
      imageHdrSlave         : in  AxiStreamSlaveType;
      -- Config Interface (cfgClk domain)
      cfgClk                : in  sl;
      cfgRst                : in  sl;
      cfgIbMaster           : in  AxiStreamMasterType;
      cfgIbSlave            : out AxiStreamSlaveType;
      cfgObMaster           : out AxiStreamMasterType;
      cfgObSlave            : in  AxiStreamSlaveType;
      -- L1 trigger feedback (optional)
      l1Clk                 : in  sl                                            := '0';
      l1Rst                 : in  sl                                            := '0';
      l1Feedbacks           : in  TriggerL1FeedbackArray(DMA_SIZE_G-1 downto 0) := (others => TRIGGER_L1_FEEDBACK_INIT_C);
      l1Acks                : out slv(DMA_SIZE_G-1 downto 0);
      -- Event streams (eventClk domain)
      eventClk              : in  sl;
      eventRst              : in  sl;
      eventTrigMsgMasters   : out AxiStreamMasterArray(DMA_SIZE_G-1 downto 0);
      eventTrigMsgSlaves    : in  AxiStreamSlaveArray(DMA_SIZE_G-1 downto 0);
      eventTrigMsgCtrl      : in  AxiStreamCtrlArray(DMA_SIZE_G-1 downto 0);
      eventTimingMsgMasters : out AxiStreamMasterArray(DMA_SIZE_G-1 downto 0);
      eventTimingMsgSlaves  : in  AxiStreamSlaveArray(DMA_SIZE_G-1 downto 0);
      clearReadout          : out slv(DMA_SIZE_G-1 downto 0);
      --------------
      --  U200 Ports
      --------------
      -- QSFP[0] Ports
      qsfp0RefClkP          : in  slv(1 downto 0)                               := (others => '0');
      qsfp0RefClkN          : in  slv(1 downto 0)                               := (others => '0');
      qsfp0RxP              : in  slv(3 downto 0)                               := (others => '0');
      qsfp0RxN              : in  slv(3 downto 0)                               := (others => '0');
      qsfp0TxP              : out slv(3 downto 0)                               := (others => '0');
      qsfp0TxN              : out slv(3 downto 0)                               := (others => '0');
      -- QSFP[1] Ports
      qsfp1RefClkP          : in  slv(1 downto 0)                               := (others => '0');
      qsfp1RefClkN          : in  slv(1 downto 0)                               := (others => '0');
      qsfp1RxP              : in  slv(3 downto 0)                               := (others => '0');
      qsfp1RxN              : in  slv(3 downto 0)                               := (others => '0');
      qsfp1TxP              : out slv(3 downto 0)                               := (others => '0');
      qsfp1TxN              : out slv(3 downto 0)                               := (others => '0'));
end Hsio;

architecture mapping of Hsio is

   constant CAMERA_INDEX_C     : natural  := 0;
   constant TIMING_INDEX_C     : natural  := 1;
   constant NUM_AXIL_MASTERS_C : positive := 2;

   -- 22 Bits available
   constant AXIL_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := (
      CAMERA_INDEX_C  => (
         baseAddr     => (AXI_BASE_ADDR_G+x"0000_0000"),
         addrBits     => 20,
         connectivity => x"FFFF"),
      TIMING_INDEX_C  => (
         baseAddr     => (AXI_BASE_ADDR_G+x"0010_0000"),
         addrBits     => 20,
         connectivity => x"FFFF"));

   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

   signal qpllLock   : slv(1 downto 0);
   signal qpllClk    : slv(1 downto 0);
   signal qpllRefclk : slv(1 downto 0);
   signal qpllRst    : Slv2Array(3 downto 0);
   signal qpllReset  : slv(1 downto 0);

   signal iTriggerData       : TriggerEventDataArray(DMA_SIZE_G-1 downto 0);
   signal remoteTriggersComb : slv(DMA_SIZE_G-1 downto 0) := (others => '0');
   signal remoteTriggers     : slv(DMA_SIZE_G-1 downto 0) := (others => '0');

   signal trigClk : sl;
   signal trigRst : sl;

begin

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

   --------------
   -- GT Clocking
   --------------
   U_QPLL : entity surf.CoaxpressOverFiberGtyUsQpll
      generic map (
         TPD_G => TPD_G)
      port map (
         -- MGT Clock Port
         gtClkP        => qsfp0RefClkP(1),
         gtClkN        => qsfp0RefClkN(1),
         coreRst       => axilRst,
         -- Quad PLL Ports
         qplllock      => qplllock,
         qplloutclk    => qpllClk,
         qplloutrefclk => qpllRefclk,
         qpllRst       => qpllReset);

   qpllReset(0) <= (qpllRst(0)(0) or qpllRst(1)(0) or qpllRst(2)(0) or qpllRst(3)(0)) and not(qPllLock(0));
   qpllReset(1) <= (qpllRst(0)(1) or qpllRst(1)(1) or qpllRst(2)(1) or qpllRst(3)(1)) and not(qPllLock(1));

   ---------------
   -- CXPoF Module
   ---------------
   U_CXPoF : entity surf.CoaxpressOverFiberGtyUs
      generic map (
         TPD_G              => TPD_G,
         NUM_LANES_G        => 4,
         STATUS_CNT_WIDTH_G => 12,
         RX_FSM_CNT_WIDTH_C => 15,  -- Optimize this down w.r.t camera to help make timing in CoaXPressRxHsFsm.vhd
         AXIL_BASE_ADDR_G   => AXIL_CONFIG_C(CAMERA_INDEX_C).baseAddr,
         AXIL_CLK_FREQ_G    => AXIL_CLK_FREQ_G,
         AXIS_CLK_FREQ_G    => AXIL_CLK_FREQ_G,
         AXIS_CONFIG_G      => DMA_AXIS_CONFIG_G)
      port map (
         -- QPLL Interface
         qpllLock        => (others => qpllLock),
         qpllClk         => (others => qpllClk),
         qpllRefclk      => (others => qpllRefclk),
         qpllRst         => qpllRst,
         -- GT Ports
         gtRxP           => qsfp0RxP,
         gtRxN           => qsfp0RxN,
         gtTxP           => qsfp0TxP,
         gtTxN           => qsfp0TxN,
         -- Trigger Interface (trigClk domain)
         trigClk         => trigClk,
         trigRst         => trigRst,
         trigger         => remoteTriggers(0),
         -- Data Interface (dataClk domain)
         dataClk         => dataClk,
         dataRst         => dataRst,
         dataMaster      => dataMaster,
         dataSlave       => dataSlave,
         imageHdrMaster  => imageHdrMaster,
         imageHdrSlave   => imageHdrSlave,
         -- Config Interface (cfgClk domain)
         cfgClk          => cfgClk,
         cfgRst          => cfgRst,
         cfgIbMaster     => cfgIbMaster,
         cfgIbSlave      => cfgIbSlave,
         cfgObMaster     => cfgObMaster,
         cfgObSlave      => cfgObSlave,
         -- AXI-Lite Interface (axilClk domain)
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilReadMaster  => axilReadMasters(CAMERA_INDEX_C),
         axilReadSlave   => axilReadSlaves(CAMERA_INDEX_C),
         axilWriteMaster => axilWriteMasters(CAMERA_INDEX_C),
         axilWriteSlave  => axilWriteSlaves(CAMERA_INDEX_C));

   ------------------
   -- Timing Receiver
   ------------------
   U_TimingRx : entity lcls2_pgp_fw_lib.TimingRx
      generic map (
         TPD_G               => TPD_G,
         USE_GT_REFCLK_G     => false,  -- FALSE: userClk25/userRst25
         DMA_AXIS_CONFIG_G   => DMA_AXIS_CONFIG_G,
         AXIL_CLK_FREQ_G     => AXIL_CLK_FREQ_G,
         AXI_BASE_ADDR_G     => AXIL_CONFIG_C(TIMING_INDEX_C).baseAddr,
         NUM_DETECTORS_G     => DMA_SIZE_G,
         EN_LCLS_I_TIMING_G  => true,
         EN_LCLS_II_TIMING_G => true)
      port map (
         -- Reference Clock and Reset
         userClk156            => userClk156,
         userClk25             => userClk25,
         userRst25             => userRst25,
         -- Trigger interface
         triggerClk            => trigClk,
         triggerRst            => trigRst,
         triggerData           => iTriggerData,
         -- Trigger interface
         l1Clk                 => l1Clk,
         l1Rst                 => l1Rst,
         l1Feedbacks           => l1Feedbacks,
         l1Acks                => l1Acks,
         -- Event interface
         eventClk              => eventClk,
         eventRst              => eventRst,
         eventTrigMsgMasters   => eventTrigMsgMasters,
         eventTrigMsgSlaves    => eventTrigMsgSlaves,
         eventTrigMsgCtrl      => eventTrigMsgCtrl,
         eventTimingMsgMasters => eventTimingMsgMasters,
         eventTimingMsgSlaves  => eventTimingMsgSlaves,
         clearReadout          => clearReadout,
         -- AXI-Lite Interface (axilClk domain)
         axilClk               => axilClk,
         axilRst               => axilRst,
         axilReadMaster        => axilReadMasters(TIMING_INDEX_C),
         axilReadSlave         => axilReadSlaves(TIMING_INDEX_C),
         axilWriteMaster       => axilWriteMasters(TIMING_INDEX_C),
         axilWriteSlave        => axilWriteSlaves(TIMING_INDEX_C),
         -- GT Serial Ports
         timingRxP             => qsfp1RxP(1 downto 0),
         timingRxN             => qsfp1RxN(1 downto 0),
         timingTxP             => qsfp1TxP(1 downto 0),
         timingTxN             => qsfp1TxN(1 downto 0));

   -----------------------------------
   -- Feed triggers directly to camera
   -----------------------------------
   TRIGGER_GEN : for i in DMA_SIZE_G-1 downto 0 generate
      remoteTriggersComb(i) <= iTriggerData(i).valid and iTriggerData(i).l0Accept;
   end generate TRIGGER_GEN;
   U_RegisterVector_1 : entity surf.RegisterVector
      generic map (
         TPD_G   => TPD_G,
         WIDTH_G => DMA_SIZE_G)
      port map (
         clk   => trigClk,
         sig_i => remoteTriggersComb,
         reg_o => remoteTriggers);

   --------------------
   -- Unused QSFP Links
   --------------------
   U_QSFP1 : entity surf.Gtye4ChannelDummy
      generic map (
         TPD_G   => TPD_G,
         WIDTH_G => 2)
      port map (
         refClk => axilClk,
         gtRxP  => qsfp1RxP(3 downto 2),
         gtRxN  => qsfp1RxN(3 downto 2),
         gtTxP  => qsfp1TxP(3 downto 2),
         gtTxN  => qsfp1TxN(3 downto 2));

end mapping;
