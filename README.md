# Thesis: Hardware design for cryptanalysis
## Goals
* Implementing DES on FPGA

The implementation has been pipelined into 18 stages. This yields a negligible latency when the complete
runtime of the system is considered. The DES block can be paused and contains functionality for testing if
it functions correctly at runtime.

* Building a cryptanalysis framework around one DES module

The cryptanalytic framework consists of masks on the input messages and output ciphertexts of the DES block.
The results of this are XORed together. If the result is one, a counter is incremented.

* Extending the implementation to contain multiple of these blocks running in parallel

* Building a control framework from the PS

The processing system on the FPGA can be used to give commands to the PL and read out the results.

## TODO

* Make the control interactive
* Multi block implementation
