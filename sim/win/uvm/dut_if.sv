
interface dut_if #(
    parameter SCR1_XLEN = 8,
    parameter SCR1_IALU_CMD_WIDTH = 8
) (
    input bit clk_i,
    input bit rst_n_i
);

bit                              ialu_rvm_cmd_vd_i ;
bit                              ialu_rvm_res_rdy_o;

bit [SCR1_XLEN-1:0]              ialu_main_op1_i;
bit [SCR1_XLEN-1:0]              ialu_main_op2_i;
bit [SCR1_IALU_CMD_WIDTH-1:0]    ialu_cmd_i     ;
bit [SCR1_XLEN-1:0]              ialu_main_res_o;
bit                              ialu_cmp_res_o ;

bit [SCR1_XLEN-1:0]              ialu_addr_op1_i;
bit [SCR1_XLEN-1:0]              ialu_addr_op2_i;
bit [SCR1_XLEN-1:0]              ialu_addr_res_o;

endinterface