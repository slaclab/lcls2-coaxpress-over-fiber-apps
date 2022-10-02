#-----------------------------------------------------------------------------
# This file is part of the LCLS2 PGP Firmware Library'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the LCLS2 PGP Firmware Library', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import pyrogue as pr

import surf.protocols.coaxpress as coaxpress
import lcls2_pgp_fw_lib.shared  as shared

class Hsio(pr.Device):
    def __init__(
            self,
            enLclsI      = True,
            enLclsII     = True,
            **kwargs):

        super().__init__(**kwargs)

        # Add CoaXPress Core
        self.add(coaxpress.CoaXPressAxiL(
            offset       = 0x0000_0000,
            numLane      = 4,
            expand       = True,
        ))

        # Add Timing Core
        self.add(shared.TimingRx(
            name         = 'TimingRx',
            offset       = 0x0010_0000,
            numDetectors = 1,
            enLclsI      = enLclsI,
            enLclsII     = enLclsII,
        ))
