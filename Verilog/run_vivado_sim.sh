#!/usr/bin/env bash
# Batch Vivado XSim (no GUI). Sim build defaults to /tmp (exFAT T7 cannot symlink).
set -euo pipefail
cd "$(dirname "$0")"

VIVADO="${VIVADO:-/opt/xilinx/2025.2/Vivado/bin/vivado}"
if [[ ! -x "$VIVADO" ]]; then
	echo "Vivado not found at $VIVADO"
	exit 1
fi

# Default sim artifacts on local disk (faster; avoids exFAT symlink limits on T7)
export SIM_BUILD_DIR="${SIM_BUILD_DIR:-/tmp/ofdm_rx_sim_${USER}}"

echo "Running Vivado sim in $(pwd) ..."
echo "SIM_BUILD_DIR=$SIM_BUILD_DIR"

WAVE_DIR="$(pwd)/waves"
mkdir -p "$WAVE_DIR"

# LIBRARY_PATH can break xelab (XSIM 43-3431)
env -u LIBRARY_PATH \
	${DUMP_VCD:+DUMP_VCD=1} \
	${DUMP_WAVE:+DUMP_WAVE=1} \
	"$VIVADO" -mode batch -notrace -nojournal -nolog -source run_vivado_sim.tcl

XSIM_DIR="$SIM_BUILD_DIR/ofdm_rx_sim.sim/sim_1/behav/xsim"
if [[ -f "$XSIM_DIR/tb_ieee80211a_rx_top_behav.wdb" ]]; then
	cp -f "$XSIM_DIR/tb_ieee80211a_rx_top_behav.wdb" "$WAVE_DIR/"
	echo "WDB: $WAVE_DIR/tb_ieee80211a_rx_top_behav.wdb"
fi
if [[ -f "$XSIM_DIR/rx_top.vcd" ]]; then
	cp -f "$XSIM_DIR/rx_top.vcd" "$WAVE_DIR/"
	echo "VCD: $WAVE_DIR/rx_top.vcd"
fi
