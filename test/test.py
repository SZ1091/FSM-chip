# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_fsm_alarma(dut):
    dut._log.info("Inicio del test")

    # Configurar el reloj a 10us (100kHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Inicializar señales
    dut.ena.value = 1
    dut.ui_in.value = 0b00000000
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    # Quitar reset
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Aplicar reset interno (btnC = 1)
    dut.ui_in.value = 0b00001000  # btnC=1, sw=000
    await ClockCycles(dut.clk, 2)

    # Quitar btnC
    dut.ui_in.value = 0b00000000
    await ClockCycles(dut.clk, 2)

    # Activar entrada del primer detector: sw[0] = 1
    dut.ui_in.value = 0b00000001
    await ClockCycles(dut.clk, 10)

    # Verificar que el LED 0 (uo_out[0]) se activó al menos una vez
    led_state = [int(dut.uo_out.value) & 0b00000111 for _ in range(10)]
    for _ in range(10):
        await ClockCycles(dut.clk, 1)
        led_state.append(int(dut.uo_out.value) & 0b00000111)

    dut._log.info(f"LED states: {led_state}")

    assert any((s & 0b001) for s in led_state), "El LED 0 nunca se activó con sw[0] = 1"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
