`ifndef __DUT_SEQUENCE_ITEM_O_SV__
`define __DUT_SEQUENCE_ITEM_O_SV__

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

    function new(string name = "dut_sequence_item_o");
        super.new(name);
    endfunction : new

    function string print();
        return $sformatf("cmd[%X]; main_result:%X; cmp_result:%X; addr_result:%X",
                alu_cmd, alu_main_result, alu_cmp_result, alu_addr_result);
    endfunction : print

    function string get_alu_cmd_name(bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] alu_cmd);
        string cmd_name;
        case (alu_cmd)
            SCR1_IALU_CMD_NONE    : begin cmd_name = "NONE   "; end
            SCR1_IALU_CMD_AND     : begin cmd_name = "AND    "; end
            SCR1_IALU_CMD_OR      : begin cmd_name = "OR     "; end
            SCR1_IALU_CMD_XOR     : begin cmd_name = "XOR    "; end
            SCR1_IALU_CMD_ADD     : begin cmd_name = "ADD    "; end
            SCR1_IALU_CMD_SUB     : begin cmd_name = "SUB    "; end
            SCR1_IALU_CMD_SUB_LT  : begin cmd_name = "SUB_LT "; end
            SCR1_IALU_CMD_SUB_LTU : begin cmd_name = "SUB_LTU"; end
            SCR1_IALU_CMD_SUB_EQ  : begin cmd_name = "SUB_EQ "; end
            SCR1_IALU_CMD_SUB_NE  : begin cmd_name = "SUB_NE "; end
            SCR1_IALU_CMD_SUB_GE  : begin cmd_name = "SUB_GE "; end
            SCR1_IALU_CMD_SUB_GEU : begin cmd_name = "SUB_GEU"; end
            SCR1_IALU_CMD_SLL     : begin cmd_name = "SLL    "; end
            SCR1_IALU_CMD_SRL     : begin cmd_name = "SRL    "; end
            SCR1_IALU_CMD_SRA     : begin cmd_name = "SRA    "; end
            // `ifdef SCR1_RVM_EXT
            // ,
            // SCR1_IALU_CMD_MUL     : begin cmd_name = "MUL   "; end
            // SCR1_IALU_CMD_MULHU   : begin cmd_name = "MULHU "; end
            // SCR1_IALU_CMD_MULHSU  : begin cmd_name = "MULHSU"; end
            // SCR1_IALU_CMD_MULH    : begin cmd_name = "MULH  "; end
            // SCR1_IALU_CMD_DIV     : begin cmd_name = "DIV   "; end
            // SCR1_IALU_CMD_DIVU    : begin cmd_name = "DIVU  "; end
            // SCR1_IALU_CMD_REM     : begin cmd_name = "REM   "; end
            // SCR1_IALU_CMD_REMU    : begin cmd_name = "REMU  "; end
            // `endif  // SCR1_RVM_EXT
            default : begin
                cmd_name = "BAD_CMD";
            end
        endcase
        return $sformatf("%s", cmd_name);
    endfunction : get_alu_cmd_name

endclass : dut_sequence_item_o

`endif //__DUT_SEQUENCE_ITEM_O_SV__
