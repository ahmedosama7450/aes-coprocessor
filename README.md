# AES Coprocessor

The coprocessor implements the 32-bit AES instructions, described in the [RISC-V scalar cryptography extensions v1.0.1](https://github.com/riscv/riscv-crypto/releases/download/v1.0.1-scalar/riscv-crypto-spec-scalar-v1.0.1.pdf).
The communication between the core and the coprocessor is based on the [extension interface protocol (cv-x-if)](https://docs.openhwgroup.org/projects/openhw-group-core-v-xif/en/latest/x_ext.html) and the implementation is tailored to the [CV32E40X](https://github.com/openhwgroup/cv32e40x) core.

## Folder structure
- `src`
  - `aes_coprocessor`: the coprocessor module which implements the interfaces of the `cv-x-if`.
  - `cv32e40x_core_with_aes`: The new core which integrates the CV32E40X core with the AES coprocessor.
  - `aes`: The implementations of the 32-bit AES instructions (`aes32esi`, `aes32esmi`, `aes32dsi`, `aes32dsmi`)
- `test`
  - `tb`: testbench of the core without AES
  - `tb_aes`: testbench of the core with AES
  - `tb_wrapper`: wrapper module, used by `tb` and `tb_aes`
  - `memory`: memory module that follows the [OBI protocol](https://docs.openhwgroup.org/projects/cv32e40x-user-manual/en/latest/load_store_unit.html#protocol)
  - `firmware_aes.mem`: the program run by the `tb_aes` testbench
  - `firmware_aes.txt`: same as `firmware_aes.mem` but includes the equivalent assembly instructions as comments, for clarification
  - `firmware.mem`: the program run by the `tb` testbench
  - `firmware.txt`: same as `firmware.mem` but includes the equivalent assembly instructions as comments, for clarification
  - `gen_firmware.py`: python script to remove the assembly instructions comments in the `firmware.txt` and `firmware_aes.txt` files

## Running the testbench

CV32E40X is added as a git submodule.
After cloning the repo, run the following command:

```
git submodule update --init --recursive
```

You can either run the `tb` or `tb_aes` testbenches. If you're using `QuestaSim` or `ModelSim`, you can import the `sim` folder, which directly adds all the modules to the project. There is also a `run.do` file that calls a `wave.do` file to directly configure the commonly used signals. 



