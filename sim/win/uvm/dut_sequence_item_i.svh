`ifndef DUT_SEQUENCE_ITEM_SV
`define DUT_SEQUENCE_ITEM_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "scr1_riscv_isa_decoding.svh"
`include "scr1_arch_description.svh"

class dut_sequence_item_i extends uvm_sequence_item;
    `uvm_object_utils(dut_sequence_item_i);

    rand bit                    alu_rvm_cmd_vd;
    rand bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] alu_cmd;
    rand bit [`SCR1_XLEN-1:0]   alu_main_op1  ;
    rand bit [`SCR1_XLEN-1:0]   alu_main_op2  ;
    rand bit [`SCR1_XLEN-1:0]   alu_addr_op1  ;
    rand bit [`SCR1_XLEN-1:0]   alu_addr_op2  ;

    //info about randomization-and-constraints:
    //https://verificationguide.com/systemverilog/systemverilog-randomization-and-constraints/

    constraint c_alu_cmd {
        alu_cmd inside {
        SCR1_IALU_CMD_NONE    ,    // IALU disable
        SCR1_IALU_CMD_AND     ,    // op1 & op2
        SCR1_IALU_CMD_OR      ,    // op1 | op2
        SCR1_IALU_CMD_XOR     ,    // op1 ^ op2
        SCR1_IALU_CMD_ADD     ,    // op1 + op2
        SCR1_IALU_CMD_SUB     ,    // op1 - op2
        SCR1_IALU_CMD_SUB_LT  ,    // op1 < op2
        SCR1_IALU_CMD_SUB_LTU ,    // op1 u< op2
        SCR1_IALU_CMD_SUB_EQ  ,    // op1 = op2
        SCR1_IALU_CMD_SUB_NE  ,    // op1 != op2
        SCR1_IALU_CMD_SUB_GE  ,    // op1 >= op2
        SCR1_IALU_CMD_SUB_GEU ,    // op1 u>= op2
        SCR1_IALU_CMD_SLL     ,    // op1 << op2
        SCR1_IALU_CMD_SRL     ,    // op1 >> op2
        SCR1_IALU_CMD_SRA          // op1 >>> op2
        `ifdef SCR1_RVM_EXT
        ,
        SCR1_IALU_CMD_MUL     ,    // low(unsig(op1) * unsig(op2))
        SCR1_IALU_CMD_MULHU   ,    // high(unsig(op1) * unsig(op2))
        SCR1_IALU_CMD_MULHSU  ,    // high(op1 * unsig(op2))
        SCR1_IALU_CMD_MULH    ,    // high(op1 * op2)
        SCR1_IALU_CMD_DIV     ,    // op1 / op2
        SCR1_IALU_CMD_DIVU    ,    // op1 u/ op2
        SCR1_IALU_CMD_REM     ,    // op1 % op2
        SCR1_IALU_CMD_REMU         // op1 u% op2
        `endif  // SCR1_RVM_EXT
        };
    }

    constraint c_main_op {
        alu_main_op1 inside{[1:15]};
        alu_main_op2 inside{[1:15]};
    }

    constraint c_addr_op {
        alu_addr_op1 inside{[1:15]};
        alu_addr_op2 inside{[1:15]};
    }

    constraint c_alu_rvm_cmd_vd {
        alu_rvm_cmd_vd inside{[0:1]};
    }

    // `uvm_object_utils_begin(dut_sequence_item_i)
    //     `uvm_field_int(test_data,UVM_ALL_ON)
    //     `uvm_field_int(di_gap,UVM_ALL_ON)
    //     `uvm_field_int(di_i,UVM_ALL_ON)
    //     `uvm_field_int(do_o,UVM_ALL_ON)
    // `uvm_object_utils_end

    function new(string name = "dut_sequence_item_i");
        super.new(name);
    endfunction : new

    //display only input of dut_if
    function string display_i();
        return $sformatf("alu_cmd[%X]; main_op:%02d,%02d; addr_op:%02d,%02d",
                alu_cmd, alu_main_op1, alu_main_op2, alu_addr_op1, alu_addr_op2);
    endfunction : display_i

endclass : dut_sequence_item_i

//----------------------------------------------------------------------------------
// IMPLEMENTATION
//----------------------------------------------------------------------------------

`endif //DUT_SEQUENCE_ITEM_SV
