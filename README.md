# Crytographic Coprocessor
This is a fun project to develop a simple coprocessor that implements some crytographic algorithms, Specifically some of the ones in
the proposed RISC-V crypto extenion in the NIST Suite for RV32.
It will include the following instructions:
- aes32dsi (AES final round decrypt)
- aes32dsmi (AES middle round decrypt)
- aes32esi (AES final round encrypt)
- aes32esmi (AES  middle round encrypt)
- sha256sig0 (SHA2-256 Sigma0)
- sha256sum0 (SHA2-256 Sigma0)
- sha256sig1 (SHA2-256 Sigma1)
- sha256sig1 (SHA2-256 Sigma1) 

Along with some load instructions necessary to get data into the coprocessor:
- LUI (Load upper immediate)
- LLU (Load lower immediate)


## Communication
The coprocessor will be commasdunicated the AXI4 Lite bus, where the reads will read one of the 32 bit registers, and the write data will send an instruction to the coprocessor the execture and store in the coprocessor's register file.

The instruction formats will be:

- Loads (LUI, LLU): 
  - [ 31:21 ] opcode
  - [ 20:16 ] rs1
  - [ 15:0 ] imm
- R-Type(All instructions listed above)
  - [ 31:21 ] opcode
  - [ 20:16 ] rs1
  - [ 15:11 ] rs2
  - [ 10:0 ] imm

## Implementation
This project is primarily for me to learn the basics of busses and to implement some cool algorithms in hardware. It currently is not pipelined, but it could be pipelined using a 4 step pipeline:
Bus/Decode -> Register Read -> Execute -> Write Back
Since we don't have branching, it would be relatively easy to implement (Compared to a real CPU). It would just require some forwarding from WB -> RR and WB -> EX.
