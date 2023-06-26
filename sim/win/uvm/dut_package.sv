`ifndef __DUT_PKG_SV__
`define __DUT_PKG_SV__

package dut_package;
    import uvm_pkg::*; // [UVM] package
    `include "uvm_macros.svh" // [UVM] package

    `include "dut_sequence_item_o.svh"
    `include "dut_sequence_item_i.svh"
    `include "dut_sequencer.svh"
    `include "dut_driver.svh"
    `include "dut_monitor.svh"
    `include "dut_scoreboard.svh"
    `include "dut_agent.svh"
    `include "dut_sequence.svh"
    `include "dut_env.svh"
    `include "dut_test.svh"

endpackage

`endif //__DUT_PKG_SV__
