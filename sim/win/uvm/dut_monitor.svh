`ifndef DUT_MONITOR_SV
`define DUT_MONITOR_SV

class dut_monitor extends uvm_monitor;
    `uvm_component_utils(dut_monitor);

    virtual dut_if dut_if_h;
    dut_sequence_item seqi_rd;
    //info TLM: https://www.theartofverification.com/uvm-tlm-concepts/
    uvm_analysis_port #(dut_sequence_item) analysis_port_o;

    function new(string name = "dut_monitor", uvm_component parent = null);
        super.new(name, parent);
        analysis_port_o = new("analysis_port_o", this);
    endfunction : new

    function void build_phase(uvm_phase phase); // [UVM]
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("build_phase"), UVM_LOW)
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if_h", dut_if_h)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction : build_phase

    extern task run_phase(uvm_phase phase); // [UVM]

endclass : dut_monitor

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
task dut_monitor::run_phase(uvm_phase phase);
    forever @(posedge dut_if_h.clk) begin
        seqi_rd = dut_sequence_item::type_id::create("seqi_rd");

        seqi_rd.alu_cmd = dut_if_h.ialu_cmd_i;
        seqi_rd.alu_main_result = dut_if_h.ialu_main_res_o;
        seqi_rd.alu_cmp_result = dut_if_h.ialu_cmp_res_o;
        seqi_rd.alu_addr_result = dut_if_h.ialu_addr_res_o;
        seqi_rd.alu_rvm_res_rdy = dut_if_h.ialu_rvm_res_rdy_o;

        analysis_port_o.write(seqi_rd); // send seqi_rd to scoreboard
    end
endtask : run_phase

`endif