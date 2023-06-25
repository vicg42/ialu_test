onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/rst_n
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/clk
add wave -noupdate -color {Slate Blue} -itemcolor Gold -radix symbolic /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_cmd_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_main_op1_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_main_op2_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb_uvm/dut/ialu2exu_main_res_o
add wave -noupdate -expand /scr1_pipe_ialu_tb_uvm/dut/main_sum_flags
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_addr_op1_i
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_addr_op2_i
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/ialu2exu_addr_res_o
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/exu2ialu_rvm_cmd_vd_i
add wave -noupdate /scr1_pipe_ialu_tb_uvm/dut/ialu2exu_rvm_res_rdy_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 387
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1071102 ps}
