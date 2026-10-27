#!/bin/bash

# 1. 시뮬레이션 코드 단 한 번만 컴파일
echo "Compiling Verilog files..."
iverilog -o cpu_sim CPU_tb.v CPU.v CTRL.v ALU.v RF.v MEM.v HAZARD.v BP.v

# 컴파일 에러 발생 시 중단
if [ $? -ne 0 ]; then
    echo "ERROR: Compilation failed. Please check your Verilog code."
    exit 1
fi

# 2. Testcase 1부터 7까지 반복문 실행
for i in {1..7}
do
    echo "========================================"
    echo "          Running Testcase $i         "
    echo "========================================"

    # 정답 파일(reference) 복사해오기
    cp testcase/testcase${i}/reference_mem.mem .
    cp testcase/testcase${i}/reference_reg.mem .

    # 파이썬 스크립트로 초기(initial) 파일 생성
    python3 workload_gen.py testcase/testcase${i}/testcase${i}.hex

    # 시뮬레이션 실행
    vvp cpu_sim
done

echo "========================================"
echo "          All testcases finished!       "
echo "========================================"
