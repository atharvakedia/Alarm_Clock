import warnings
import cocotb
from cocotb.triggers import Timer

from part2_helper import *

warnings.simplefilter(action='ignore', category=FutureWarning)

@cocotb.test() #tests if signal names/widths are correct
async def check_setup(dut):
    await check_pins(dut)

@cocotb.test() #test clr functionality across all signals
async def check_clr(dut):
    dut.SETUP_TIME.value = 1 #enter time setup mode
    dut.SETUP_ALARM.value = 0
    await increment_min_hr(dut, 1, 1)

    dut.SETUP_TIME.value = 0 #enter alarm setup mode
    dut.SETUP_ALARM.value = 1
    await increment_min_hr(dut, 1, 1)

    dut.SETUP_TIME.value = 0
    dut.SETUP_ALARM.value = 0
    await clear_design(dut)
    await check_clear(dut) #all 0's

@cocotb.test() #wait on minute
async def pass_one_minute(dut):
    await run_clock_seconds(dut, 100)
    assert dut.MINUTES.value == 1, "EXPECTED MINUTES TO BE 1"
