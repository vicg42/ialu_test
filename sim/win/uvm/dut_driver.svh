`ifndef DUT_DRIVER_SV
`define DUT_DRIVER_SV

class dut_driver extends uvm_driver #(dut_sequence_item);
    `uvm_component_utils(dut_driver)

    virtual dut_if dut_if_h;
    dut_sequence_item seqi_wr;
    //info TLM: https://www.theartofverification.com/uvm-tlm-concepts/
    uvm_analysis_port #(dut_sequence_item) analysis_port_i;

    function new (string name = "dut_driver", uvm_component parent = null);
        super.new(name, parent);
        analysis_port_i = new("analysis_port_i", this);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), $sformatf("build_phase"), UVM_LOW)
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if_h", dut_if_h)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    extern task run_phase(uvm_phase phase); // [UVM]
endclass : dut_driver

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
task dut_driver::run_phase(uvm_phase phase);
    dut_sequence_item seqi_wr_scoreboard;

    dut_if_h.ialu_cmd_i        = 0;
    dut_if_h.ialu_main_op1_i   = 0;
    dut_if_h.ialu_main_op2_i   = 0;
    dut_if_h.ialu_addr_op1_i   = 0;
    dut_if_h.ialu_addr_op2_i   = 0;
    dut_if_h.ialu_rvm_cmd_vd_i = 0;

    forever begin
        seq_item_port.get_next_item(seqi_wr); // Gets the seqi_wr from the sequence
        uvm_report_info("", $sformatf("sequence_item: %s", seqi_wr.display_i));

        @(posedge dut_if_h.clk);
        dut_if_h.ialu_cmd_i      = seqi_wr.alu_cmd     ;
        dut_if_h.ialu_main_op1_i = seqi_wr.alu_main_op1;
        dut_if_h.ialu_main_op2_i = seqi_wr.alu_main_op2;
        dut_if_h.ialu_addr_op1_i = seqi_wr.alu_addr_op1;
        dut_if_h.ialu_addr_op2_i = seqi_wr.alu_addr_op2;

        seqi_wr_scoreboard = dut_sequence_item::type_id::create("seqi_wr_scoreboard");
        seqi_wr_scoreboard = seqi_wr;
        analysis_port_i.write(seqi_wr_scoreboard);// send seqi_wr to scoreboard

        seq_item_port.item_done(); // Indicates that the seqi_wr has been consumed
    end
endtask : run_phase

`endif
