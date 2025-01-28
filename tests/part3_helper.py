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
    assert dut.DAY_ADV, "DAY_ADV Pin"
    assert dut.WEEK_ADV, "WEEK_ADV Pin"
    assert dut.MONTH_ADV, "MONTH_ADV Pin"

    #clock pins
    assert len(dut.SECONDS.value) == 7, "SECONDS Pin"
    assert len(dut.MINUTES.value) == 7, "MINUTES Pin"
    assert len(dut.HOURS.value) == 4, "HOURS Pin"
    assert len(dut.DAYS.value) == 4, "DAYS Pin"
    assert len(dut.WEEKS.value) == 2, "WEEKS Pin"
    assert len(dut.MONTHS.value) == 4, "MONTHS Pin"
    assert len(dut.YEARS.value) == 4, "YEARS Pin"

    #alarm pins
    assert len(dut.ALARM_MINUTES.value) == 7, "ALARM_MINUTES Pin"
    assert len(dut.ALARM_HOURS.value) == 4, "ALARM_HOURS Pin"
    assert len(dut.ALARM_DAYS.value) == 4, "ALARM_DAYS Pin"
    assert len(dut.ALARM_WEEKS.value) == 2, "ALARM_WEEKS Pin"
    assert len(dut.ALARM_MONTHS.value) == 4, "ALARM_MONTHS Pin"

    #segment display pins
    assert len(dut.SEG_SECONDS) == 14, "SEG_SECONDS Pin"
    assert len(dut.SEG_MINUTES) == 14, "SEG_MINUTES Pin"
    assert len(dut.SEG_HOURS) == 14, "SEG_HOURS Pin"
    assert len(dut.SEG_DAYS) == 14, "SEG_DAYS Pin"
    assert len(dut.SEG_WEEKS) == 14, "SEG_WEEKS Pin"
    assert len(dut.SEG_MONTHS) == 14, "SEG_MONTHS Pin"
    assert len(dut.SEG_YEARS) == 14, "SEG_YEARS Pin"

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
    assert dut.DAYS.value == 0, "DAYS not cleared"
    assert dut.WEEKS.value == 0, "WEEKS not cleared"
    assert dut.MONTHS.value == 0, "MONTHS not cleared"
    assert dut.YEARS.value == 0, "YEARS not cleared"

    assert dut.ALARM_MINUTES.value == 0, "ALARM_MINUTES not cleared"
    assert dut.ALARM_HOURS.value == 0, "ALARM_HOURS not cleared"
    assert dut.ALARM_DAYS.value == 0, "ALARM_DAYS not cleared"
    assert dut.ALARM_WEEKS.value == 0, "ALARM_WEEKS not cleared"
    assert dut.ALARM_MONTHS.value == 0, "ALARM_MONTHS not cleared"

async def increment_min_hr_dy_wk__mo(dut, min: int, hr: int, dy: int, wk: int, mo: int):
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
    for d in range(dy):
        dut.DAY_ADV.value = 1
        await Timer(1, units="ns")
        dut.DAY_ADV.value = 0
        await Timer(1, units="ns")
    for w in range(wk):
        dut.WEEK_ADV.value = 1
        await Timer(1, units="ns")
        dut.WEEK_ADV.value = 0
        await Timer(1, units="ns")
    for m_o in range(mo):
        dut.MONTH_ADV.value = 1
        await Timer(1, units="ns")
        #await FallingEdge(dut.CLK)
        dut.MONTH_ADV.value = 0
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