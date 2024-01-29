# Custom Include for Synopsys VCS
include Makefile.vcs 

SHELL=/bin/bash -o pipefail
.SHELLFLAGS += -e

HDL_SRCS := $(shell find $(PWD)/core -name '*.sv')
HVL_SRCS := $(shell find $(PWD)/sim -name '*.sv')
SRCS := $(HDL_SRCS) $(HVL_SRCS)

export VCS_ARCH_OVERRIDE=linux
VCS_FLAGS= -full64 -lca -sverilog +lint=all,noNS -timescale=1ns/1ns -debug_acc+all -kdb -fsdb -suppress=LCA_FEATURES_ENABLED
INC_DIR=+incdir+$(PWD)/core +incdir+$(PWD)/sim

sim: $(SRCS)
	mkdir -p out/sim/
	cd out/sim && vcs $(VCS) $(SRCS) $(VCS_FLAGS) $(INC_DIR) -msg_config=../../vcs_warn.config -l compile.log -top top_tb -o top_tb

.PHONY: run_sim
run_sim: sim
	rm -f out/sim/dump.fsdb
	cp -rf core/config out/sim/config
	cd out/sim && ./top_tb $(SIMV) -l simulation.log

.PHONY: covrep
covrep: out/sim/top_tb.vdb
	cd out/sim && urg -dir top_tb.vdb

.PHONY: rom
rom: 
	cd core/config && rm -f rom/*.mif && python3 mif_gen.py

.PHONY: verdi 
verdi:
	mkdir -p out/verdi
	cd out/verdi && $(VERDI_HOME)/bin/verdi -ssf $(PWD)/out/sim/dump.fsdb

.PHONY: clean
clean:
	rm -rf out