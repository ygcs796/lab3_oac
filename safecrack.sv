module locker (
    input   logic       clk,
    input   logic       rst_n,
    input   logic [3:0] btn,
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

state actState = 1;
state nextState = 1;

logic btn_1, btn_2, btn_3, btn_4;

button_fsm button1 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn[0]),
        .leds  (btn_1)
    );

button_fsm button2 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn[1]),
        .leds  (btn_2)
    );

button_fsm button3 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn[2]),
        .leds  (btn_3)
    );

button_fsm button4 (
        .clk   (clk),
        .rst_n (rst_n),
        .btn   (btn[3]),
        .leds  (btn_4)
    );

logic [3:0] btn = {btn4, btn3, btn2, btn1};

always_comb begin

next_state = state;  

unique case (state)

    INIT: 

    if (btn = 4'b0001) next_state: BTN1;
    else next_state = INIT;

    BTN1: 

    if (btn = 4'b0010) next_state: BTN2;
    else next_state = INIT;

    BTN2:

    if (btn = 4'b0100) next_state: BTN3;
    else next_state = INIT;

    BTN3:

    if (btn = 4'b1000) next_state: BTN4;
    else next_state = INIT;

    BTN4:

    next_state: UNLOCK;

    UNLOCK:

    if(rst_n) next_state: INIT
    else next_state: UNLOCK
    
endcase

end

endmodule
