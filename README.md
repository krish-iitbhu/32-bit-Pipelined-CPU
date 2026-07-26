# 🚀 5-Stage Pipelined MIPS32 Processor

> **Verilog HDL | RTL Design | Computer Architecture | NPTEL Guided Project**

A custom-designed **32-bit 5-stage pipelined MIPS32 processor** implemented in **Verilog HDL**. This project was developed as part of the **NPTEL course "Hardware Modeling using Verilog"** by **Prof. Indranil Sengupta**. The processor supports a subset of MIPS32 instructions and demonstrates pipelined execution with efficient handling of data, control, and structural hazards.

---

## 📖 Overview

This processor implements the classic **5-stage MIPS pipeline**:

```
Instruction Fetch (IF)
        ↓
Instruction Decode (ID)
        ↓
Execute (EX)
        ↓
Memory Access (MEM)
        ↓
Write Back (WB)
```

Each instruction advances one stage every clock cycle, allowing multiple instructions to execute concurrently and improving overall throughput.

---

## ✨ Features

- 32-bit MIPS32 Processor
- Fully pipelined 5-stage architecture
- Implemented entirely in Verilog HDL
- Supports **14 MIPS-style instructions**
- Handles:
  - Data Hazards
  - Control Hazards
  - Structural Hazards
- Separate Instruction & Data Memory
- Two-phase clocking architecture
- Register File with 32 General Purpose Registers
- Branch handling using pipeline flushing
- Synthesizable RTL Design

---

# 🏗 Pipeline Architecture

The processor follows the standard five pipeline stages.

| Stage | Function |
|-------|----------|
| **IF** | Fetch instruction and update Program Counter |
| **ID** | Decode instruction and read register operands |
| **EX** | Perform ALU operations / Address calculation |
| **MEM** | Read from or write to Data Memory |
| **WB** | Write result back to Register File |

---

# 📌 Supported Instruction Set

## R-Type Instructions

| Opcode | Instruction | Description |
|---------|------------|-------------|
| 000000 | ADD | Register Addition |
| 000001 | SUB | Register Subtraction |
| 000010 | AND | Bitwise AND |
| 000011 | OR | Bitwise OR |
| 000100 | SLT | Set Less Than |
| 000101 | MUL | Multiplication |

---

## I-Type Instructions

| Opcode | Instruction | Description |
|---------|------------|-------------|
| 001000 | LW | Load Word |
| 001001 | SW | Store Word |
| 001010 | ADDI | Add Immediate |
| 001011 | SUBI | Subtract Immediate |
| 001100 | SLTI | Set Less Than Immediate |
| 001101 | BNEQZ | Branch if Not Equal to Zero |
| 001110 | BEQZ | Branch if Equal to Zero |

---

## Special Instruction

| Opcode | Instruction | Description |
|---------|------------|-------------|
| 111111 | HLT | Halt Processor |

---

# ⚙ Hazard Handling

### 🔹 Data Hazards
- Managed using **two-phase clocking**.
- Pipeline stalling ensures operands are available before execution.

### 🔹 Control Hazards
- Branch decision performed in the **EX stage**.
- Taken branches flush instructions in IF and ID stages.

### 🔹 Structural Hazards
- Eliminated by using:
  - Separate Instruction and Data Memories
  - 2-read / 1-write Register File

---

# 🧠 Processor Organization

The design consists of:

- Program Counter (PC)
- Instruction Memory
- Data Memory
- Register File (32 × 32-bit)
- ALU
- Pipeline Registers
- Control Logic
- Sign Extension Unit

Pipeline registers include:

```
IF_ID_IR
IF_ID_NPC

ID_EX_IR
ID_EX_A
ID_EX_B
ID_EX_IMM

EX_MEM_IR
EX_MEM_ALUOut
EX_MEM_B

MEM_WB_IR
MEM_WB_ALUOut
MEM_WB_LMD
```

---
--


# 🚀 Future Improvements

- Data Forwarding Unit
- Hazard Detection Unit
- Jump and Jump-and-Link Instructions
- Branch Prediction
- Cache Memory
- Exception & Interrupt Handling
- Full MIPS32 ISA Support

---


## ⭐ If you found this project useful, consider giving it a star!
