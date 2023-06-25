`ifndef DUT_SEQUENCE_SV
`define DUT_SEQUENCE_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_sequence_item.svh"

//info how to write uvm sequence: https://verificationguide.com/uvm/uvm-sequence/#How_to_write_uvm_sequence

class dut_sequence extends uvm_sequence #(dut_sequence_item);
    `uvm_object_utils(dut_sequence);

    dut_sequence_item sequence_item;

    function new(string name = "dut_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        const int sequence_item_count = 5;
        int sequence_item_cnt = 0;
        uvm_report_info("", $sformatf("body: #### sequence_item count:%03d ####", sequence_item_count));
        repeat(sequence_item_count) begin
            uvm_report_info("", $sformatf("body: sequence_item num[%03d]", sequence_item_cnt++));

            //https://verificationguide.com/uvm/uvm-sequence/#UVM_Sequence_macros
            `uvm_create(sequence_item)
            assert(sequence_item.randomize());
            `uvm_send(sequence_item);
        end

    endtask : body

endclass : dut_sequence

`endif //DUT_SEQUENCE_SV
