# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.triggers import Timer
import random

@cocotb.test()
async def test_fsm_alarma(dut):
    """Test para verificar que el LED 0 se activa con sw[0] = 1 (H = 1)."""

    cocotb.log.info("Inicio del test")

    # Asegurar reset activo inicialmente
    dut.btnC.value = 1
    dut.sw.value = 0  # Todos los switches en 0
    await Timer(10, units="us")

    # Liberar el reset
    dut.btnC.value = 0
    await Timer(10, units="us")

    # Activar sw[0] = 1 (H = 1), mantener durante 100us
    dut.sw.value = 0b001
    await Timer(100, units="us")

    # Luego desactivar H
    dut.sw.value = 0b000
    await Timer(50, units="us")

    # Leer la salida de los LEDs durante múltiples ciclos
    led_state = []
    for _ in range(100):
        led_state.append(int(dut.led.value))
        await Timer(2, units="us")

    cocotb.log.info(f"LED states: {led_state}")

    # Verificar que led[0] (bit 0) estuvo activo al menos una vez
    assert any((s & 0b001) for s in led_state), "El LED 0 nunca se activó con sw[0] = 1"

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
