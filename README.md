# Thesis: Hardware design for cryptanalysis
## Goals
* Implementing DES on FPGA

The implementation has been pipelined into 18 stages. This yields a negligible latency when the complete
runtime of the system is considered. The DES core can be paused during operation (present for testing purposes, not in use anymore since the testing logic has been removed to save space).

* Building a cryptanalysis framework around one DES module

The cryptanalytic framework consists of masks on the input messages and output ciphertexts of the DES core.
The results of this are XORed together. If the result is one, a counter is incremented.

* Extending the implementation to contain multiple of these cores running in parallel

Multiple version have been made. The best one uses separate clocks for the AXI (slow clock) and the DES core (fast clock).
In order not to generate too many AXI slaves in the design, 4 DES cores are connected to one AXI slave peripheral. This peripheral contains 8 registers (one of them indicates which core the CPU want to read/write to).

* Building a control framework from the PS

The processing system on the FPGA can be used to give commands to the PL and read out the results. This is achieved by running Linux (petalinux) on the ARM core. Python function are used to control the logic in an interactive way.

## Documentation
* Verilog code

The Verilog code itself has been documented. The structure of the HW will be shown in the Thesis and presentation as well for a high level overview of how all the blocks work together.

* Python code

The Python code to control the logic is also documented. A guide on how to use this code is also present.

* SD card files

Example files and template information for the SD card files can also be found.
