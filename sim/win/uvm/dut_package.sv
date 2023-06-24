`ifndef DUT_PKG_SV
`define DUT_PKG_SV

package dut_package;
    import uvm_pkg::*; // [UVM] package
    `include "uvm_macros.svh" // [UVM] package

    // `include "dut_sequence_item.svh"
    // `include "dut_sequencer.svh"
    // `include "dut_driver.svh"
    // `include "dut_monitor.svh"
    // `include "dut_scoreboard.svh"
    // `include "dut_agent.svh"
    // // `include "dut_agent_config.svh"
    // `include "dut_sequence.svh"
    // // `include "dut_env_config.svh"
    // `include "dut_env.svh"
    `include "dut_test.svh"

endpackage

`endif