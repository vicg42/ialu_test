`timescale 1ns / 1ps

`include "scr1_riscv_isa_decoding.svh"
`include "scr1_arch_description.svh"

module scr1_pipe_ialu_tb_uvm #(
);

bit clk_i = 1'b0;       // simple clock
always #5 clk_i = ~clk_i; // 100 MHz

bit rst_n_i = 1'b0;

// dut_if #(
//     .SCR1_XLEN(`SCR1_XLEN),
//     .SCR1_IALU_CMD_WIDTH($clog2(SCR1_IALU_CMD_ALL_NUM_E))
// ) dut_if_h(
//     .clk_i(clk_i),
//     .rst_n_i(rst_n_i)
// );
dut_if dut_if_h(
    .clk(clk_i),
    .rst_n(rst_n_i)
);

scr1_pipe_ialu dut (
`ifdef SCR1_RVM_EXT
    // Common
    .clk(dut_if_h.clk),                                   //input   // IALU clock
    .rst_n(dut_if_h.rst_n),                               //input   // IALU reset
    .exu2ialu_rvm_cmd_vd_i(dut_if_h.ialu_rvm_cmd_vd_i),   //input   // MUL/DIV command valid
    .ialu2exu_rvm_res_rdy_o(dut_if_h.ialu_rvm_res_rdy_o), //output  // MUL/DIV result ready
`endif // SCR1_RVM_EXT

    // Main adder
    .exu2ialu_main_op1_i(dut_if_h.ialu_main_op1_i),       //input   // main ALU 1st operand
    .exu2ialu_main_op2_i(dut_if_h.ialu_main_op2_i),       //input   // main ALU 2nd operand
    .exu2ialu_cmd_i     (dut_if_h.ialu_cmd_i),            //input   // IALU command
    .ialu2exu_main_res_o(dut_if_h.ialu_main_res_o),       //output  // main ALU result
    .ialu2exu_cmp_res_o (dut_if_h.ialu_cmp_res_o),        //output  // IALU comparison result

    // Address adder
    .exu2ialu_addr_op1_i(dut_if_h.ialu_addr_op1_i),       //input   // Address adder 1st operand
    .exu2ialu_addr_op2_i(dut_if_h.ialu_addr_op2_i),       //input   // Address adder 2nd operand
    .ialu2exu_addr_res_o(dut_if_h.ialu_addr_res_o)        //output  // Address adder result
);


import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses
import dut_package::*;  // connect our package

initial begin
    // // [UVM] pass interface to UVM database
    // uvm_config_db #(virtual dut_if #(
    //             .SCR1_XLEN(`SCR1_XLEN),
    //             .SCR1_IALU_CMD_WIDTH($clog2(SCR1_IALU_CMD_ALL_NUM_E))
    //             )
    //         )::set(null, "*", "dut_if_h", dut_if_h);
    // // [UVM] run test routine
    // run_test("dut_test");

    // [UVM] pass interface to UVM database
    uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if_h", dut_if_h);
    // [UVM] run test routine
    run_test("dut_test");
end

endmodule : scr1_pipe_ialu_tb_uvm
