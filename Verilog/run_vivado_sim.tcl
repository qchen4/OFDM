# Vivado batch sim — use: ./run_vivado_sim.sh
set src_dir [file normalize [pwd]]

if {[info exists ::env(SIM_BUILD_DIR)] && $::env(SIM_BUILD_DIR) ne ""} {
    set build_dir [file normalize $::env(SIM_BUILD_DIR)]
} else {
    set build_dir [file join $src_dir sim_build]
}

set part xc7z045ffg900-2

# exFAT (T7) cannot create symlinks — copy verify_txt into xsim run directory
proc install_verify_txt {dest src} {
    if {[file exists $dest]} {
        catch {exec rm -rf $dest}
    }
    exec cp -r $src $dest
    puts "Copied verify_txt: $src -> $dest"
}

file mkdir $build_dir
create_project -force ofdm_rx_sim $build_dir -part $part

foreach v [lsort [glob -nocomplain [file join $src_dir *.v]]] {
    add_files -norecurse $v
}

set_property top tb_ieee80211a_rx_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sources_1
set_property -name {xsim.simulate.runtime} -value {5ms} -objects [get_filesets sim_1]

if {[info exists ::env(DUMP_VCD)] && $::env(DUMP_VCD) ne ""} {
    set_property verilog_define {DUMP_VCD} [get_filesets sim_1]
    puts "VCD dump enabled -> xsim/rx_top.vcd (can be large)"
}
if {[info exists ::env(DUMP_WAVE)] && $::env(DUMP_WAVE) ne ""} {
    puts "WDB recording enabled (add_wave -recursive /)"
}

set verify_src [file join $src_dir verify_txt]
set xsim_dir [file join $build_dir ofdm_rx_sim.sim sim_1 behav xsim]
set verify_dest [file join $xsim_dir verify_txt]

puts "=== compile ==="
launch_simulation -step compile

puts "=== elaborate ==="
launch_simulation -step elaborate

if {![file isdirectory $xsim_dir]} {
    puts "ERROR: xsim dir missing: $xsim_dir"
    exit 1
}
install_verify_txt $verify_dest $verify_src

puts "=== simulate ==="
launch_simulation -step simulate

if {[info exists ::env(DUMP_WAVE)] && $::env(DUMP_WAVE) ne ""} {
    catch {add_wave -recursive /}
}

puts "=== run 5ms ==="
run 5ms

puts "=== done ==="
close_sim -force
exit
