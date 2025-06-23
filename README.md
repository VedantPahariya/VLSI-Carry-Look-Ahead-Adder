# VLSI-Carry-Look-Ahead-Adder

## Project Overview

Developed a complete 4-bit Carry Lookahead Adder (CLA) at transistor level with the following accomplishments:

- Designed optimal circuit topology with precise transistor sizing using Ngspice
- Performed post-layout simulation using Magic tool
- Implemented and verified functionality through Verilog and GtkWave simulation
- Successfully tested the design on FPGA hardware

This project demonstrates end-to-end digital circuit design from transistor-level implementation to hardware verification.

<!-- add the image of CLA post layout here -->
![CLA Post Layout](CLA%20Post%20Layout.png)

## Running the Project

To run the project, follow these steps:

1. **Open the Design in Magic**  
    Use the following command to open the file `clkcla.mag` in the Magic tool with the specified technology file `SCN6M_DEEP.09.tech27`:
    ```bash
    magic -T SCN6M_DEEP.09.tech27 clkcla.mag
    ```

2. **Extract the SPICE File**  
    Extract the SPICE file of the circuit designed in Magic using the following commands:
    ```bash
    Need to find out
    ```

3. **Simulate the Circuit in Ngspice**  
    ```bash
    python3 convert.py clkcla.spice clk.cir
    ```
    Using the Python script `convert.py`, this command converts the SPICE file `clkcla.spice` into a circuit file `clk.cir`.

    Run the following command to simulate the circuit using Ngspice:
    ```bash
    ngspice clk.cir
    ```