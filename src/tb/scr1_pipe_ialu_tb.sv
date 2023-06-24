`timescale 1ns / 1ps

`include "scr1_riscv_isa_decoding.svh"
`include "scr1_arch_description.svh"

module scr1_pipe_ialu_tb #(
);

bit clk_i = 1'b0;       // simple clock
always #5 clk_i = ~clk_i; // 100 MHz

bit rst_n_i = 1'b0;

bit ialu_rvm_cmd_vd_i = 1'b0; // MUL/DIV command valid
logic ialu_rvm_res_rdy_o;     // MUL/DIV result ready

bit   [`SCR1_XLEN-1:0]      ialu_main_op1_i = 0; // main ALU 1st operand
bit   [`SCR1_XLEN-1:0]      ialu_main_op2_i = 0; // main ALU 2nd operand
type_scr1_ialu_cmd_sel_e    ialu_cmd_i = SCR1_IALU_CMD_NONE;      // IALU command
logic [`SCR1_XLEN-1:0]      ialu_main_res_o = 0; // main ALU result
logic                       ialu_cmp_res_o;  // IALU comparison result

bit   [`SCR1_XLEN-1:0]      ialu_addr_op1_i = 0; // Address adder 1st operand
bit   [`SCR1_XLEN-1:0]      ialu_addr_op2_i = 0; // Address adder 2nd operand
logic [`SCR1_XLEN-1:0]      ialu_addr_res_o; // Address adder result

scr1_pipe_ialu dut (
`ifdef SCR1_RVM_EXT
    // Common
    .clk(clk_i),                                 //input   // IALU clock
    .rst_n(rst_n_i),                             //input   // IALU reset
    .exu2ialu_rvm_cmd_vd_i(ialu_rvm_cmd_vd_i),   //input   // MUL/DIV command valid
    .ialu2exu_rvm_res_rdy_o(ialu_rvm_res_rdy_o), //output  // MUL/DIV result ready
`endif // SCR1_RVM_EXT

    // Main adder
    .exu2ialu_main_op1_i(ialu_main_op1_i),       //input   // main ALU 1st operand
    .exu2ialu_main_op2_i(ialu_main_op2_i),       //input   // main ALU 2nd operand
    .exu2ialu_cmd_i     (ialu_cmd_i),            //input   // IALU command
    .ialu2exu_main_res_o(ialu_main_res_o),       //output  // main ALU result
    .ialu2exu_cmp_res_o (ialu_cmp_res_o),        //output  // IALU comparison result

    // Address adder
    .exu2ialu_addr_op1_i(ialu_addr_op1_i),       //input   // Address adder 1st operand
    .exu2ialu_addr_op2_i(ialu_addr_op2_i),       //input   // Address adder 2nd operand
    .ialu2exu_addr_res_o(ialu_addr_res_o)        //output  // Address adder result
);

initial begin
    rst_n_i = 1'b1;

    ialu_cmd_i = SCR1_IALU_CMD_ADD;
    ialu_main_op1_i = `SCR1_XLEN'd8;
    ialu_main_op2_i = `SCR1_XLEN'd6;

    #100

    ialu_cmd_i = SCR1_IALU_CMD_ADD;
    ialu_main_op1_i = `SCR1_XLEN'd9;
    ialu_main_op2_i = `SCR1_XLEN'd1;

    #100

    ialu_cmd_i = SCR1_IALU_CMD_ADD;
    ialu_main_op1_i = `SCR1_XLEN'd10;
    ialu_main_op2_i = `SCR1_XLEN'd15;

end

endmodule : scr1_pipe_ialu_tb
