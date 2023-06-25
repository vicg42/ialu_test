`ifndef DUT_TEST_SV
`define DUT_TEST_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_env.svh"
`include "dut_sequence.svh"

//info:
//http://cluelogic.com/2015/05/uvm-tutorial-for-candy-lovers-reporting-verbosity/

class dut_test extends uvm_test;
    `uvm_component_utils(dut_test)

    dut_env env;

    function new (string name = "dut_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    extern function void build_phase(uvm_phase phase); // [UVM]
    extern task run_phase(uvm_phase phase); // [UVM]

endclass : dut_test

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void dut_test::build_phase(uvm_phase phase);
    // `uvm_info(get_name(), $sformatf("build_phase"), UVM_LOW);
    env = dut_env::type_id::create("env", this);
endfunction : build_phase

task dut_test::run_phase(uvm_phase phase);
    dut_sequence seq;

    // `uvm_info(get_name(), $sformatf("enter in run_phase"), UVM_LOW);
    seq = dut_sequence::type_id::create("seq", this);
    phase.raise_objection(this); // [UVM] start sequence
    seq.start(env.agent.sequencer);
    phase.drop_objection(this); // [UVM] finish sequence

endtask : run_phase

`endif //DUT_TEST_SV