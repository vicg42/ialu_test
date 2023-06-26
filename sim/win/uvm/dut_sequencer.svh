`ifndef __DUT_SEQUENCER_SV
`define __DUT_SEQUENCER_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_sequence_item_i.svh"

class dut_sequencer extends uvm_sequencer #(dut_sequence_item_i);
    `uvm_sequencer_utils(dut_sequencer)

    function new (string name = "dut_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : dut_sequencer

`endif //__DUT_SEQUENCER_SV
