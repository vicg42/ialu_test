rem Compile errors: https://stackoverflow.com/questions/75888393/does-iverilog-support-int-unsigned-of-systemverilog
set SIM_SOURCES=../../src/tb/scr1_pipe_ialu_tb.sv ../../src/core/pipeline/scr1_pipe_ialu.sv
set SIM_OPTIONS=-g2012 -I../../src/includes -DSCR1_IALU_SIM
iverilog %SIM_OPTIONS% -s scr1_pipe_ialu -o scr1_pipe_ialu_tb %SIM_SOURCES%
