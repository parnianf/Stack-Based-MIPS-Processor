# Stack-Based-MIPS-Processor
This is an implementation of a stack-based processor with multi-cycle architecture. This processor supports the following instructions:

* Arithmetic/Logical Instructions: add, sub, and, not
* Memory Reference Instruction: push, pop
* Control Flow Instructions: jmp, jz

Since there is a single memory for both instructions and data, we fill the upper part of the memory (first 7 indexes) with instructions and the lower part of the memory (last 4 indexes) with data. We have created four test files in order to fill the memory with desired values and test the processor's functionality.

Contributor: [Paria Khoshtab](https://github.com/Theparia/)
