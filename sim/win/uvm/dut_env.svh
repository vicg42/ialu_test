`ifndef __DUT_ENV_SV__
`define __DUT_ENV_SV__

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_agent.svh"
`include "dut_scoreboard.svh"

class dut_env extends uvm_env;
    `uvm_component_utils(dut_env)

    dut_agent agent;
    dut_scoreboard scoreboard;

    function new(string name = "dut_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = dut_agent::type_id::create("agent", this);
        scoreboard = dut_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.driver.analysis_port_i.connect(scoreboard.analysis_port_i);
        agent.monitor.analysis_port_o.connect(scoreboard.analysis_port_o);
    endfunction

    // uvm_table_printer printer;
    // virtual function void end_of_elaboration_phase(uvm_phase phase);
    //     super.end_of_elaboration_phase(phase);
    //     printer = new();
    //     printer.knobs.depth = 3;
    //     begin
    //         uvm_report_server rs =uvm_report_server::get_server();
    //         rs.set_max_quit_count(1);
    //     end
    //     uvm_report_info(get_type_name(), $psprintf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW);
    // endfunction
endclass

`endif //__DUT_ENV_SV__
