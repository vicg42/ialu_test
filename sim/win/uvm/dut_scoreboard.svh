`ifndef DUT_SCOREBOARD_SV
`define DUT_SCOREBOARD_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_sequence_item.svh"

`uvm_analysis_imp_decl(_i) // [UVM]
`uvm_analysis_imp_decl(_o) // [UVM]

class dut_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dut_scoreboard)

    //info TLM: https://www.theartofverification.com/uvm-tlm-concepts/
    uvm_analysis_imp_i #(dut_sequence_item, dut_scoreboard) analysis_port_i;
    uvm_analysis_imp_o #(dut_sequence_item, dut_scoreboard) analysis_port_o;
    dut_sequence_item queue_seqi_wr[$];
    dut_sequence_item queue_seqi_rd[$];

    function new (string name = "dut_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_port_i = new("analysis_port_i", this);
        analysis_port_o = new("analysis_port_o", this);
    endfunction : new

    function void build_phase(uvm_phase phase); // [UVM]
        super.build_phase(phase);
    endfunction

    extern virtual function void write_i(dut_sequence_item item);
    extern virtual function void write_o(dut_sequence_item item);
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void dut_scoreboard::write_i(dut_sequence_item item);
    // uvm_report_info("", $sformatf("sequence_item(i): %s", item.display_i));
    queue_seqi_wr.push_back(item);
endfunction

function void dut_scoreboard::write_o(dut_sequence_item item);
    dut_sequence_item seqi_wr;
    dut_sequence_item seqi_rd;

    // uvm_report_info("", $sformatf("sequence_item(o): %s", item.display_o));
    queue_seqi_rd.push_back(item);

    seqi_wr = queue_seqi_wr.pop_front();
    seqi_rd = queue_seqi_rd.pop_front();
    uvm_report_info("", $sformatf("sequence_item(ch): %s; main_result:%02d; addr_result:%02d",
                seqi_wr.display_i,
                seqi_rd.alu_main_result,
                seqi_rd.alu_addr_result));

endfunction

`endif //DUT_SCOREBOARD_SV