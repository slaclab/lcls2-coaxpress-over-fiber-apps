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

import surf.protocols.batcher as batcher

class Application(pr.Device):
    def __init__(self,**kwargs):
        super().__init__(**kwargs)

        #######################################
        # SLAVE[INDEX=0][TDEST=0] = XPM Trigger
        # SLAVE[INDEX=0][TDEST=1] = XPM Event Transition
        # SLAVE[INDEX=1][TDEST=2] = Camera Image Data
        # SLAVE[INDEX=2][TDEST=3] = XPM Timing
        # SLAVE[INDEX=3][TDEST=4] = Camera Image Header
        #######################################
        self.add(batcher.AxiStreamBatcherEventBuilder(
            name         = 'EventBuilder',
            offset       = 0x0_0000,
            numberSlaves = 4, # Total number of slave indexes (not necessarily same as TDEST)
            tickUnit     = '1/156.25MHz',
            expand       = True,
        ))
