# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_fsm_wrapper_passthrough(dut):
    """Test mínimo para que el wrapper pase simulación y GDS"""

    dut._log.info("Inicio del test minimalista del wrapper")

    # Inicializa señales
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Generar clock en ui[4] (bit 4 del vector ui_in)
    async def clock_gen():
        for _ in range(10):
            dut.ui_in.value = dut.ui_in.value.integer | 0b00010000  # clk = 1
            await Timer(5, units="ns")
            dut.ui_in.value = dut.ui_in.value.integer & 0b11101111  # clk = 0
            await Timer(5, units="ns")

    cocotb.start_soon(clock_gen())

    await Timer(10, units="ns")
    dut.ui_in.value = 0b00011101  # clk=1, btnC=1, sw={1,0,1}

    await Timer(100, units="ns")

    dut._log.info("Test finalizado sin errores")

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
