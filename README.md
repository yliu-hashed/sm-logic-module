[![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/yliu-hashed/sm-logic-module/total?style=for-the-badge)](https://github.com/yliu-hashed/sm-logic-module/releases)
[![Scrap Mechanic](https://img.shields.io/badge/for%20game-scrap%20mechanic-orange?style=for-the-badge)](https://store.steampowered.com/app/387990/)

# SM Logic Modules

This repository provides many prebuilt logic blueprints for the game Scrap Mechanic that are too tedious to create by hand. These modules are designed for players who spend hours building intricate, logical creations. These prebuilt modules can empower Pro players to create complex designs.

Disclaimer: This project is not associated with Axolot Games.

![A big pile of logic](resources/images/logic-pile.jpg)

# Module Types

Here is a glossary of different types of modules with the package:

* Binary Integer Math Modules
  * Addition
  * Multiplication
  * Division
  * Remainder
  * Square Root
  * Squaring
  * Comparison
  * Priority Encoder
* Binary Coded Decimal Modules
  * Converter between Binary and BCD
* Memory Devices
  * Timer Memory with multiple read ports
  * Triple-XOR-DFF-memory with multiple read and write ports

Most modules are combinational, but some are sequential. Each module type has variants. For example, we have 8, 16, 24, and 32-width multiplication modules that support truncated, unsigned, signed, and mixed-signed numbers. We have over 100 individual blueprints waiting for you to use.

# Using SM Logic Modules

The 100+ blueprints are packaged as a ZIP file. You can download it from the Release page. Each release also contains a PDF file in the ZIP package that serves as a datasheet of the individual modules.

# Generate Manually

## Install Dependencies

If you need to generate the blueprints, you only need SM-EDA.

1. [Install the SM-EDA Image](https://github.com/yliu-hashed/Scrap-Mechanic-EDA.git) via Docker.

If you need to generate the datasheet, you need to install many more programs.

2. [Install Swift](https://www.swift.org/download/). This is used to parse reports and generate datasheets.
3. [Install Asciidoctor](https://asciidoctor.org), Asciidoctor PDF, and Asciidoctor Diagram.
4. [Install Wavedrom](https://github.com/wavedrom/cli) via npm.

## Building

1. Download the source code of this repo via `git clone` or download it using your browser, and `cd` into it.
2. Run `make setup` to set up directories.
3. Run `make try-deps` to test some installed dependencies. This should not fail.
4. Run `make` to generate all blueprints.
    * By default, 4 threads are used. You can change the `NUM_CORES` variable to use 8 to use 8 cores, for example.
5. (Optionally) Run `make datasheet` to generate *DATASHEET.pdf*

Note: Even though this project uses Makefiles, regenerating the datasheet will not regenerate the blueprint. This is an explicitly chosen behavior, as it allows the datasheet to be generated with only a subset of the modules for testing purposes. If you changed a module and wish the datasheet to be updated, first run `make`, then `make datasheet`.

To generate an existing module with custom parameters, simply specify the desired blueprint name. For example, if you need an 11-bit flavor of **MUL SEQ TRUNC** (truncated sequential multiplication), simply run `make blueprints/mul_seq_trunc_11.json`.

# Licenses

Copyright (C) 2025 Yuanda Liu

This repo contains the software and associated resources to generate the blueprints and their datasheets. The content of this repo is licensed under [GPLv3](/LICENSE). This generator makes use of [Scrap Mechanic EDA](https://github.com/yliu-hashed/Scrap-Mechanic-EDA), another GPLv3 project.

The generated blueprints are licensed as [CC0](https://creativecommons.org/public-domain/cc0/), no rights reserved. You can use them in whatever way you see fit, but attribution is strongly encouraged.

The datasheets are licensed under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/). The datasheets contain copyrightable artworks and texts. You can create derived work that includes the datasheets for any purpose as long as you give appropriate attribution.
