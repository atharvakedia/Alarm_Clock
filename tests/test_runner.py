from cocotb.runner import get_runner

import test_part1 as p1
import test_part2 as p2
import test_part3 as p3

SIM = "verilator"


def generate_runner(top_level: str):
    source = f"../verilog/{top_level}.v"
    runner = get_runner(SIM)
    runner.build(sources=[source, "../verilog/verilator_config.v"], hdl_toplevel=top_level)
    return runner


def test_part1():
    top_level = "ConventionalAlarmClock"
    runner = generate_runner(top_level)

    test_cases = [
        p1.check_setup,
        p1.check_clr,
        p1.pass_one_minute
    ]

    for element in test_cases:
        try:
            runner.test(hdl_toplevel=top_level, test_module=p1.__name__, testcase=element.__name__)
        except:
            print("FAILED")


def test_part2():
    top_level = "FrenchRepublicanAlarmClock"
    runner = generate_runner(top_level)

    test_cases = [
        p2.check_setup,
        p2.check_clr,
        p2.pass_one_minute
    ]

    for element in test_cases:
        try:
            runner.test(hdl_toplevel=top_level, test_module=p2.__name__, testcase=element.__name__)
        except:
            print("FAILED")


def test_part3():
    top_level = "FrenchRepublicanCalendarAlarmClock"
    runner = generate_runner(top_level)

    test_cases = [
        p3.check_setup,
        p3.check_clr,
        p3.pass_one_minute
    ]

    for element in test_cases:
        try:
            runner.test(hdl_toplevel=top_level, test_module=p3.__name__, testcase=element.__name__)
        except:
            print("FAILED")
