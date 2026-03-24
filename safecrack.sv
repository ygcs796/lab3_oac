module safecrack 
    (output logic unlocked,
    input logic clk, rst,
    input logic[3:0] btn);

    enum {A, B, C, D, E, UNLOCK, WAIT} state;

    always_ff @ (posedge clk, negedge rst)
        if (~rst)
            state <= A;

    
endmodule