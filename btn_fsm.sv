module button_fsm (
    input  logic       clk,    
    input  logic       rst_n,  
    input  logic       btn,    
    output logic       btn_rise   
);

logic btn_active; 
logic btn_prev;    

assign btn_active = ~btn;
assign btn_rise   = btn_active & ~btn_prev;  

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) btn_prev <= 1'b0;
    else        btn_prev <= btn_active;
end

endmodule
