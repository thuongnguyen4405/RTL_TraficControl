# Traffic Light Controller - Digital IC Design

[![Verilog](https://img.shields.io/badge/Language-Verilog%20HDL-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Simulation](https://img.shields.io/badge/Simulation-Icarus%20Verilog-orange.svg)](http://iverilog.icarus.com/)

## Overview

A synchronous digital traffic light controller implemented in **Verilog HDL** using **Finite State Machine (FSM)** methodology. This project demonstrates fundamental digital IC design concepts including RTL design, modular architecture, hardware timing control, and verification through simulation.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Module Description](#module-description)
- [Directory Structure](#directory-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Simulation Commands](#simulation-commands)
- [Waveform Analysis](#waveform-analysis)
- [Design Specifications](#design-specifications)
- [Technologies Used](#technologies-used)
- [Author](#author)

---

## Features

- **3-State FSM Controller**: GREEN → YELLOW → RED state transitions
- **Synchronous Design**: All state transitions are clock-edge triggered
- **Hardware Timing Counters**: Precise time-based state control
- **Modular RTL Architecture**: Reusable and maintainable design blocks
- **7-Segment Display Interface**: Real-time countdown visualization
- **Parameterized Timing**: Configurable light duration values
- **Full Testbench Coverage**: Comprehensive verification environment

---

## Architecture
<img width="1171" height="596" alt="image" src="https://github.com/user-attachments/assets/a523a790-6e4c-4f11-9657-794b62e97add" />
<img width="1132" height="631" alt="image" src="https://github.com/user-attachments/assets/7ab73422-56c9-4b01-b974-c5d285fd186f" />

---

## Module Description

| Module            | Description                                                    | Key I/O Ports                      |
|-------------------|----------------------------------------------------------------|------------------------------------|
| `top`             | Top-level integration module connecting all sub-modules        | clk, rst_n, en, lights, seg        |
| `fsm`             | Finite State Machine for traffic light control logic           | clk, rst_n, finish, pre_last       |
| `second_counter`  | Clock prescaler generating 1-second tick pulse                 | clk, rst_n, en, second_finish      |
| `light_counter`   | Countdown timer for current light duration                     | clk, rst_n, en, light_second       |
| `counter_decoder` | Display path integrating BCD converter and 7-seg decoder       | clk, rst_n, count, seg             |
| `decimal_split`   | Binary to BCD converter (tens and units digits)                | count, tens, units                 |
| `hex2seg`         | BCD to 7-segment display encoder (active-high)                 | hex, en, seg                       |
## Low Level of Block Design:
<img width="1172" height="609" alt="image" src="https://github.com/user-attachments/assets/c55b136c-095a-40ea-a992-cb2136f4b727" />
<img width="1133" height="633" alt="image" src="https://github.com/user-attachments/assets/de554baf-d227-4b1c-bbfb-792d36eee8c7" />
<img width="1200" height="578" alt="image" src="https://github.com/user-attachments/assets/1144c30f-e1d3-4cf7-b532-d9d8f3a33868" />
<img width="1114" height="675" alt="image" src="https://github.com/user-attachments/assets/21fb9e37-2891-4843-b4fe-be9721a29f66" />

---

## Directory Structure

```
traffic_light_rtl/
├── README.md                 # Project documentation
├── Makefile                  # Build automation for simulation
├── src/                      # RTL source files
│   ├── top.v                 # Top-level integration module
│   ├── fsm.v                 # Finite State Machine controller
│   ├── second_counter.v      # 1-second tick generator (prescaler)
│   ├── light_counter.v       # Light duration countdown timer
│   ├── counter_decoder.v     # Display decoder wrapper
│   ├── decimal_split.v       # Binary to BCD converter
│   └── hex2seg.v             # 7-segment display encoder
├── tb/                       # Testbench files
│   └── test_bench.v          # Main verification testbench
└── sim/                      # Simulation outputs (generated)
    ├── sim.vvp               # Compiled simulation executable
    └── wave.vcd              # Waveform dump file
```

---

## Prerequisites

### Required Tools (Linux Ubuntu)

```bash
# Update package list
sudo apt-get update

# Install Icarus Verilog (compiler & simulator)
sudo apt-get install -y iverilog

# Install GTKWave (waveform viewer)
sudo apt-get install -y gtkwave

# Verify installation
iverilog -v
gtkwave --version
```

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/thuongnguyen4405/TimerIP.git
cd traffic_light_rtl

# Compile and run simulation
make all

# View waveform results
make wave
```

---

## Simulation Commands

### Using Makefile (Recommended)

| Command         | Description                                          |
|-----------------|------------------------------------------------------|
| `make compile`  | Compile Verilog source files                         |
| `make run`      | Run simulation and generate VCD waveform             |
| `make wave`     | Open GTKWave to view simulation waveform             |
| `make all`      | Execute complete flow: compile → run                 |
| `make clean`    | Remove all generated simulation files                |
| `make help`     | Display available Makefile targets                   |

### Manual Commands

```bash
# Step 1: Compile RTL and testbench
iverilog -g2012 -o sim/sim.vvp \
    src/top.v \
    src/fsm.v \
    src/second_counter.v \
    src/light_counter.v \
    src/decimal_split.v \
    src/hex2seg.v \
    src/counter_decoder.v \
    tb/test_bench.v

# Step 2: Run simulation
cd sim && vvp sim.vvp

# Step 3: View waveform
gtkwave sim/wave.vcd
```

---

## Waveform Analysis

### Key Signals to Monitor

| Signal Group      | Signals                              | Purpose                              |
|-------------------|--------------------------------------|--------------------------------------|
| **Clock & Reset** | `clk`, `rst_n`, `en`                 | System control signals               |
| **FSM State**     | `current_state`, `next_state`        | State machine transitions            |
| **Light Outputs** | `green_light`, `yellow_light`, `red_light` | Traffic light control outputs  |
| **Timing**        | `second_finish`, `count`, `finish`   | Timer and countdown values           |
| **Display**       | `seg_tens[6:0]`, `seg_units[6:0]`    | 7-segment display outputs            |

### Expected Behavior

1. **GREEN State**: 18 seconds duration → `green_light = 1`
2. **YELLOW State**: 3 seconds duration → `yellow_light = 1`
3. **RED State**: 15 seconds duration → `red_light = 1`
4. **Total Cycle**: 36 seconds per complete cycle
### Expected Waveform for each module:
<img width="1225" height="380" alt="image" src="https://github.com/user-attachments/assets/fdda1115-db01-47b8-abd4-9333bad6fd74" />
<img width="1212" height="420" alt="image" src="https://github.com/user-attachments/assets/e13d4eef-3704-42aa-b161-3d0de5cc0d16" />
<img width="1211" height="387" alt="image" src="https://github.com/user-attachments/assets/e830408c-9690-440c-9951-9aa11e2a9f77" />
<img width="1217" height="630" alt="image" src="https://github.com/user-attachments/assets/ba735fcd-eed3-47b1-a737-408bbb9cd950" />

---

## Design Specifications

### Timing Parameters

| Parameter           | Value          | Description                         |
|---------------------|----------------|-------------------------------------|
| Clock Frequency     | 100 Hz         | System clock (simulation: 100 MHz)  |
| Prescaler Count     | 99 → 0         | Divides clock to 1-second tick      |
| GREEN Duration      | 18 seconds     | Green light active time             |
| YELLOW Duration     | 3 seconds      | Yellow light active time            |
| RED Duration        | 15 seconds     | Red light active time               |

### FSM State Encoding

| State   | Encoding (2-bit) | Output Pattern               |
|---------|------------------|------------------------------|
| GREEN   | `2'b01`          | `{G,Y,R} = {1,0,0}`          |
| YELLOW  | `2'b10`          | `{G,Y,R} = {0,1,0}`          |
| RED     | `2'b11`          | `{G,Y,R} = {0,0,1}`          |

### 7-Segment Display Encoding (Active-High)

```
    ─a─
   │   │
   f   b
   │   │
    ─g─
   │   │
   e   c
   │   │
    ─d─

Segment Order: seg[6:0] = {g, f, e, d, c, b, a}
```
Output Waveform: 
<img width="1292" height="554" alt="image" src="https://github.com/user-attachments/assets/935056b6-98e9-4d33-9151-05f3cf835d6d" />
<img width="1291" height="478" alt="image" src="https://github.com/user-attachments/assets/a286d79e-df16-41d0-a5a8-330b760774ea" />

---

## Technologies Used

- **Hardware Description Language**: Verilog HDL (IEEE 1364-2005)
- **Design Methodology**: RTL (Register Transfer Level)
- **Control Logic**: Finite State Machine (Mealy/Moore)
- **Simulation Tool**: Icarus Verilog
- **Waveform Viewer**: GTKWave
- **Build System**: GNU Make

---

## Author

**Thuong Nguyen**

- GitHub: [@thuongnguyen4405](https://github.com/thuongnguyen4405)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Digital IC Design principles and methodologies
- Verilog HDL coding standards and best practices
- Open-source EDA tools community
