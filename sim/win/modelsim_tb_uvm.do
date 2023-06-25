#-----------------------------------------------------------------------
# Author : v.halavachenka
#-----------------------------------------------------------------------

if [file exists work] {
    vdel -all
}
vlib work
#+define+SCR1_CFG_RV32IMC_MAX
vlog ../../src/core/pipeline/scr1_pipe_ialu.sv -sv +incdir+../../src/includes +define+SCR1_IALU_SIM
vlog ./uvm/dut_if.sv -sv
#vlog ./uvm/dut_package.sv -sv

vlog ./uvm/dut_sequence_item.svh -sv
vlog ./uvm/dut_sequencer.svh -sv
vlog ./uvm/dut_driver.svh -sv
vlog ./uvm/dut_monitor.svh -sv
vlog ./uvm/dut_scoreboard.svh -sv
vlog ./uvm/dut_agent.svh -sv
vlog ./uvm/dut_sequence.svh -sv
vlog ./uvm/dut_env.svh -sv
vlog ./uvm/dut_test.svh -sv
vlog ../../src/tb/scr1_pipe_ialu_tb_uvm.sv -sv +incdir+../../src/includes +incdir+./uvm

vsim -t 1ps -novopt +notimingchecks -lib work +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_MEDIUM scr1_pipe_ialu_tb_uvm

do modelsim_tb_uvm_wave.do
view wave
#config wave -timelineunits us
view structure
view signals
run 1us