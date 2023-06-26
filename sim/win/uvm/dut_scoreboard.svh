`ifndef DUT_SCOREBOARD_SV
`define DUT_SCOREBOARD_SV

import uvm_pkg::*;            // [UVM] package
`include "uvm_macros.svh"     // [UVM] macroses

`include "dut_sequence_item_i.svh"
`include "dut_sequence_item_o.svh"

`uvm_analysis_imp_decl(_i) // [UVM]
`uvm_analysis_imp_decl(_o) // [UVM]

class dut_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dut_scoreboard)

    //info TLM: https://www.theartofverification.com/uvm-tlm-concepts/
    uvm_analysis_imp_i #(dut_sequence_item_i, dut_scoreboard) analysis_port_i;
    uvm_analysis_imp_o #(dut_sequence_item_o, dut_scoreboard) analysis_port_o;
    dut_sequence_item_i queue_seqi_wr[$];
    dut_sequence_item_o queue_seqi_rd[$];
    int test_failed_cnt = 0;

    function new (string name = "dut_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_port_i = new("analysis_port_i", this);
        analysis_port_o = new("analysis_port_o", this);
    endfunction : new

    function void build_phase(uvm_phase phase); // [UVM]
        super.build_phase(phase);
    endfunction

    function void check_phase(uvm_phase phase); // [UVM]
        super.check_phase(phase);
        if (test_failed_cnt != 0) begin
            `uvm_error("", "TEST - FAILED");
        end else begin
            `uvm_info("", "TEST - PASSED", UVM_NONE);
        end
    endfunction

    extern virtual function void write_i(dut_sequence_item_i item);
    extern virtual function void write_o(dut_sequence_item_o item);
    extern virtual function void check_data(dut_sequence_item_i seqi_wr, dut_sequence_item_o seqi_rd);

    extern virtual function bit [`SCR1_XLEN-1:0] predicted_alu_main_result_calc(dut_sequence_item_i seqi_wr);
    extern virtual function bit predicted_alu_cmp_result_calc(dut_sequence_item_i seqi_wr);
    extern virtual function bit [`SCR1_XLEN-1:0] predicted_alu_addr_result_calc(dut_sequence_item_i seqi_wr);


endclass : dut_scoreboard

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function void dut_scoreboard::write_i(dut_sequence_item_i item);
    // uvm_report_info("", $sformatf("sequence_item(i): %s", item.display_i));
    queue_seqi_wr.push_back(item);
endfunction : write_i

function void dut_scoreboard::write_o(dut_sequence_item_o item);
    dut_sequence_item_i seqi_wr;
    dut_sequence_item_o seqi_rd;

    queue_seqi_rd.push_back(item);

    seqi_wr = queue_seqi_wr.pop_front();
    seqi_rd = queue_seqi_rd.pop_front();

    check_data(seqi_wr, seqi_rd);

endfunction : write_o


function void dut_scoreboard::check_data(dut_sequence_item_i seqi_wr, dut_sequence_item_o seqi_rd);
    // uvm_report_info("", $sformatf("sequence_item(ch): %s; main_result:%02d; addr_result:%02d",
    //         seqi_wr.display_i, seqi_rd.alu_main_result, seqi_rd.alu_addr_result)
    // );

    bit [`SCR1_XLEN-1:0] predicted_alu_main_result;
    bit predicted_alu_cmp_result;
    bit [`SCR1_XLEN-1:0] predicted_alu_addr_result;

    predicted_alu_main_result = predicted_alu_main_result_calc(seqi_wr);
    predicted_alu_cmp_result = predicted_alu_cmp_result_calc(seqi_wr);
    predicted_alu_addr_result = predicted_alu_addr_result_calc(seqi_wr);

    if ((predicted_alu_main_result != seqi_rd.alu_main_result) ||
        (predicted_alu_cmp_result != seqi_rd.alu_cmp_result) ||
        (predicted_alu_addr_result != seqi_rd.alu_addr_result)) begin

        if (predicted_alu_main_result != seqi_rd.alu_main_result) begin
            `uvm_error("FAILED - alu_main_result",
                        $sformatf("predicted_data: %X; seqi_rd: %X",
                        predicted_alu_main_result, seqi_rd.alu_main_result)
                    );
        end

        if (predicted_alu_cmp_result != seqi_rd.alu_cmp_result) begin
            `uvm_error("FAILED - alu_cmp_result",
                        $sformatf("predicted_data: %X; seqi_rd: %X",
                        predicted_alu_cmp_result, seqi_rd.alu_cmp_result)
                    );
        end

        if (predicted_alu_addr_result != seqi_rd.alu_addr_result) begin
            `uvm_error("FAILED - alu_addr_result",
                        $sformatf("predicted_data: %X; seqi_rd: %X",
                        predicted_alu_addr_result, seqi_rd.alu_addr_result)
                    );
        end
        test_failed_cnt++;

    end else begin
        `uvm_info("PASSED", $sformatf("ALU_CMD [%s]", seqi_rd.get_alu_cmd_name(seqi_rd.alu_cmd)), UVM_NONE);
    end

endfunction : check_data


function bit [`SCR1_XLEN-1:0] dut_scoreboard::predicted_alu_main_result_calc(dut_sequence_item_i seqi_wr);

    typedef struct packed {
        logic       z;      // Zero
        logic       s;      // Sign
        logic       o;      // Overflow
        logic       c;      // Carry
    } type_scr1_ialu_flags_s;

    // Main adder
    bit             [`SCR1_XLEN-1:0]          exu2ialu_main_op1_i;        // main ALU 1st operand
    bit             [`SCR1_XLEN-1:0]          exu2ialu_main_op2_i;        // main ALU 2nd operand
    bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] exu2ialu_cmd_i;             // IALU command
    bit             [`SCR1_XLEN-1:0]          ialu2exu_main_res_o;        // main ALU result
    bit                                       ialu2exu_cmp_res_o;         // IALU comparison result

    // Address adder
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op1_i;        // Address adder 1st operand
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op2_i;        // Address adder 2nd operand
    bit             [`SCR1_XLEN-1:0]          ialu2exu_addr_res_o;        // Address adder result

    // Shifter signals
    bit                                       ialu_cmd_shft;      // IALU command is shift
    bit signed [`SCR1_XLEN-1:0]               shft_op1;           // SHIFT operand 1
    bit        [4:0]                          shft_op2;           // SHIFT operand 2
    bit        [1:0]                          shft_cmd;           // SHIFT command: 00 - logical left, 10 - logical right, 11 - arithmetical right
    bit        [`SCR1_XLEN-1:0]               shft_res;           // SHIFT result

    // Main adder signals
    bit        [`SCR1_XLEN:0]                 main_sum_res;       // Main adder result
    type_scr1_ialu_flags_s                      main_sum_flags;     // Main adder flags
    bit                                       main_sum_pos_ovflw; // Main adder positive overflow
    bit                                       main_sum_neg_ovflw; // Main adder negative overflow
    bit                                       main_ops_diff_sgn;  // Main adder operands have different signs
    bit                                       main_ops_non_zero;  // Both main adder operands are NOT 0

    //set input
    exu2ialu_cmd_i = seqi_wr.alu_cmd;
    exu2ialu_main_op1_i = seqi_wr.alu_main_op1;
    exu2ialu_main_op2_i = seqi_wr.alu_main_op2;
    exu2ialu_addr_op1_i = seqi_wr.alu_addr_op1;
    exu2ialu_addr_op2_i = seqi_wr.alu_addr_op2;

//-------------------------------------------------------------------------------
// Shift logic
//-------------------------------------------------------------------------------
 //
 // Shift logic supports the following types of shift operations:
 // - Logical left shift      (SLLI/SLL)
 // - Logical right shift     (SRLI/SRL)
 // - Arithmetic right shift  (SRAI/SRA)
//
    //assign
    ialu_cmd_shft = (exu2ialu_cmd_i == SCR1_IALU_CMD_SLL)
                        | (exu2ialu_cmd_i == SCR1_IALU_CMD_SRL)
                        | (exu2ialu_cmd_i == SCR1_IALU_CMD_SRA);
    // assign
    shft_cmd      = ialu_cmd_shft
                        ? {(exu2ialu_cmd_i != SCR1_IALU_CMD_SLL),
                            (exu2ialu_cmd_i == SCR1_IALU_CMD_SRA)}
                        : 2'b00;

    // always_comb begin
        shft_op1 = exu2ialu_main_op1_i;
        shft_op2 = exu2ialu_main_op2_i[4:0];
        case (shft_cmd)
            2'b10   : shft_res = shft_op1  >> shft_op2;
            2'b11   : shft_res = shft_op1 >>> shft_op2;
            default : shft_res = shft_op1  << shft_op2;
        endcase
    // end

//-------------------------------------------------------------------------------
// Main adder
//-------------------------------------------------------------------------------
//
 // Main adder is used for the following types of operations:
 // - Addition/subtraction          (ADD/ADDI/SUB)
 // - Branch comparisons            (BEQ/BNE/BLT(U)/BGE(U))
 // - Arithmetic comparisons        (SLT(U)/SLTI(U))
//

// Carry out (MSB of main_sum_res) is evaluated correctly because the result
// width equals to the maximum width of both the right-hand and left-hand side variables
        // always_comb begin
            main_sum_res = (exu2ialu_cmd_i != SCR1_IALU_CMD_ADD)
                         ? ({1'b0, exu2ialu_main_op1_i} - {1'b0, exu2ialu_main_op2_i})   // Subtraction and comparison
                         : ({1'b0, exu2ialu_main_op1_i} + {1'b0, exu2ialu_main_op2_i});  // Addition

            main_sum_pos_ovflw = ~exu2ialu_main_op1_i[`SCR1_XLEN-1]
                               &  exu2ialu_main_op2_i[`SCR1_XLEN-1]
                               &  main_sum_res[`SCR1_XLEN-1];
            main_sum_neg_ovflw =  exu2ialu_main_op1_i[`SCR1_XLEN-1]
                               & ~exu2ialu_main_op2_i[`SCR1_XLEN-1]
                               & ~main_sum_res[`SCR1_XLEN-1];

            // FLAGS1 - flags for comparison (result of subtraction)
            main_sum_flags.c = main_sum_res[`SCR1_XLEN];
            main_sum_flags.z = ~|main_sum_res[`SCR1_XLEN-1:0];
            main_sum_flags.s = main_sum_res[`SCR1_XLEN-1];
            main_sum_flags.o = main_sum_pos_ovflw | main_sum_neg_ovflw;
        // end

//-------------------------------------------------------------------------------
// Operation result forming
//-------------------------------------------------------------------------------

            // always_comb begin
                ialu2exu_main_res_o    = '0;
                ialu2exu_cmp_res_o     = 1'b0;
            // `ifdef SCR1_RVM_EXT
            //     ialu2exu_rvm_res_rdy_o = 1'b1;
            // `endif // SCR1_RVM_EXT

                case (exu2ialu_cmd_i)
                    SCR1_IALU_CMD_AND : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i & exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_OR : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i | exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_XOR : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i ^ exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_ADD : begin
                        ialu2exu_main_res_o = main_sum_res[`SCR1_XLEN-1:0];
                    end
                    SCR1_IALU_CMD_SUB : begin
                        ialu2exu_main_res_o = main_sum_res[`SCR1_XLEN-1:0];
                    end
                    SCR1_IALU_CMD_SUB_LT : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.s ^ main_sum_flags.o);
                        ialu2exu_cmp_res_o  = main_sum_flags.s ^ main_sum_flags.o;
                    end
                    SCR1_IALU_CMD_SUB_LTU : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.c);
                        ialu2exu_cmp_res_o  = main_sum_flags.c;
                    end
                    SCR1_IALU_CMD_SUB_EQ : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.z);
                        ialu2exu_cmp_res_o  = main_sum_flags.z;
                    end
                    SCR1_IALU_CMD_SUB_NE : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~main_sum_flags.z);
                        ialu2exu_cmp_res_o  = ~main_sum_flags.z;
                    end
                    SCR1_IALU_CMD_SUB_GE : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~(main_sum_flags.s ^ main_sum_flags.o));
                        ialu2exu_cmp_res_o  = ~(main_sum_flags.s ^ main_sum_flags.o);
                    end
                    SCR1_IALU_CMD_SUB_GEU : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~main_sum_flags.c);
                        ialu2exu_cmp_res_o  = ~main_sum_flags.c;
                    end
                    SCR1_IALU_CMD_SLL,
                    SCR1_IALU_CMD_SRL,
                    SCR1_IALU_CMD_SRA: begin
                        ialu2exu_main_res_o = shft_res;
                    end
            // `ifdef SCR1_RVM_EXT
            //         SCR1_IALU_CMD_MUL,
            //         SCR1_IALU_CMD_MULHU,
            //         SCR1_IALU_CMD_MULHSU,
            //         SCR1_IALU_CMD_MULH : begin
            //  `ifdef SCR1_FAST_MUL
            //             ialu2exu_main_res_o = mul_cmd_hi
            //                                 ? mul_res[SCR1_MUL_RES_WIDTH-1:`SCR1_XLEN]
            //                                 : mul_res[`SCR1_XLEN-1:0];
            //  `else // ~SCR1_FAST_MUL
            //             case (mdu_fsm_ff)
            //                 SCR1_IALU_MDU_FSM_IDLE : begin
            //                     ialu2exu_main_res_o    = '0;
            //                     ialu2exu_rvm_res_rdy_o = ~mdu_iter_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_ITER : begin
            //                     ialu2exu_main_res_o    = mul_cmd_hi ? mul_res_hi : mul_res_lo;
            //                     ialu2exu_rvm_res_rdy_o = mdu_iter_rdy;
            //                 end
            //             endcase
            //  `endif // ~SCR1_FAST_MUL
            //         end
            //         SCR1_IALU_CMD_DIV,
            //         SCR1_IALU_CMD_DIVU,
            //         SCR1_IALU_CMD_REM,
            //         SCR1_IALU_CMD_REMU : begin
            //             case (mdu_fsm_ff)
            //                 SCR1_IALU_MDU_FSM_IDLE : begin
            //                     ialu2exu_main_res_o    = (|exu2ialu_main_op2_i | div_cmd_rem)
            //                                            ? exu2ialu_main_op1_i
            //                                            : '1;
            //                     ialu2exu_rvm_res_rdy_o = ~mdu_iter_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_ITER : begin
            //                     ialu2exu_main_res_o    = div_cmd_rem ? div_res_rem : div_res_quo;
            //                     ialu2exu_rvm_res_rdy_o = mdu_iter_rdy & ~mdu_corr_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_CORR : begin
            //                     ialu2exu_main_res_o    = div_cmd_rem
            //                                            ? mdu_sum_res[`SCR1_XLEN-1:0]
            //                                            : -mdu_res_lo_ff[`SCR1_XLEN-1:0];
            //                     ialu2exu_rvm_res_rdy_o = 1'b1;
            //                 end
            //             endcase
            //         end
            // `endif // SCR1_RVM_EXT
            //         default : begin end
                endcase

            // end

    return ialu2exu_main_res_o;
endfunction : predicted_alu_main_result_calc



function bit dut_scoreboard::predicted_alu_cmp_result_calc(dut_sequence_item_i seqi_wr);
    // dut_sequence_item_o predicted_result;

    typedef struct packed {
        logic       z;      // Zero
        logic       s;      // Sign
        logic       o;      // Overflow
        logic       c;      // Carry
    } type_scr1_ialu_flags_s;

    // Main adder
    bit             [`SCR1_XLEN-1:0]          exu2ialu_main_op1_i;        // main ALU 1st operand
    bit             [`SCR1_XLEN-1:0]          exu2ialu_main_op2_i;        // main ALU 2nd operand
    bit [$bits(type_scr1_ialu_cmd_sel_e)-1:0] exu2ialu_cmd_i;             // IALU command
    bit             [`SCR1_XLEN-1:0]          ialu2exu_main_res_o;        // main ALU result
    bit                                       ialu2exu_cmp_res_o;         // IALU comparison result

    // Address adder
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op1_i;        // Address adder 1st operand
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op2_i;        // Address adder 2nd operand
    bit             [`SCR1_XLEN-1:0]          ialu2exu_addr_res_o;        // Address adder result

    // Shifter signals
    bit                                       ialu_cmd_shft;      // IALU command is shift
    bit signed [`SCR1_XLEN-1:0]               shft_op1;           // SHIFT operand 1
    bit        [4:0]                          shft_op2;           // SHIFT operand 2
    bit        [1:0]                          shft_cmd;           // SHIFT command: 00 - logical left, 10 - logical right, 11 - arithmetical right
    bit        [`SCR1_XLEN-1:0]               shft_res;           // SHIFT result

    // Main adder signals
    bit        [`SCR1_XLEN:0]                 main_sum_res;       // Main adder result
    type_scr1_ialu_flags_s                      main_sum_flags;     // Main adder flags
    bit                                       main_sum_pos_ovflw; // Main adder positive overflow
    bit                                       main_sum_neg_ovflw; // Main adder negative overflow
    bit                                       main_ops_diff_sgn;  // Main adder operands have different signs
    bit                                       main_ops_non_zero;  // Both main adder operands are NOT 0

    //set input
    exu2ialu_cmd_i = seqi_wr.alu_cmd;
    exu2ialu_main_op1_i = seqi_wr.alu_main_op1;
    exu2ialu_main_op2_i = seqi_wr.alu_main_op2;
    exu2ialu_addr_op1_i = seqi_wr.alu_addr_op1;
    exu2ialu_addr_op2_i = seqi_wr.alu_addr_op2;

//-------------------------------------------------------------------------------
// Shift logic
//-------------------------------------------------------------------------------
 //
 // Shift logic supports the following types of shift operations:
 // - Logical left shift      (SLLI/SLL)
 // - Logical right shift     (SRLI/SRL)
 // - Arithmetic right shift  (SRAI/SRA)
//
    //assign
    ialu_cmd_shft = (exu2ialu_cmd_i == SCR1_IALU_CMD_SLL)
                        | (exu2ialu_cmd_i == SCR1_IALU_CMD_SRL)
                        | (exu2ialu_cmd_i == SCR1_IALU_CMD_SRA);
    // assign
    shft_cmd      = ialu_cmd_shft
                        ? {(exu2ialu_cmd_i != SCR1_IALU_CMD_SLL),
                            (exu2ialu_cmd_i == SCR1_IALU_CMD_SRA)}
                        : 2'b00;

    // always_comb begin
        shft_op1 = exu2ialu_main_op1_i;
        shft_op2 = exu2ialu_main_op2_i[4:0];
        case (shft_cmd)
            2'b10   : shft_res = shft_op1  >> shft_op2;
            2'b11   : shft_res = shft_op1 >>> shft_op2;
            default : shft_res = shft_op1  << shft_op2;
        endcase
    // end

//-------------------------------------------------------------------------------
// Main adder
//-------------------------------------------------------------------------------
//
 // Main adder is used for the following types of operations:
 // - Addition/subtraction          (ADD/ADDI/SUB)
 // - Branch comparisons            (BEQ/BNE/BLT(U)/BGE(U))
 // - Arithmetic comparisons        (SLT(U)/SLTI(U))
//

// Carry out (MSB of main_sum_res) is evaluated correctly because the result
// width equals to the maximum width of both the right-hand and left-hand side variables
        // always_comb begin
            main_sum_res = (exu2ialu_cmd_i != SCR1_IALU_CMD_ADD)
                         ? ({1'b0, exu2ialu_main_op1_i} - {1'b0, exu2ialu_main_op2_i})   // Subtraction and comparison
                         : ({1'b0, exu2ialu_main_op1_i} + {1'b0, exu2ialu_main_op2_i});  // Addition

            main_sum_pos_ovflw = ~exu2ialu_main_op1_i[`SCR1_XLEN-1]
                               &  exu2ialu_main_op2_i[`SCR1_XLEN-1]
                               &  main_sum_res[`SCR1_XLEN-1];
            main_sum_neg_ovflw =  exu2ialu_main_op1_i[`SCR1_XLEN-1]
                               & ~exu2ialu_main_op2_i[`SCR1_XLEN-1]
                               & ~main_sum_res[`SCR1_XLEN-1];

            // FLAGS1 - flags for comparison (result of subtraction)
            main_sum_flags.c = main_sum_res[`SCR1_XLEN];
            main_sum_flags.z = ~|main_sum_res[`SCR1_XLEN-1:0];
            main_sum_flags.s = main_sum_res[`SCR1_XLEN-1];
            main_sum_flags.o = main_sum_pos_ovflw | main_sum_neg_ovflw;
        // end

//-------------------------------------------------------------------------------
// Operation result forming
//-------------------------------------------------------------------------------

            // always_comb begin
                ialu2exu_main_res_o    = '0;
                ialu2exu_cmp_res_o     = 1'b0;
            // `ifdef SCR1_RVM_EXT
            //     ialu2exu_rvm_res_rdy_o = 1'b1;
            // `endif // SCR1_RVM_EXT

                case (exu2ialu_cmd_i)
                    SCR1_IALU_CMD_AND : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i & exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_OR : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i | exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_XOR : begin
                        ialu2exu_main_res_o = exu2ialu_main_op1_i ^ exu2ialu_main_op2_i;
                    end
                    SCR1_IALU_CMD_ADD : begin
                        ialu2exu_main_res_o = main_sum_res[`SCR1_XLEN-1:0];
                    end
                    SCR1_IALU_CMD_SUB : begin
                        ialu2exu_main_res_o = main_sum_res[`SCR1_XLEN-1:0];
                    end
                    SCR1_IALU_CMD_SUB_LT : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.s ^ main_sum_flags.o);
                        ialu2exu_cmp_res_o  = main_sum_flags.s ^ main_sum_flags.o;
                    end
                    SCR1_IALU_CMD_SUB_LTU : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.c);
                        ialu2exu_cmp_res_o  = main_sum_flags.c;
                    end
                    SCR1_IALU_CMD_SUB_EQ : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(main_sum_flags.z);
                        ialu2exu_cmp_res_o  = main_sum_flags.z;
                    end
                    SCR1_IALU_CMD_SUB_NE : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~main_sum_flags.z);
                        ialu2exu_cmp_res_o  = ~main_sum_flags.z;
                    end
                    SCR1_IALU_CMD_SUB_GE : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~(main_sum_flags.s ^ main_sum_flags.o));
                        ialu2exu_cmp_res_o  = ~(main_sum_flags.s ^ main_sum_flags.o);
                    end
                    SCR1_IALU_CMD_SUB_GEU : begin
                        ialu2exu_main_res_o = `SCR1_XLEN'(~main_sum_flags.c);
                        ialu2exu_cmp_res_o  = ~main_sum_flags.c;
                    end
                    SCR1_IALU_CMD_SLL,
                    SCR1_IALU_CMD_SRL,
                    SCR1_IALU_CMD_SRA: begin
                        ialu2exu_main_res_o = shft_res;
                    end
            // `ifdef SCR1_RVM_EXT
            //         SCR1_IALU_CMD_MUL,
            //         SCR1_IALU_CMD_MULHU,
            //         SCR1_IALU_CMD_MULHSU,
            //         SCR1_IALU_CMD_MULH : begin
            //  `ifdef SCR1_FAST_MUL
            //             ialu2exu_main_res_o = mul_cmd_hi
            //                                 ? mul_res[SCR1_MUL_RES_WIDTH-1:`SCR1_XLEN]
            //                                 : mul_res[`SCR1_XLEN-1:0];
            //  `else // ~SCR1_FAST_MUL
            //             case (mdu_fsm_ff)
            //                 SCR1_IALU_MDU_FSM_IDLE : begin
            //                     ialu2exu_main_res_o    = '0;
            //                     ialu2exu_rvm_res_rdy_o = ~mdu_iter_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_ITER : begin
            //                     ialu2exu_main_res_o    = mul_cmd_hi ? mul_res_hi : mul_res_lo;
            //                     ialu2exu_rvm_res_rdy_o = mdu_iter_rdy;
            //                 end
            //             endcase
            //  `endif // ~SCR1_FAST_MUL
            //         end
            //         SCR1_IALU_CMD_DIV,
            //         SCR1_IALU_CMD_DIVU,
            //         SCR1_IALU_CMD_REM,
            //         SCR1_IALU_CMD_REMU : begin
            //             case (mdu_fsm_ff)
            //                 SCR1_IALU_MDU_FSM_IDLE : begin
            //                     ialu2exu_main_res_o    = (|exu2ialu_main_op2_i | div_cmd_rem)
            //                                            ? exu2ialu_main_op1_i
            //                                            : '1;
            //                     ialu2exu_rvm_res_rdy_o = ~mdu_iter_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_ITER : begin
            //                     ialu2exu_main_res_o    = div_cmd_rem ? div_res_rem : div_res_quo;
            //                     ialu2exu_rvm_res_rdy_o = mdu_iter_rdy & ~mdu_corr_req;
            //                 end
            //                 SCR1_IALU_MDU_FSM_CORR : begin
            //                     ialu2exu_main_res_o    = div_cmd_rem
            //                                            ? mdu_sum_res[`SCR1_XLEN-1:0]
            //                                            : -mdu_res_lo_ff[`SCR1_XLEN-1:0];
            //                     ialu2exu_rvm_res_rdy_o = 1'b1;
            //                 end
            //             endcase
            //         end
            // `endif // SCR1_RVM_EXT
            //         default : begin end
                endcase

            // end

    return ialu2exu_cmp_res_o;
endfunction : predicted_alu_cmp_result_calc


function bit [`SCR1_XLEN-1:0]  dut_scoreboard::predicted_alu_addr_result_calc(dut_sequence_item_i seqi_wr);
    // Address adder
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op1_i;        // Address adder 1st operand
    bit             [`SCR1_XLEN-1:0]          exu2ialu_addr_op2_i;        // Address adder 2nd operand
    bit             [`SCR1_XLEN-1:0]          ialu2exu_addr_res_o;        // Address adder result

    //set input
    // exu2ialu_cmd_i = seqi_wr.alu_cmd;
    // exu2ialu_main_op1_i = seqi_wr.alu_main_op1;
    // exu2ialu_main_op2_i = seqi_wr.alu_main_op2;
    exu2ialu_addr_op1_i = seqi_wr.alu_addr_op1;
    exu2ialu_addr_op2_i = seqi_wr.alu_addr_op2;

//-------------------------------------------------------------------------------
// Address adder
//-------------------------------------------------------------------------------
//
 // Additional adder is used for the following types of operations:
 // - PC-based address calculation          (AUIPC)
 // - IMEM branch address calculation       (BEQ/BNE/BLT(U)/BGE(U))
 // - IMEM jump address calculation         (JAL/JALR)
 // - DMEM load address calculation         (LB(U)/LH(U)/LW)
 // - DMEM store address calculation        (SB/SH/SW)
//
                    //assign
                     ialu2exu_addr_res_o = exu2ialu_addr_op1_i + exu2ialu_addr_op2_i;

    // predicted_result.alu_main_result = ialu2exu_main_res_o;
    // predicted_result.alu_cmp_result = ialu2exu_cmp_res_o;
    // // predicted_result.alu_addr_result = ialu2exu_addr_res_o;

    return ialu2exu_addr_res_o;
endfunction : predicted_alu_addr_result_calc

`endif //DUT_SCOREBOARD_SV
