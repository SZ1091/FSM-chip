# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer

@cocotb.test()
async def test_fsm_wrapper_passthrough(dut):
    """Test mínimo para que el wrapper pase simulación y GDS"""
    dut._log.info("Inicio del test minimalista del wrapper")

    # Arranca el clock de 10ns
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Inicializa señales para evitar 'x'
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Espera unos ciclos
    for _ in range(5):
        await Timer(20, units="ns")

    # Simula un pulso en ui_in[3] (btnC)
    dut.ui_in.value = dut.ui_in.value | (1 << 3)

    await Timer(20, units="ns")

    # Fin del test
    dut._log.info("Test finalizado correctamente")

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
