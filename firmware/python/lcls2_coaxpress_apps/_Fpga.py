#-----------------------------------------------------------------------------
# This file is part of the 'Camera link gateway'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Camera link gateway', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------
import pyrogue as pr

import axipcie                 as pcie
import lcls2_pgp_fw_lib.shared as shared
import lcls2_coaxpress_apps    as clDev
import surf.axi                as axi

class Fpga(pr.Device):
    def __init__(self,
                 enLclsI      = True,
                 enLclsII     = True,
                 boardType    = None,
                 **kwargs):
        super().__init__(**kwargs)

        # Core Layer
        self.add(pcie.AxiPcieCore(
            offset      = 0x0000_0000,
            numDmaLanes = 1,
            boardType   = boardType,
            expand      = False,
        ))

        # Inbound DMA's DDR Memory buffer
        self.add(axi.AxiStreamDmaV2Fifo(
            name    = 'MigDmaBuffer',
            offset  = 0x0010_0000,
            expand  = False,
        ))

        # Application layer
        self.add(shared.Application(
            offset     = 0x00C0_0000,
            numLanes   = 1,
            expand     = True,
        ))
        self.Application.AppLane[0].VcDataTap.hidden = True
        self.Application.AppLane[0].XpmPauseThresh.hidden = True

        # Hardware Layer
        self.add(clDev.Hsio(
            offset       = 0x0080_0000,
            enLclsI      = enLclsI,
            enLclsII     = enLclsII,
            expand       = True,
        ))
