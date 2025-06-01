# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock


@cocotb.test()
async def test_fsm_wrapper_passthrough(dut):
    """Test mínimo para que el wrapper pase simulación y GDS"""

    dut._log.info("Inicio del test minimalista del wrapper")

    # Inicialización de señales
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0b00000000  # sw[2:0] = 0, btnC = 0, clk = 0
    dut.uio_in.value = 0

    # Generar clock en ui[4] (bit 4 de ui_in)
    async def clock_gen():
        while True:
            current = dut.ui_in.value.integer
            # Poner bit 4 en 1
            dut.ui_in.value = current | 0b00010000
            await Timer(5, units="ns")
            # Poner bit 4 en 0
            dut.ui_in.value = current & 0b11101111
            await Timer(5, units="ns")

    cocotb.start_soon(clock_gen())

    # Quitar reset
    await Timer(10, units="ns")
    dut.rst_n.value = 1

    # Activar btnC (bit 3 de ui_in)
    await Timer(10, units="ns")
    dut.ui_in.value = dut.ui_in.value.integer | 0b00001000  # activar btnC

    # Activar algunos switches
    await Timer(10, units="ns")
    dut.ui_in.value = dut.ui_in.value.integer | 0b00000101  # sw[0] y sw[2] = 1

    # Esperar un poco más de tiempo
    await Timer(100, units="ns")

    dut._log.info("Test finalizado sin errores")


    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
