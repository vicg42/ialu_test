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
    bit                 alu_rvm_res_rdy;

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
        return $sformatf("alu_cmd[%X]; main_result:%02d; cmp_result:%02d; addr_result:%02d; rvm_res_rdy:%02d",
                alu_cmd, alu_main_result, alu_cmp_result, alu_addr_result, alu_rvm_res_rdy);
    endfunction : display_o

endclass : dut_sequence_item_o

//----------------------------------------------------------------------------------
// IMPLEMENTATION
//----------------------------------------------------------------------------------

`endif //DUT_SEQUENCE_ITEM_O_SV
