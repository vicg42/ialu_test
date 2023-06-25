`ifndef DUT_SEQUENCE_ITEM_O_SV
`define DUT_SEQUENCE_ITEM_O_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "scr1_riscv_isa_decoding.svh"
`include "scr1_arch_description.svh"

class dut_sequence_item_o extends uvm_sequence_item;
    `uvm_object_utils(dut_sequence_item_o);

    bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] alu_cmd;

    bit [`SCR1_XLEN-1:0]        alu_main_result;
    bit [`SCR1_XLEN-1:0]        alu_addr_result;

    bit                 alu_cmp_result;
    // bit                 alu_rvm_res_rdy;

    // `uvm_object_utils_begin(dut_sequence_item_o)
    //     `uvm_field_int(test_data,UVM_ALL_ON)
    //     `uvm_field_int(di_gap,UVM_ALL_ON)
    //     `uvm_field_int(di_i,UVM_ALL_ON)
    //     `uvm_field_int(do_o,UVM_ALL_ON)
    // `uvm_object_utils_end

    function new(string name = "dut_sequence_item_o");
        super.new(name);
    endfunction : new

    //display only output of dut_if
    function string display_o();
        return $sformatf("alu_cmd[%X]; main_result:%02d; cmp_result:%02d; addr_result:%02d",
                alu_cmd, alu_main_result, alu_cmp_result, alu_addr_result);
    endfunction : display_o

    function string get_str_alu_cmd(bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] alu_cmd);
        string str_alu_cmd;
        case (alu_cmd)
            SCR1_IALU_CMD_NONE : begin
                str_alu_cmd = "CMD_NONE";
            end
            SCR1_IALU_CMD_AND : begin
                str_alu_cmd = "CMD_AND";
            end
            SCR1_IALU_CMD_OR : begin
                str_alu_cmd = "CMD_OR";
            end
            SCR1_IALU_CMD_XOR : begin
                str_alu_cmd = "CMD_XOR";
            end
            SCR1_IALU_CMD_ADD : begin
                str_alu_cmd = "CMD_ADD";
            end
            SCR1_IALU_CMD_SUB : begin
                str_alu_cmd = "CMD_SUB";
            end
            SCR1_IALU_CMD_SUB_LT : begin
                str_alu_cmd = "CMD_SUB_LT";
            end
            SCR1_IALU_CMD_SUB_LTU : begin
                str_alu_cmd = "CMD_SUB_LTU";
            end
            SCR1_IALU_CMD_SUB_EQ : begin
                str_alu_cmd = "CMD_SUB_EQ";
            end
            SCR1_IALU_CMD_SUB_NE : begin
                str_alu_cmd = "CMD_SUB_NE";
            end
            SCR1_IALU_CMD_SUB_GE : begin
                str_alu_cmd = "CMD_SUB_GE";
            end
            SCR1_IALU_CMD_SUB_GEU : begin
                str_alu_cmd = "CMD_SUB_GEU";
            end
            SCR1_IALU_CMD_SLL : begin
                str_alu_cmd = "CMD_SLL";
            end
            SCR1_IALU_CMD_SRL : begin
                str_alu_cmd = "CMD_SRL";
            end
            SCR1_IALU_CMD_SRA : begin
                str_alu_cmd = "CMD_SRA";
            end
            // `ifdef SCR1_RVM_EXT
            // ,
            // SCR1_IALU_CMD_MUL     ,    // low(unsig(op1) * unsig(op2))
            // SCR1_IALU_CMD_MULHU   ,    // high(unsig(op1) * unsig(op2))
            // SCR1_IALU_CMD_MULHSU  ,    // high(op1 * unsig(op2))
            // SCR1_IALU_CMD_MULH    ,    // high(op1 * op2)
            // SCR1_IALU_CMD_DIV     ,    // op1 / op2
            // SCR1_IALU_CMD_DIVU    ,    // op1 u/ op2
            // SCR1_IALU_CMD_REM     ,    // op1 % op2
            // SCR1_IALU_CMD_REMU         // op1 u% op2
            // `endif  // SCR1_RVM_EXT
            default : begin
                str_alu_cmd = "BAD_CMD";
            end
        endcase
        return $sformatf("%s", str_alu_cmd);
    endfunction : get_str_alu_cmd

endclass : dut_sequence_item_o

//----------------------------------------------------------------------------------
// IMPLEMENTATION
//----------------------------------------------------------------------------------

`endif //DUT_SEQUENCE_ITEM_O_SV
