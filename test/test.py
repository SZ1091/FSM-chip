# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_fsm_wrapper_passthrough(dut):

    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 1
    dut.ena.value = 1

    
    for _ in range(5):
        await Timer(20, units="ns")

    
    dut.ui_in.value = dut.ui_in.value | (1 << 3)

    await Timer(20, units="ns")

    # Fin del test
    dut._log.info("Test finalizado correctamente")

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
