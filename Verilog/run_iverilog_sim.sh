#!/usr/bin/env bash
# Run IEEE802.11a RX chain testbench with Icarus Verilog (from Verilog/).
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v iverilog >/dev/null 2>&1; then
	echo "iverilog not found. Install: sudo apt install iverilog gtkwave"
	exit 1
fi

SRCS=(
	acs64.v
	butterfly_r2_dif.v
	clock_rst.v
	complex_mult.v
	cordic_arctan.v
	cordic_full_quadrant_arctan.v
	cordic_full_quadrant_sincos.v
	cordic_shift.v
	cordic_sincos.v
	divider.v
	divider_shift.v
	fft64_bit_reverse.v
	hanming_dis.v
	real_mult.v
	round_sat.v
	rx_coarse_foc.v
	rx_data_de_interleave.v
	rx_data_de_qam16.v
	rx_data_de_scramble.v
	rx_equalize.v
	rx_fft64_burst.v
	rx_fine_foc.v
	rx_fsm.v
	rx_packet_detect.v
	rx_phase_track.v
	rx_pilot_remove.v
	rx_pilot_scramble.v
	rx_pseudo_mac.v
	rx_remove_cp.v
	rx_signal_data_combine.v
	rx_signal_data_split.v
	rx_signal_de_bpsk.v
	rx_signal_de_interleave.v
	rx_signal_parse.v
	rx_symbol_sync.v
	rx_symbol_sync_corr.v
	rx_viterbi217.v
	traceback64_unit.v
	tb_ieee80211a_rx_top.v
)

echo "=== compile ==="
iverilog -g2012 -o sim_rx_top "${SRCS[@]}"

echo "=== simulate (timeout 120s) ==="
timeout 120 vvp sim_rx_top || {
	code=$?
	if [[ $code -eq 124 ]]; then
		echo "Simulation stopped after 120s (no \$finish in TB)."
	fi
	exit $code
}

echo "Done. Open waves: gtkwave dump.vcd  (if VCD was generated)"
