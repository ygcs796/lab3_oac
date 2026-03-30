module locker (
    input   logic       clk,
    input   logic       rst_n,
    input   logic [3:0] btn_geral,
    output  logic       open
);

typedef enum logic [5:0] {
    INIT = 6'b000001,
    BTN1 = 6'b000010,
    BTN2 = 6'b000100,
    BTN3 = 6'b001000,
    BTN4 = 6'b010000,
    UNLOCK = 6'b100000
} state;

state actState = INIT;
state nextState = INIT;

logic btn_1_ativo, btn_2_ativo, btn_3_ativo, btn_4_ativo;
logic [3:0] btn_atual = 0;

button_fsm button1 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn_geral[0]),
        .btn_rise  (btn_1_ativo)
    );

button_fsm button2 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn_geral[1]),
        .btn_rise (btn_2_ativo)
    );

button_fsm button3 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn_geral[2]),
        .btn_rise (btn_3_ativo)
    );

button_fsm button4 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn_geral[3]),
        .btn_rise  (btn_4_ativo)
    );

always_comb begin

btn_atual = {btn_4_ativo, btn_3_ativo, btn_2_ativo, btn_1_ativo};

nextState = actState;  

unique case (actState)

    INIT: 

    if (btn_atual == 4'b0001) nextState = BTN1;
    else nextState = INIT;

    BTN1: 

    if (btn_atual == 4'b0010) nextState = BTN2;
    else nextState = INIT;

    BTN2:

    if (btn_atual == 4'b0100) nextState = BTN3;
    else nextState = INIT;

    BTN3:

    if (btn_atual == 4'b1000) nextState = BTN4;
    else nextState = INIT;

    BTN4:

    nextState = UNLOCK;

    UNLOCK:

    if(rst_n) nextState = INIT;
    else nextState = UNLOCK;
    
endcase

end

endmodule
