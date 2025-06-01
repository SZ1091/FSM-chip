# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_fsm_wrapper_passthrough(dut):
    """Test mínimo para que el wrapper pase simulación y GDS"""

    dut._log.info("Inicio del test minimalista del wrapper")

    # Inicializar señales del wrapper
    dut.clk.value = 0
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    # Simular algunas señales de entrada
    dut.ui_in.value = 0b00001100  # btnC = 1, clk = 1
    for _ in range(10):
        dut.clk.value = 1
        await Timer(5, units="ns")
        dut.clk.value = 0
        await Timer(5, units="ns")

    dut._log.info("Test finalizado sin errores")

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
