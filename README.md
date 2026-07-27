Verilog RISC Computer

A RISC computer (CPU + memory + I/O) implemented in Verilog, 
built as a learning project. Includes test programs
to verify functionality.

Status:
Early Stage/ learning process

Tools:
 -Simulator (Icarus Verilog)
 -Waveform Viewer (GTKWave)
 
Design Flow:
 -Write Verilog code for the circuit
 -Simulate to verify functionality
 -Synthesize into gate-level netlist
 -Perform place-and-route
 -Validate and test using implementation

Goals:
 -Define instruction set architecture (ISA)
 -Implement ALU
 -Implement register file
 -Implement control unit / instruction decoder
 -Implement program counter and instruction fetch logic
 -Implement memory (instruction + data)
 -Wire up the datapath (single-cycle or multi-cycle)
 -Write a test program (assembly or hex)
 -Simulate and verify with a testbench
 -(Stretch) Add I/O, pipelining, or a simple assembler

RISC-V-inspired 8-bit Instruction set 