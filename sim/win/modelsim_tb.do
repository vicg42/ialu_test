#-----------------------------------------------------------------------
# Author : v.halavachenka
#-----------------------------------------------------------------------

if [file exists work] {
    vdel -all
}
vlib work
#+define+SCR1_CFG_RV32IMC_MAX
vlog ../../hdl/scr1_pipe_ialu.sv -sv +incdir+../../hdl/includes +define+SCR1_IALU_SIM
vlog ../../tb/scr1_pipe_ialu_tb.sv -sv +incdir+../../hdl/includes

vsim -t 1ps -novopt +notimingchecks -lib work scr1_pipe_ialu_tb

do modelsim_tb_wave.do
view wave
#config wave -timelineunits us
view structure
view signals
run 1us