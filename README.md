# RISC-V 32I 3-Stage Pipelined Processor (Formally Verified)

## Overview  
The **RISC-V RV32I** is a 32-bit reduced instruction set computing (RISC) processor that follows the **RV32I instruction set architecture (ISA)**. This project implements a **3-stage pipelined processor**, verified using a **formal testbench** to ensure correctness and efficiency.

## Features  
- **Implements all RV32I instruction types:** R, I, S, J, B, U (including JAL and JALR)  
- **Supports load/store operations:** Byte, Halfword, Word  
- **ALU operations:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND, LUI  
- **3-stage pipeline:** Fetch | Decode & Execute | Memory & Writeback  

## Makefile Instructions  

This project includes a **Makefile** for compiling, simulating, and displaying the processor's waveform.  

### **Prerequisites**  
Ensure that **QuestaSim** with **UVM 1.2** is installed and accessible in your system's **PATH**.  

## Usage

Use the following commands for Makefile:

- **Compile and Run UVM Testbench**
  ```bash
  make run_tb

- **Display Waveform**
  ```bash
  make wave

- **CLEAN_UP**
  ```bash
  make clean
