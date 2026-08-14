# 16 bit multicycle CPU

A custom ISA 16 bit CPU designed in VHDL and implemented for FPGA hardware using Xilinx Vivado. The processor uses a custom ISA and a Harvard architecture. 

This project was built to explore and understand processor architecture, data-path design, FSMs, and memory interfacing. 

## Features Include:
- 16 bit data-path
- Custom 16 bit instruction set
- 8 general purpose 16 bit registers
- Arithmetic and Logic Unit (ALU)
- Zero and negative flags
- 256 x 16 bit data RAM
- A separate ROM
- 11 bit Program Counter (PC)
- Load Immediate value support
- Load and store capabilities 
- Jump instruction
- A multicycle control unit 
- Clock-enable divider - slows the execution rate for visual debugging when implemented on FPGA board

## CPU architecture:
The processor is made up of many modules all connected in the top level

- **Program Counter (PC)** - holds the current instruction address and can increment by 1 or jump to a specific address
- **Program ROM** - Holds the instructions 
- **Instruction Register (IR)** - Keeps the current instruction stored and stable for the control unit throughout the states
- **Control Unit** - uses an FSM to decode the opcode and asserts the control signal that are needed for the instruction
- **Register File** - contains eight 16-bit general-purpose registers with two read and one write port
- **ALU** - performs arithmetic and logic operations and produces a zero and negative flag
- **RAM** - has 256 addressable locations, each storing 16 bits

## Instruction format:
```
[15:11] Opcode
[10:8] Destination Register (rd)
[7:5] Source Register (rs)
```
My Immediate, jump, and load/store instructions use a different format reusing bits

### Immediate Instructions format:
```
[15:11] Opcode
[10:8] Destination Register
[7:0] Immediate Value
```
### Load/Store instruction format:
```
[15:11] Opcode
[10:8] Register field
[7:0] Ram Address
```
### Jump instruction format:
```
[15:11] Opcode
[10:0] Jump address
```
## Instruction Set:

| Opcode | Instruction | Operation |
|--------|-------------|-----------|
| 00000 | AND | Rd <- Rd AND Rs |
| 00001 | OR | Rd <- Rd OR Rs |
| 00010 | NAND | Rd <- Rd NAND Rs |
| 00011 | NOR | Rd <- Rd NOR Rs |
| 00100 | XOR | Rd <- Rd XOR Rs |
| 00101 | MOV | Rd <- Rs |
| 00110 | ADD | Rd <- Rd + Rs |
| 00111 | SUB | Rd <- Rd - Rs |
| 01000 | LOADI | Rd <- Immediate |
| 01001 | LOAD | Rd <- RAM[addr] |
| 01010 | STORE | RAM[addr] <- Rd |
| 01011 | JUMP | PC <- Jump address |

## Multicycle control:
The control unit executes instructions using an FSM.

### Fetch: 
Fetches instruction from ROM and saves it to the IR and advances the program counter.

### Decode: 
The decode state serves as an intermediate cycle between fetching and executing an instruction. No control signals are asserted during this state. The instruction fields are continuously extracted from the instruction register, and the register file provides the selected operands so they are available when the processor enters the execute state. 

### Execute: 
Depending on the opcode, arithmetic or logic opcodes use the ALU, STORE writes to the RAM, and JUMP changes the PC.

### Writeback: 
This state is used for Load. Since the RAM is synchronous the data needs an extra cycle before the data is available for writeback. For now this is the only instruction that uses this state.

## ALU:
The 16 bit ALU supports 8 operations, and the ALU select values match with the lower three bits in their corresponding ALU opcodes.

- ALU select 000: AND
- ALU select 001: OR
- ALU select 010: NAND
- ALU select 011: NOR
- ALU select 100: XOR
- ALU select 101: MOV
- ALU select 110: ADD
- ALU select 111: SUB

Zero flag(Z): is asserted when the result is zero
Negative flag(N): is asserted when the results most significant bit(15) is 1 

## Example program:
The current program in the ROM is only used to test every instruction and check everything is working properly including:

- Arithmetic and logic operations
- Register-to-register movement
- Immediate loading
- Writing register data to RAM
- Loading RAM data back into a register
- Jumping to another instruction address

## Source Files:
all VHDL files are located under the folder named src

- **cpu_top_level.vhd** - "wires" all the components and control signals
- **cpu_CU_ver2.vhd** - Multicycle FSM control unit
- **cpu_alu.vhd** - arithmetic and logic unit
- **cpu_register.vhd** - Eight 16 bit Register file
- **cpu_ram.vhd** - synchronous ram unit
- **PC_cpu.vhd** - Program counter and jump logic
- **ROM.vhd** - Program instructions

## Tools and Tech:
- Basys 3 FPGA board
- Xilinx Vivado
- VHDL
- RTL

## What I learned: 

This project taught me the architecture of a processor, data-path design, instruction encoding, Multicycle control unit, synchronous memory, register file design, ALU design, and how to use a shared clock across multiple components

## Demo video: 
the demo video shows the CPU running on the Basys 3 FPGA board. The 16 LEDs each represent a bit of the output.

