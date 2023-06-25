`ifndef DUT_SEQUENCE_ITEM_SV
`define DUT_SEQUENCE_ITEM_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

// `include "scr1_riscv_isa_decoding.svh"
class dut_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(dut_sequence_item);

    rand bit            alu_rvm_cmd_vd;
    rand bit [5-1:0]    alu_cmd       ;
    rand bit [32-1:0]   alu_main_op1  ;
    rand bit [32-1:0]   alu_main_op2  ;
    rand bit [32-1:0]   alu_addr_op1  ;
    rand bit [32-1:0]   alu_addr_op2  ;

    bit [32-1:0]        alu_main_result;
    bit [32-1:0]        alu_addr_result;

    bit                 alu_cmp_result;
    bit                 alu_rvm_res_rdy;

    //info about randomization-and-constraints:
    //https://verificationguide.com/systemverilog/systemverilog-randomization-and-constraints/

    constraint c_alu_cmd {
        alu_cmd inside {[4:4]};
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

    // `uvm_object_utils_begin(dut_sequence_item)
    //     `uvm_field_int(test_data,UVM_ALL_ON)
    //     `uvm_field_int(di_gap,UVM_ALL_ON)
    //     `uvm_field_int(di_i,UVM_ALL_ON)
    //     `uvm_field_int(do_o,UVM_ALL_ON)
    // `uvm_object_utils_end

    function new(string name = "dut_sequence_item");
        super.new(name);
    endfunction : new

    //display only input of dut_if
    function string display_i();
        return $sformatf("alu_cmd[%X]; main_op:%02d,%02d; addr_op:%02d,%02d",
                alu_cmd, alu_main_op1, alu_main_op2, alu_addr_op1, alu_addr_op2);
    endfunction : display_i

    //display only output of dut_if
    function string display_o();
        return $sformatf("alu_cmd[%X]; main_result:%02d; cmp_result:%02d; addr_result:%02d; rvm_res_rdy:%02d",
                alu_cmd, alu_main_result, alu_cmp_result, alu_addr_result, alu_rvm_res_rdy);
    endfunction : display_o

endclass : dut_sequence_item

//----------------------------------------------------------------------------------
// IMPLEMENTATION
//----------------------------------------------------------------------------------

`endif //DUT_SEQUENCE_ITEM_SV
