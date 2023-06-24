#-----------------------------------------------------------------------
# Author : v.halavachenka
#-----------------------------------------------------------------------

if [file exists work] {
    vdel -all
}
vlib work
#+define+SCR1_CFG_RV32IMC_MAX
vlog ../../src/core/pipeline/scr1_pipe_ialu.sv -sv +incdir+../../src/includes +define+SCR1_IALU_SIM
#vlog ../../src/tb/scr1_pipe_ialu_tb.sv -sv +incdir+../../src/includes
vlog ./uvm/dut_if.sv -sv
vlog ./uvm/dut_package.sv -sv
vlog ../../src/tb/scr1_pipe_ialu_tb_uvm.sv -sv +incdir+../../src/includes


#vsim -t 1ps -novopt +notimingchecks -lib work scr1_pipe_ialu_tb
vsim -t 1ps -novopt +notimingchecks -lib work +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_MEDIUM scr1_pipe_ialu_tb_uvm

do modelsim_tb_wave.do
view wave
#config wave -timelineunits us
view structure
view signals
run 1us