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

> **Note:** RISC-V has no official 8-bit base ISA (the smallest standard variant is RV32E). This instruction set is *inspired by* RISC-V's design philosophy — load/store architecture, few instruction formats, simple decode — adapted to fit an 8-bit datapath with a Harvard architecture.

### Parameters

| Parameter | Value |
|---|---|
| Data width | 8 bits |
| Instruction width | 16 bits |
| Register count | 8 (`r0`–`r7`), `r0` hardwired to 0 |
| Address width | 8 bits (256 locations) |
| Memory model | Harvard (separate instruction and data memory) |

### Instruction Formats

Every instruction is 16 bits wide, with opcode always in bits `[15:12]`. Four formats cover the full instruction set:

```
R-type: [opcode 4][rd 3][rs1 3][rs2 3][funct3 3]   — register-register ALU ops
I-type: [opcode 4][rd 3][rs1 3][imm 6]              — immediate ALU ops, loads
S-type: [opcode 4][rs1 3][rs2 3][imm 6]             — stores
B-type: [opcode 4][rs1 3][rs2 3][imm 6]             — branches (PC-relative)
J-type: [opcode 4][rd 3][imm 9]                     — jumps (PC-relative)
```

**How the formats divide the work:**

| Format | Fields | Used for | Notes |
|---|---|---|---|
| **R-type** | rd, rs1, rs2, funct3 | Register-register ALU ops | Both operands come from registers; `funct3` selects the operation |
| **I-type** | rd, rs1, imm | Immediate ALU ops, loads | Second operand is a constant encoded in the instruction, not a register |
| **S-type** | rs1, rs2, imm | Stores | No `rd` — stores don't write to a register. `rs2` supplies the value being written; `rs1 + imm` computes the address |
| **B-type** | rs1, rs2, imm | Conditional branches | `rs1`/`rs2` are compared; `imm` is a **signed, PC-relative offset** (`PC = PC + imm`), so branches can jump both forward and backward (needed for loops) |
| **J-type** | rd, imm | Unconditional jumps / calls | No condition, no registers compared. `rd` stores the **return address** (`PC + 1`) rather than a computed result; `imm` is a larger signed PC-relative offset |

**Immediates are signed (two's complement)** and sign-extended to 8 bits before reaching the ALU. With a 6-bit field, ADDI/ANDI/branch offsets/etc range from **-32 to +31**; J-type's 9-bit field ranges from **-256 to +255**.

### Register-Register ALU (R-type) — opcode `0000`, selected by `funct3`

| Mnemonic | funct3 | Operation |
|---|---|---|
| ADD | 000 | rd = rs1 + rs2 |
| SUB | 001 | rd = rs1 − rs2 |
| AND | 010 | rd = rs1 & rs2 |
| OR | 011 | rd = rs1 \| rs2 |
| XOR | 100 | rd = rs1 ^ rs2 |
| SLL | 101 | rd = rs1 << rs2[2:0] |
| SRL | 110 | rd = rs1 >> rs2[2:0] (logical) |
| SRA | 111 | rd = rs1 >> rs2[2:0] (arithmetic) |

| Mnemonic | opcode | Operation |
|---|---|---|
| SLT | 0001 | rd = (rs1 < rs2), **signed** comparison → 1 or 0 |
| SLTU | 0010 | rd = (rs1 < rs2), **unsigned** comparison → 1 or 0 |

### Immediate ALU (I-type) — opcode `0011`, selected by `funct3`


| Mnemonic | Operation |
|---|---|
| ADDI rd, rs1, imm | rd = rs1 + imm |
| ANDI rd, rs1, imm | rd = rs1 & imm |
| ORI rd, rs1, imm | rd = rs1 \| imm |
| XORI rd, rs1, imm | rd = rs1 ^ imm |
| SLTI rd, rs1, imm | rd = (rs1 < imm), signed |
| SLTIU rd, rs1, imm | rd = (rs1 < imm), unsigned |
| SLLI rd, rs1, shamt | rd = rs1 << shamt |
| SRLI rd, rs1, shamt | rd = rs1 >> shamt (logical) |
| SRAI rd, rs1, shamt | rd = rs1 >> shamt (arithmetic) |

> Shift amounts (`shamt`) only need 3 bits (0–7) since the datapath is 8 bits wide, even though they sit in the same 6-bit imm field — don't sign-extend a shift amount, it isn't a signed quantity.

### Load / Store

| Mnemonic | Format | opcode | Operation |
|---|---|---|---|
| LOAD rd, imm(rs1) | I-type | 0100 | rd = MEM[rs1 + imm] |
| STORE rs2, imm(rs1) | S-type | 0101 | MEM[rs1 + imm] = rs2 |

Base + offset addressing: `rs1` holds a base address, `imm` is a fixed offset from it. To target a fixed, known address, use `r0` (always 0) as the base and put the full address in `imm`; to target a runtime-computed address (arrays, pointers), put the base in `rs1` and use `imm` for the fixed offset from it.

### Branches (B-type) — opcode `0110`, selected by `funct3`

| Mnemonic | funct3 | Condition |
|---|---|---|
| BEQ | 000 | rs1 == rs2 |
| BNE | 001 | rs1 != rs2 |
| BLT | 100 | rs1 < rs2 (signed) |
| BGE | 101 | rs1 >= rs2 (signed) |
| BLTU | 110 | rs1 < rs2 (unsigned) |
| BGEU | 111 | rs1 >= rs2 (unsigned) |

Branch target: `PC = PC + imm` (signed offset). If the condition is false, execution falls through to `PC + 1` as normal.

### Jumps (J-type)

| Mnemonic | opcode | Operation |
|---|---|---|
| JAL rd, imm | 0111 | rd = PC + 1; PC = PC + imm |
| JALR rd, rs1, imm | 1000 (I-type layout) | rd = PC + 1; PC = rs1 + imm |

(unconditional jump with saved return)

### System / Misc

| Mnemonic | Notes |
|---|---|
| NOP | Encoded as `ADDI r0, r0, 0` — no dedicated opcode needed, since writes to `r0` are discarded |
| HALT | opcode `1111` — stops the clock cleanly in simulation/testbenches |

### Opcode Map

| opcode | Instruction(s) |
|---|---|
| 0000 | ADD / SUB / AND / OR / XOR / SLL / SRL / SRA (R-type, via funct3) |
| 0001 | SLT |
| 0010 | SLTU |
| 0011 | ADDI / ANDI / ORI / XORI / SLTI / SLTIU / SLLI / SRLI / SRAI (I-type, via funct3) |
| 0100 | LOAD |
| 0101 | STORE |
| 0110 | Branches (via funct3) |
| 0111 | JAL |
| 1000 | JALR |
| 1001–1110 | *Reserved for future expansion (I/O, interrupts, custom ops)* |
| 1111 | HALT |

### Design Notes

- **`r0` is hardwired to 0.** Any write to `r0` is discarded.
- **Immediates are sign-extended, not zero-extended**, before reaching the ALU — using zero-extension instead would corrupt negative values (e.g. a 6-bit `-2` would incorrectly become a large positive number in 8 bits).
- **Harvard architecture** instruction and data memory are separate modules with independent address/data ports — no risk of self-modifying code or instruction/data collisions, but the top-level design needs two memory instances instead of one.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
