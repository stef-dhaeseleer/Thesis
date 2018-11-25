# Thesis: Hardware design for cryptanalysis
## Goals
* Implementing DES on FPGA

The implementation has been pipelined into 18 stages. This yields a negligible latency when the complete
runtime of the system is considered. The DES core can be paused and contains functionality for testing if
it functions correctly at runtime.

* Building a cryptanalysis framework around one DES module

The cryptanalytic framework consists of masks on the input messages and output ciphertexts of the DES core.
The results of this are XORed together. If the result is one, a counter is incremented.

* Extending the implementation to contain multiple of these cores running in parallel

Multiple version have been made. The best one uses separate clocks for the AXI (slow clock) and the DES core (fast clock).

* Building a control framework from the PS

The processing system on the FPGA can be used to give commands to the PL and read out the results. This is achieved by running Linux (petalinux) on the ARM core. Python function are used to control the logic in an interactive way.

## TODO

* Perform the classical linear attack on DES and report results
* Implement SIMON 64 bit, 128 key bits (44 rounds)
* Connect via a network interface for easier file updates