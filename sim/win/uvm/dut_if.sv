
`include "scr1_riscv_isa_decoding.svh"
`include "scr1_arch_description.svh"

interface dut_if (
    input bit clk,
    input bit rst_n
);

bit                               ialu_rvm_cmd_vd_i;

bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0]  ialu_cmd_i;
bit [`SCR1_XLEN-1:0]              ialu_main_op1_i;
bit [`SCR1_XLEN-1:0]              ialu_main_op2_i;
bit [`SCR1_XLEN-1:0]              ialu_addr_op1_i;
bit [`SCR1_XLEN-1:0]              ialu_addr_op2_i;

bit [`SCR1_XLEN-1:0]              ialu_main_res_o;
bit [`SCR1_XLEN-1:0]              ialu_addr_res_o;

bit                               ialu_cmp_res_o ;
bit                               ialu_rvm_res_rdy_o;

endinterface
