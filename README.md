# 8-bit Verilog RISC-V-Inspired Computer

A RISC computer (CPU + memory + I/O) implemented in Verilog, built as a learning project. Includes test programs to verify functionality.

## Status

Early stage / learning process

## Tools

| Tool | Purpose |
|---|---|
| [Icarus Verilog](http://iverilog.icarus.com/) | Simulator |
| [GTKWave](http://gtkwave.sourceforge.net/) | Waveform viewer |

## Design Flow

1. Write Verilog code for the circuit (RTL)
2. Simulate to verify functionality (testbenches)
3. Debug / iterate on RTL based on simulation results
4. *(Later, only if targeting real hardware)* Synthesize → Place & Route → Bitstream/GDSII

## Goals

- [ ] Define instruction set architecture (ISA)
- [ ] Implement ALU
- [ ] Implement register file
- [ ] Implement control unit / instruction decoder
- [ ] Implement program counter and instruction fetch logic
- [ ] Implement memory (instruction + data)
- [ ] Wire up the datapath (single-cycle or multi-cycle)
- [ ] Write a test program (assembly or hex)
- [ ] Simulate and verify with a testbench
- [ ] *(Stretch)* Add I/O, pipelining, or a simple assembler

## RISC-V-Inspired 8-bit Instruction Set

*Documentation in progress.*

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.