# SPI Master IP Core

## Overview

This project implements a modular SPI Master IP Core using Verilog HDL.

The design is organized into dedicated RTL blocks for SPI master control,
slave-select management, serial data shifting, and baud-rate generation.
The design is accompanied by dedicated Verilog testbenches for functional
verification.

## RTL Modules

The SPI Master IP Core consists of the following RTL modules:

- `top_spi_master_ip.v` - Top-level SPI Master IP Core
- `spi_slave_select_control.v` - Slave-select control logic
- `spi_shift_register.v` - Serial data shift-register logic
- `baudrate_generator.v` - Baud-rate generation logic

## Verification

The design includes dedicated Verilog testbenches for verification:

- `tb_SPI_top_module.v`
- `tb_APB_slave_interface.v`
- `tb_spi_slave_select_control.v`
- `tb_spi_shift_register.v`
- `tb_baudrate_generator.v`

## Project Structure

```text
SPI-Master-IP-Core/
│
├── README.md
│
├── RTL Modules
│   ├── top_spi_master_ip.v
│   ├── spi_slave_select_control.v
│   ├── spi_shift_register.v
│   └── baudrate_generator.v
│
└── Testbench
    ├── tb_SPI_top_module.v
    ├── tb_APB_slave_interface.v
    ├── tb_spi_slave_select_control.v
    ├── tb_spi_shift_register.v
    └── tb_baudrate_generator.v
