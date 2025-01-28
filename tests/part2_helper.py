import warnings
import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock

warnings.simplefilter(action='ignore', category=FutureWarning)

async def check_pins(dut):
    assert dut.CLK, "CLK Pin"

    assert dut.CLR, "CLR Pin"
    assert dut.SETUP_TIME, "SETUP_TIME Pin"
    assert dut.SETUP_ALARM, "SETUP_ALARM Pin"
    assert dut.ALARM_EN, "ALARM_EN Pin"
    assert dut.MIN_ADV, "MIN_ADV Pin"
    assert dut.HR_ADV, "HR_ADV Pin"

    #clock pins
    assert len(dut.SECONDS.value) == 7, "SECONDS Pin"
    assert len(dut.MINUTES.value) == 7, "MINUTES Pin"
    assert len(dut.HOURS.value) == 4, "HOURS Pin"

    #alarm pins
    assert len(dut.ALARM_MINUTES.value) == 7, "ALARM_MINUTES Pin"
    assert len(dut.ALARM_HOURS.value) == 4, "ALARM_HOURS Pin"

    #segment display pins
    assert len(dut.SEG_SECONDS) == 14, "SEG_SECONDS Pin"
    assert len(dut.SEG_MINUTES) == 14, "SEG_MINUTES Pin"
    assert len(dut.SEG_HOURS) == 14, "SEG_HOURS Pin"

    assert dut.BUZZ, "BUZZ Pin"

async def clear_design(dut):
    dut.CLR.value = 1
    cocotb.start_soon(clock_gen(dut))
    await RisingEdge(dut.CLK)
    await RisingEdge(dut.CLK)

async def check_clear(dut):
    assert dut.SECONDS.value == 0, "SECONDS not cleared"
    assert dut.MINUTES.value == 0, "MINUTES not cleared"
    assert dut.HOURS.value == 0, "HOURS not cleared"

    assert dut.ALARM_MINUTES.value == 0, "ALARM_MINUTES not cleared"
    assert dut.ALARM_HOURS.value == 0, "ALARM_HOURS not cleared"

async def increment_min_hr(dut, min: int, hr: int):
    for m in range(min):
        dut.MIN_ADV.value = 1
        await Timer(1, units="ns")
        dut.MIN_ADV.value = 0
        await Timer(1, units="ns")
    for h in range(hr):
        dut.HR_ADV.value = 1
        await Timer(1, units="ns")
        dut.HR_ADV.value = 0
        await Timer(1, units="ns")

async def run_clock_seconds(dut, seconds: int):
    assert seconds >= 0, "Seconds must be a positive integer"

    c = Clock(dut.CLK, 1, 'ns')
    await cocotb.start(c.start())
    await Timer(seconds, units="ns")

async def clock_gen(dut):
    while True:
        await Timer(1, units='ns')
        dut.CLK.value = 0
        await Timer(1, units='ns')
        dut.CLK.value = 1