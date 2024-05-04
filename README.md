# AES Coprocessor

The coprocessor implements the 32-bit AES instructions, described in the [RISC-V scalar cryptography extensions v1.0.1](https://github.com/riscv/riscv-crypto/releases/download/v1.0.1-scalar/riscv-crypto-spec-scalar-v1.0.1.pdf).
The communication between the core and the coprocessor is based on the [extension interface protocol (cv-x-if)](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/en/latest/x_ext.html) and the implementation is tailored to the [CV32E40X](https://github.com/openhwgroup/cv32e40x) core.

## Contents
### `src` folder
| Module Name | Description |
|---|---|
| [aes_coprocessor.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/src/aes_coprocessor.sv) | The coprocessor module which implements the interfaces of the `cv-x-if`. |
| [cv32e40x_core_with_aes.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/src/cv32e40x_core_with_aes.sv) | The new core which integrates the CV32E40X core with the AES coprocessor. |
| [aes](https://github.com/ahmedosama7450/aes-coprocessor/tree/main/src/aes) | The implementations of the 32-bit AES instructions (`aes32esi`, `aes32esmi`, `aes32dsi`, `aes32dsmi`) |

### `test` folder
| Module Name | Description |
|---|---|
| [tb.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/tb.sv) | testbench of the core without AES |
| [tb_aes.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/tb_aes.sv) | testbench of the core with AES |
| [tb_wrapper.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/tb_wrapper.sv) | wrapper module, used by `tb` and `tb_aes` |
| [memory.sv](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/memory.sv) | memory module that follows the [OBI protocol](https://docs.openhwgroup.org/projects/cv32e40x-user-manual/en/latest/load_store_unit.html#protocol) |
| [firmware_aes.mem](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/firmware_aes.mem) | the program run by `tb_aes` testbench |
| [firmware_aes.txt](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/firmware_aes.txt) | same as `firmware_aes.mem` but includes the equivalent assembly instructions as comments, for clarification |
| [firmware.mem](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/firmware.mem) | the program run by `tb` testbench |
| [firmware.txt](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/firmware.txt) | same as `firmware.mem` but includes the equivalent assembly instructions as comments, for clarification |
| [gen_firmware.py](https://github.com/ahmedosama7450/aes-coprocessor/blob/main/test/gen_firmware.py) | python script to remove the assembly instructions comments in the `firmware.txt` and `firmware_aes.txt` files |

## Running the testbench

CV32E40X is added as a git submodule.
After cloning the repo, run the following command:

```
git submodule update --init --recursive
```
If you're using `QuestaSim` or `ModelSim`, you can import the `sim` folder, which directly adds all the modules to the project. There is also a `run.do` file that calls a `wave.do` file to directly configure the commonly used signals. 

You can either run the `tb` or `tb_aes` testbenches.

The `firmware_aes` contains a complete program that encrypts, then decrypts data using the AES instructions.

The data and key are assumed to be as follows: `DATA=0x00000001000000020000000300000004`, `KEY=0x000102030405060708090a0b0c0d0e0f`

## Coprocessor architecture

The coprocessor is composed of two pipeline stages:
### Instruction offloading
The instruction is offloaded to the coprocessor by [the issue interface](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/en/latest/x_ext.html#issue-interface). The instruction is decoded and the required information parts are extracted (`opcode`, `func3`, `func7`, `rd_id`, `bs`, `is_aes32`, `is_aes32dsi`, `is_aes32dsmi`, `is_aes32esi`, `is_aes32esmi`). Once the next pipeline stage (Instruction handling) is available, the issue handshake is performed. This tells the core that the coprocessor is ready to receive the next instruction.

### Instruction handling
In this stage, the coprocessor waits until the core sends [the commit interface](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/en/latest/x_ext.html#commit-interface) transaction. Once the the commit transaction is received and the instruction is to be committed (`commit_kill=0`), the [result interface](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/en/latest/x_ext.html#result-interface) transaction is sent by the coprocessor to the core.

## Implemented instructions


