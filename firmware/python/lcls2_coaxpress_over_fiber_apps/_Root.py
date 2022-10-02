#!/usr/bin/env python3
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
import rogue
import click
import time

import axipcie
import lcls2_coaxpress_over_fiber_apps as clDev
import lcls2_pgp_fw_lib.shared         as shared
import surf.protocols.batcher          as batcher
import surf.protocols.coaxpress        as coaxpress
import l2si_core                       as l2si

rogue.Version.minVersion('5.15.0')

class Root(shared.Root):

    def __init__(self,
            dev            = '/dev/datadev_0',# path to PCIe device
            enLclsI        = True,
            enLclsII       = True,
            startupMode    = False, # False = LCLS-I timing mode, True = LCLS-II timing mode
            standAloneMode = False, # False = using fiber timing, True = locally generated timing
            pollEn         = True,  # Enable automatic polling registers
            initRead       = True,  # Read all registers at start of the system
            pcieBoardType  = None,
            cameraType     = None,
        **kwargs):

        # Set the firmware Version lock = firmware/targets/shared_version.mk
        self.FwVersionLock = 0x07150000

        # Set local variables
        self.dev            = dev
        self.startupMode    = startupMode
        self.standAloneMode = standAloneMode
        self.cameraType     = cameraType
        self.defaultFile    = [f'config/{cameraType}.yml']

        # Check for simulation
        if dev == 'sim':
            kwargs['timeout'] = 100000000 # 100 s
        else:
            kwargs['timeout'] = 5000000 # 5 s

        # Pass custom value to parent via super function
        super().__init__(
            dev      = dev,
            pollEn   = pollEn,
            initRead = initRead,
        **kwargs)

        # Unhide the RemoteVariableDump command
        self.RemoteVariableDump.hidden = False

        # Create memory interface
        self._memMap = axipcie.createAxiPcieMemMap(dev, 'localhost', 8000)
        self._memMap.setName('PCIe_Bar0')

        # Instantiate the top level Device and pass it the memory map
        self.add(clDev.Fpga(
            memBase      = self._memMap,
            enLclsI      = enLclsI,
            enLclsII     = enLclsII,
            boardType    = pcieBoardType,
            expand       = True,
        ))

        # Create and the configuration stream to the camera
        if (self.cameraType != None):

            # Create the DMA configuration stream
            if (dev != 'sim'):
                self._configStream = rogue.hardware.axi.AxiStreamDma(dev,0,1)
            else:
                self._configStream = rogue.interfaces.stream.TcpClient('localhost', (8000+2))

            # Create the SRPv3
            self._srp = rogue.protocols.srp.SrpV3()

            # Connect DMA to SRPv3
            self._configStream == self._srp

            # Add the camera bootstrap
            self.add(coaxpress.Bootstrap(
                memBase        = self._srp,
                CoaXPressAxiL  = self.Fpga.Hsio.CoaXPressAxiL,
                expand         = False,
                enabled        = False,
            ))

            # Add the camera device
            if self.cameraType == 'PhantomS991':
                self.add(coaxpress.PhantomS991(
                    memBase = self._srp,
                    expand  = True,
                    enabled = False,
                ))
                self.camera = self.PhantomS991

        # Add local variables
        self.add(pr.LocalVariable(
            name        = 'RunState',
            description = 'Run state status, which is controlled by the StopRun() and StartRun() commands',
            mode        = 'RO',
            value       = False,
        ))

        @self.command(description  = 'Stops the triggers and blows off data in the pipeline')
        def StopRun():
            print( f'{self.path}.StopRun() executed' )

            # Get devices
            eventBuilder = self.find(typ=batcher.AxiStreamBatcherEventBuilder)
            trigger      = self.find(typ=l2si.TriggerEventBuffer)

            # Turn off camera streaming
            self.camera.AcquisitionStop()

            # Turn off the triggering
            for devPtr in trigger:
                devPtr.MasterEnable.set(False)

            # Flush the downstream data/trigger pipelines
            for devPtr in eventBuilder:
                devPtr.Blowoff.set(True)

            # Update the run state status variable
            self.RunState.set(False)

        @self.command(description  = 'starts the triggers and allow steams to flow to DMA engine')
        def StartRun():
            print( f'{self.path}.StartRun() executed' )

            # Get devices
            eventBuilder = self.find(typ=batcher.AxiStreamBatcherEventBuilder)
            trigger      = self.find(typ=l2si.TriggerEventBuffer)

            # Reset all counters
            self.CountReset()

            # Turn on camera streaming
            self.camera.AcquisitionStart()

            # Arm for data/trigger stream
            for devPtr in eventBuilder:
                devPtr.Blowoff.set(False)
                devPtr.SoftRst()

            # Turn on the triggering
            for devPtr in trigger:
                devPtr.MasterEnable.set(True)

            # Update the run state status variable
            self.RunState.set(True)

    def start(self, **kwargs):
        super().start(**kwargs)

        # Useful pointer
        timingRx = self.Fpga.Hsio.TimingRx
        axiVersion = self.Fpga.AxiPcieCore.AxiVersion

        # Check if not simulation
        if (self.dev != 'sim'):

            ###############################################################
            print ( '###################################################')
            axiVersion.printStatus()
            print ( '###################################################')
            ###############################################################

            # Connection reset
            self.Bootstrap.enable.set(True)
            self.Bootstrap.DeviceDiscovery()

            ###############################################################

            # Start up the timing system = LCLS-II mode
            if self.startupMode:

                # Set the default to  LCLS-II mode
                defaultFile = ['config/defaults_LCLS-II.yml']

                # Startup in LCLS-II mode
                if self.standAloneMode:
                    timingRx.ConfigureXpmMini()
                else:
                    timingRx.ConfigLclsTimingV2()

            # Else LCLS-I mode
            else:

                # Set the default to  LCLS-I mode
                defaultFile = ['config/defaults_LCLS-I.yml']

                # Startup in LCLS-I mode
                if self.standAloneMode:
                    timingRx.ConfigureTpgMiniStream()
                else:
                    timingRx.ConfigLclsTimingV1()

            # Load the YAML configurations
            # self.defaultFile.extend(defaultFile)
            # print( f'Loading {self.defaultFile} Configuration File...' )
            self.LoadConfig(self.defaultFile)
            self.LoadConfig(defaultFile)

            # Read all the variables
            self.ReadAll()

    # Function calls after loading YAML configuration
    def initialize(self):
        super().initialize()
        self.StopRun()
        self.CountReset()
