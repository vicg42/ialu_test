`ifndef __DUT_SEQUENCE_ITEM_SV__
`define __DUT_SEQUENCE_ITEM_SV__

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
        };
    }

    constraint c_main_op1 {
        alu_main_op1 inside{[0:(2**`SCR1_XLEN)-1]};
    }

    constraint c_main_op2 {
        alu_main_op2 inside{[0:(2**`SCR1_XLEN)-1]};
    }

    constraint c_addr_op1 {
        alu_addr_op1 inside{[0:(2**`SCR1_XLEN)-1]};
    }

    constraint c_addr_op2 {
        alu_addr_op2 inside{[0:(2**`SCR1_XLEN)-1]};
    }

    constraint c_alu_rvm_cmd_vd {
        alu_rvm_cmd_vd inside{[0:1]};
    }

    function new(string name = "dut_sequence_item_i");
        super.new(name);
    endfunction : new

    function string print();
        return $sformatf("cmd[%X]; main_op:%Xd, %Xd; addr_op:%Xd, %Xd",
                alu_cmd, alu_main_op1, alu_main_op2, alu_addr_op1, alu_addr_op2);
    endfunction : print

endclass : dut_sequence_item_i

`endif //____DUT_SEQUENCE_ITEM_SV__
