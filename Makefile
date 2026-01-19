#===============================================================================
# Makefile for Traffic Light Controller RTL Simulation
# Author: Thuong Nguyen
# Description: Build automation for Verilog HDL simulation using Icarus Verilog
#===============================================================================

#-------------------------------------------------------------------------------
# Tool Configuration
#-------------------------------------------------------------------------------
IVERILOG    := iverilog
VVP         := vvp
GTKWAVE     := gtkwave
VERILOG_STD := -g2012

#-------------------------------------------------------------------------------
# Directory Configuration
#-------------------------------------------------------------------------------
SRC_DIR     := src
TB_DIR      := tb
SIM_DIR     := sim

#-------------------------------------------------------------------------------
# File Configuration
#-------------------------------------------------------------------------------
# RTL Source Files
RTL_SRCS    := $(SRC_DIR)/top.v \
               $(SRC_DIR)/fsm.v \
               $(SRC_DIR)/second_counter.v \
               $(SRC_DIR)/light_counter.v \
               $(SRC_DIR)/decimal_split.v \
               $(SRC_DIR)/hex2seg.v \
               $(SRC_DIR)/counter_decoder.v

# Testbench Files
TB_SRCS     := $(TB_DIR)/test_bench.v

# Output Files
SIM_EXEC    := $(SIM_DIR)/sim.vvp
WAVE_FILE   := $(SIM_DIR)/wave.vcd

#-------------------------------------------------------------------------------
# Color Definitions for Terminal Output
#-------------------------------------------------------------------------------
COLOR_GREEN  := \033[0;32m
COLOR_YELLOW := \033[0;33m
COLOR_BLUE   := \033[0;34m
COLOR_RED    := \033[0;31m
COLOR_RESET  := \033[0m

#-------------------------------------------------------------------------------
# Default Target
#-------------------------------------------------------------------------------
.PHONY: all
all: compile run
	@echo "$(COLOR_GREEN)[INFO] Simulation completed successfully!$(COLOR_RESET)"

#-------------------------------------------------------------------------------
# Create Simulation Directory
#-------------------------------------------------------------------------------
$(SIM_DIR):
	@echo "$(COLOR_BLUE)[INFO] Creating simulation directory...$(COLOR_RESET)"
	@mkdir -p $(SIM_DIR)

#-------------------------------------------------------------------------------
# Compile Target
# Description: Compile all Verilog source files and testbench
#-------------------------------------------------------------------------------
.PHONY: compile
compile: $(SIM_DIR)
	@echo "$(COLOR_BLUE)[INFO] Compiling Verilog source files...$(COLOR_RESET)"
	@echo "$(COLOR_YELLOW)[CMD]  $(IVERILOG) $(VERILOG_STD) -o $(SIM_EXEC) $(RTL_SRCS) $(TB_SRCS)$(COLOR_RESET)"
	@$(IVERILOG) $(VERILOG_STD) -o $(SIM_EXEC) $(RTL_SRCS) $(TB_SRCS)
	@echo "$(COLOR_GREEN)[INFO] Compilation successful!$(COLOR_RESET)"

#-------------------------------------------------------------------------------
# Run Target
# Description: Execute simulation and generate VCD waveform file
#-------------------------------------------------------------------------------
.PHONY: run
run: $(SIM_EXEC)
	@echo "$(COLOR_BLUE)[INFO] Running simulation...$(COLOR_RESET)"
	@cd $(SIM_DIR) && $(VVP) sim.vvp
	@echo "$(COLOR_GREEN)[INFO] Simulation finished! Waveform saved to $(WAVE_FILE)$(COLOR_RESET)"

#-------------------------------------------------------------------------------
# Wave Target
# Description: Open GTKWave to view simulation waveform
#-------------------------------------------------------------------------------
.PHONY: wave
wave: $(WAVE_FILE)
	@echo "$(COLOR_BLUE)[INFO] Opening GTKWave waveform viewer...$(COLOR_RESET)"
	@$(GTKWAVE) $(WAVE_FILE) &

#-------------------------------------------------------------------------------
# Clean Target
# Description: Remove all generated simulation files
#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	@echo "$(COLOR_YELLOW)[INFO] Cleaning simulation directory...$(COLOR_RESET)"
	@rm -rf $(SIM_DIR)
	@rm -f wave.vcd
	@echo "$(COLOR_GREEN)[INFO] Clean completed!$(COLOR_RESET)"

#-------------------------------------------------------------------------------
# Lint Target
# Description: Check Verilog syntax without generating output
#-------------------------------------------------------------------------------
.PHONY: lint
lint:
	@echo "$(COLOR_BLUE)[INFO] Running Verilog syntax check...$(COLOR_RESET)"
	@$(IVERILOG) $(VERILOG_STD) -t null $(RTL_SRCS)
	@echo "$(COLOR_GREEN)[INFO] Syntax check passed!$(COLOR_RESET)"

#-------------------------------------------------------------------------------
# View Source Target
# Description: List all RTL source files
#-------------------------------------------------------------------------------
.PHONY: list
list:
	@echo "$(COLOR_BLUE)========================================$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)  RTL Source Files$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)========================================$(COLOR_RESET)"
	@for file in $(RTL_SRCS); do echo "  - $$file"; done
	@echo ""
	@echo "$(COLOR_BLUE)========================================$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)  Testbench Files$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)========================================$(COLOR_RESET)"
	@for file in $(TB_SRCS); do echo "  - $$file"; done

#-------------------------------------------------------------------------------
# Help Target
# Description: Display available Makefile targets
#-------------------------------------------------------------------------------
.PHONY: help
help:
	@echo ""
	@echo "$(COLOR_BLUE)================================================================================$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)  Traffic Light Controller - Makefile Help$(COLOR_RESET)"
	@echo "$(COLOR_BLUE)================================================================================$(COLOR_RESET)"
	@echo ""
	@echo "  $(COLOR_GREEN)Usage:$(COLOR_RESET) make [target]"
	@echo ""
	@echo "  $(COLOR_YELLOW)Available Targets:$(COLOR_RESET)"
	@echo ""
	@echo "    $(COLOR_GREEN)all$(COLOR_RESET)       - Execute complete simulation flow (compile + run)"
	@echo "    $(COLOR_GREEN)compile$(COLOR_RESET)   - Compile Verilog RTL and testbench files"
	@echo "    $(COLOR_GREEN)run$(COLOR_RESET)       - Run simulation and generate VCD waveform"
	@echo "    $(COLOR_GREEN)wave$(COLOR_RESET)      - Open GTKWave to view simulation waveform"
	@echo "    $(COLOR_GREEN)lint$(COLOR_RESET)      - Check Verilog syntax without simulation"
	@echo "    $(COLOR_GREEN)list$(COLOR_RESET)      - List all source and testbench files"
	@echo "    $(COLOR_GREEN)clean$(COLOR_RESET)     - Remove all generated simulation files"
	@echo "    $(COLOR_GREEN)help$(COLOR_RESET)      - Display this help message"
	@echo ""
	@echo "  $(COLOR_YELLOW)Quick Start:$(COLOR_RESET)"
	@echo ""
	@echo "    $$ make all          # Compile and run simulation"
	@echo "    $$ make wave         # View waveform in GTKWave"
	@echo "    $$ make clean        # Clean simulation outputs"
	@echo ""
	@echo "$(COLOR_BLUE)================================================================================$(COLOR_RESET)"
	@echo ""

#-------------------------------------------------------------------------------
# End of Makefile
#-------------------------------------------------------------------------------
