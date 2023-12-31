`ifndef __DUT_SEQUENCE_SV__
`define __DUT_SEQUENCE_SV__

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_sequence_item_i.svh"

//info how to write uvm sequence: https://verificationguide.com/uvm/uvm-sequence/#How_to_write_uvm_sequence

class dut_sequence extends uvm_sequence #(dut_sequence_item_i);
    `uvm_object_utils(dut_sequence);

    dut_sequence_item_i sequence_item_i;

    function new(string name = "dut_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        const int sequence_item_count = 300;
        int sequence_item_cnt = 0;
        repeat(sequence_item_count) begin
            //https://verificationguide.com/uvm/uvm-sequence/#UVM_Sequence_macros
            `uvm_create(sequence_item_i)
            assert(sequence_item_i.randomize());
            `uvm_send(sequence_item_i);
        end

    endtask : body

endclass : dut_sequence

`endif //__DUT_SEQUENCE_SV__
