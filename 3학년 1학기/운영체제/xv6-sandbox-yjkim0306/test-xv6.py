#!/usr/bin/env python3

#
# python script that tests xv6 without having to boot it and type to its shell
#
# ./test-xv6.py usertests  (runs usertests)
# ./test-xv6.py -q usertests (runs the quick tests of usertests)
# ./test-xv6.py crash  (runs the crash tests)
# ./test-xv6.py log (runs the log crash test)

import argparse, os, re, signal, subprocess, sys, time
from subprocess import run

class QEMU(object):

    def __init__(self, reset: bool = False, cpus: int = 1):
        if reset:
            self._build_xv6()
            self._reset_fs()
        self.proc = subprocess.Popen(
            ["make", "qemu", f"CPUS={cpus}"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
        self.output = ""
        self.outbytes = bytearray()
        self._unchecked_line = 0
        # Wait for the xv6 shell prompt to appear instead of using a fixed sleep.
        prompt_timeout = 30
        result = self.monitor(prompt_timeout, (r".*\$ $", 0))
        if result == -1:
            # Failed to see the shell prompt within the timeout; terminate QEMU and abort.
            self.close(output_saving=False, shell_printing=False)
            raise RuntimeError(f"xv6 shell prompt not detected within {prompt_timeout} seconds")

    def cmd(self, c):
        if isinstance(c, str):
            c = c.encode("utf-8")
        self.proc.stdin.write(c)
        self.proc.stdin.flush()

    def monitor(self, timeout: int, *patterns: tuple[str | re.Pattern[str], int], shell_printing: bool = False):
        deadline = time.time() + timeout
        while True:
            time.sleep(1)
            timeleft = deadline - time.time()
            if timeleft < 0:
                return -1
            self._read()
            result = self._match(*patterns, shell_printing=shell_printing)
            if result is not None:
                return result

    def crash(self):
        ps = run(
            ["pgrep", "-P", str(self.proc.pid)],
            stdout=subprocess.PIPE,
            encoding="utf8"
        )
        kids = [int(line) for line in ps.stdout.splitlines()]
        if len(kids) == 0:
            print("no qemu")
            sys.exit(1)
        print("kill", kids[0])
        os.kill(kids[0], signal.SIGKILL)

    def close(self, output_saving: bool = True, shell_printing: bool = True):
        self.proc.terminate()
        if output_saving or shell_printing:
            self._read()
        if shell_printing:
            print(self.output)
        if output_saving:
            self._save_output()

    def _build_xv6(self):
        try:
            run(["make", "kernel/kernel"], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Command failed with exit code {e.returncode}")
            sys.exit(2)

    def _reset_fs(self):
        if os.path.exists("fs.img"):
            os.remove("fs.img")
        try:
            run(["make", "fs.img"], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Command failed with exit code {e.returncode}")
            sys.exit(2)

    def _read(self):
        buf = os.read(self.proc.stdout.fileno(), 4096)
        self.outbytes.extend(buf)
        self.output = self.outbytes.decode("utf-8", "replace")

    def _match(self, *patterns: tuple[str | re.Pattern[str], int], shell_printing: bool = False):
        lines = self.output.splitlines()
        for i in range(self._unchecked_line, len(lines)):
            line = lines[i]
            self._unchecked_line += 1
            if shell_printing:
                print(line)
            for (pattern, code) in patterns:
                if re.match(pattern, line):
                    return code

    def _save_output(self):
        try:
            with open("test-xv6.out", "w") as f:
                f.write(self.output)
        except OSError as e:
            print("Provided a bad results path. Error:", e)

def crash_log(shell_printing:bool, cpus: int = 1):
    q = QEMU(reset=True, cpus=cpus)
    q.cmd("logstress f0 f1 f2 f3 f4 f5\n")
    time.sleep(2)
    q.crash()
    q.close(shell_printing=shell_printing)

def recover_log(shell_printing: bool, cpus: int = 1):
    q = QEMU(cpus=cpus)
    result = q.monitor(2, ("^recovering", 0))
    time.sleep(2)
    if result != 0:
        q.close(shell_printing=shell_printing)
        return False
    q.cmd("ls\n")
    result = q.monitor(2, ("^f5", 0))
    q.close(shell_printing=shell_printing)
    return (result == 0)

def forphan(shell_printing: bool, cpus: int = 1):
    q = QEMU(reset=True, cpus=cpus)
    q.cmd("forphan\n")
    result = q.monitor(5, ("wait", 0))
    q.crash()
    q.close(shell_printing=shell_printing)
    return (result == 0)

def dorphan(shell_printing: bool, cpus: int = 1):
    q = QEMU(reset=True, cpus=cpus)
    q.cmd("dorphan\n")
    result = q.monitor(5, ("wait", 0))
    q.crash()
    q.close(shell_printing=shell_printing)
    return (result == 0)

def recover_orphan(shell_printing: bool, cpus: int = 1):
    q = QEMU(cpus=cpus)
    result = q.monitor(2, ("^ireclaim", 0))
    q.close(shell_printing=shell_printing)
    return (result == 0)

def test_log(shell_printing: bool = True, cpus: int = 1):
    print("Test recovery of log")
    for i in range(5):
        crash_log(shell_printing, cpus=cpus)
        if recover_log(shell_printing, cpus=cpus):
            print("OK")
            return
        print("log attempt ", i+1)
    print("FAIL")
    sys.exit(1)

def test_forphan(shell_printing: bool = True, cpus: int = 1):
    print("Test recovery of an orphaned file")
    if not forphan(shell_printing, cpus=cpus):
        print("FAIL")
        sys.exit(1)
    if not recover_orphan(shell_printing, cpus=cpus):
        print("FAIL")
        sys.exit(1)
    print("OK")

def test_dorphan(shell_printing: bool = True, cpus: int = 1):
    print("Test recovery of an orphaned file")
    if not dorphan(shell_printing, cpus=cpus):
        print("FAIL")
        sys.exit(1)
    if not recover_orphan(shell_printing, cpus=cpus):
        print("FAIL")
        sys.exit(1)
    print("OK")

def test_crash(shell_printing: bool = True, cpus: int = 1):
    test_log(shell_printing, cpus=cpus)
    test_forphan(shell_printing, cpus=cpus)
    test_dorphan(shell_printing, cpus=cpus)

def test_usertests(test="", shell_printing: bool = True, timeout: int = 600, quick: bool = False, cpus: int = 1):
    SUCCESS_CODE = 0
    FAIL_CODE = 1
    NEED_REVIEW_CODE = 2
    NO_TEST_CODE = 3
    TIMEOUT_CODE = 4

    opt = ""
    if quick:
        opt = " -q"
    elif test != "":
        opt += " " + test
    q = QEMU(True, cpus=cpus)
    q.cmd("usertests" + opt + "\n")
    result = q.monitor(
        timeout,
        ("^PASS ALL TESTS", SUCCESS_CODE),
        ("^FAIL SOME TESTS", FAIL_CODE),
        ("^SOME TESTS NEED REVIEW", NEED_REVIEW_CODE),
        ("^NO TESTS EXECUTED", NO_TEST_CODE)
    )
    q.close(shell_printing=shell_printing)
    if result < 0:
        exit(TIMEOUT_CODE)
    exit(result)

def parse_args():
    parser = argparse.ArgumentParser(description="xv6 Test Runner")

    parser.add_argument("test", nargs="?", default="usertests",
                        help="Python test suite to run (e.g., crash, log) or a specific xv6 usertest name (e.g., forktest).")
    parser.add_argument("-q", "--quick", action="store_true",
                        help="Run usertests in quick mode.")
    parser.add_argument("--timeout", type=int, default=600,
                        help="Set the timeout limit in seconds. (default: 600)")
    parser.add_argument("-s", "--silent", action="store_true",
                        help="Suppress QEMU log output to the terminal.")
    parser.add_argument("--cpus", type=int, default=1, help="number of CPUs for QEMU")  # temp

    return parser.parse_args()

def main():
    args = parse_args()

    do_print = not args.silent
    python_test_suites = {
        "log": test_log,
        "forphan": test_forphan,
        "dorphan": test_dorphan,
        "crash": test_crash,
        "usertests": test_usertests
    }

    test_target = args.test
    if test_target in python_test_suites:
        if test_target == "usertests":
            test_usertests(test="", shell_printing=do_print, quick=args.quick, timeout=args.timeout, cpus=args.cpus)
        else:
            python_test_suites[test_target](shell_printing=do_print, cpus=args.cpus)
    else:
        test_usertests(test=test_target, shell_printing=do_print, timeout=args.timeout, cpus=args.cpus)

if __name__ == "__main__":
    main()
