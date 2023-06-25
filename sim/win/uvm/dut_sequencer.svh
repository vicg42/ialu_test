`ifndef DUT_SEQUENCER_SV
`define DUT_SEQUENCER_SV

class dut_sequencer extends uvm_sequencer #(dut_sequence_item);
    `uvm_sequencer_utils(dut_sequencer)

    function new (string name = "dut_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : dut_sequencer

`endif
