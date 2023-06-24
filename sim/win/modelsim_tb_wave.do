onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /scr1_pipe_ialu_tb/rst_n_i
add wave -noupdate /scr1_pipe_ialu_tb/clk_i
add wave -noupdate -color {Slate Blue} -itemcolor Gold -radix symbolic /scr1_pipe_ialu_tb/ialu_cmd_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb/ialu_main_op1_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb/ialu_main_op2_i
add wave -noupdate -radix decimal /scr1_pipe_ialu_tb/ialu_main_res_o
add wave -noupdate /scr1_pipe_ialu_tb/ialu_cmp_res_o
add wave -noupdate /scr1_pipe_ialu_tb/ialu_addr_op1_i
add wave -noupdate /scr1_pipe_ialu_tb/ialu_addr_op2_i
add wave -noupdate /scr1_pipe_ialu_tb/ialu_addr_res_o
add wave -noupdate /scr1_pipe_ialu_tb/ialu_rvm_cmd_vd_i
add wave -noupdate /scr1_pipe_ialu_tb/ialu_rvm_res_rdy_o
add wave -noupdate -expand /scr1_pipe_ialu_tb/dut/main_sum_flags
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {8753125 ps} {10065625 ps}
