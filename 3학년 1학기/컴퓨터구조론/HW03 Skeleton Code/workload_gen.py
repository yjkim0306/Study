import sys
import os

# Constants mimicking the C++ macros
REGSIZE = 32

TEXTSTART = 0
TEXTEND = 4096 >> 2
DATASTART = 4096 >> 2
DATAEND = 32768 >> 2
MEMSIZE = 32768 >> 2

# Assuming Status was an enum in your original code
# status = "CONTINUE" 

def main():
    if len(sys.argv) != 2:
        print("Missing instruction file", file=sys.stderr)
        sys.exit(0)

    print("Loading instruction memory...")
    filename = sys.argv[1]

    # Initialize registers
    register_files = [0] * REGSIZE
    # Set default $gp
    register_files[28] = 0x1800
    # Set default $sp
    register_files[29] = 0x3ffc

    # Initialize memory
    memory = [0] * MEMSIZE

    # Open instruction file and read
    if not os.path.exists(filename):
        print("Error: No instruction file!", file=sys.stderr)
        sys.exit(1)

    with open(filename, 'r') as inst_f:
        inst_id = 0
        for line in inst_f:
            line = line.strip()
            if not line:
                continue
            
            # Read hex string and convert to integer
            inst = int(line, 16)
            memory[inst_id] = inst
            inst_id += 1

    # Write initial register state to file
    with open("initial_reg.mem", "w") as fout_reg:
        for reg in register_files:
            # {:08x} formats the integer as an 8-character zero-padded lowercase hex string
            fout_reg.write(f"{reg:08x}\n")

    # Write initial memory state to file
    with open("initial_mem.mem", "w") as fout_mem:
        for mem in memory:
            fout_mem.write(f"{mem:08x}\n")

if __name__ == "__main__":
    main()
