`timescale 1ns / 1ps // setando o tempo e a precisão

module tb_locker;

    logic       clk;
    logic       rst_n;
    logic [3:0] btn;
    logic       open;

    locker dut (
        .clk(clk),
        .rst_n(rst_n),
        .btn_geral(btn),
        .open(open)
    );

    always #5 clk = ~clk; // gerando o clock

    // tarefa para pressionar o botao mais facil
    task press_btn(input logic [3:0] press_val);
        begin
            btn = press_val;      // joga 0 no botao(apertado)
            #20;                  //espera
            btn = 4'b1111;        // volta pra 1
            #20;                  // espera mais um pouco
        end
    endtask

    initial begin
        $monitor("------------------------");
        clk   = 0;
        rst_n = 0;
        btn   = 4'b1111; // nenhum botao pressionado
        
        #20;
        rst_n = 1;       //tira do reset
        #20;

        // cenario do ciclo completo
        $monitor("\n--- Teste 1: Senha Correta ---");
        press_btn(4'b1110); 
        press_btn(4'b1101); 
        press_btn(4'b1011); 
        press_btn(4'b0111); 
        
        // Verifica se abriu
        #10;
        if (open) $monitor("SUCESSO: A fechadura abriu!");
        else      $monitor("FALHA: A fechadura nao abriu.");
        
        //reseta para o proximo testw
        #20;
        rst_n = 0; #20; rst_n = 1; #20;

        // um botao correto e depois 2 botoes ao mesmo tempo
        $monitor("\n--- Teste 2: Dois Botoes Apertados Juntos ---");
        press_btn(4'b1110); // correto
        
        press_btn(4'b1001); // pressiona dois ao mesmo tempo
        
        // é pra maquina voltar pra init
        #10;
        $monitor("\nFechadura pos-erro duplo: open = %b", open);

       //resetando denovo
        #20;
        rst_n = 0; #20; rst_n = 1; #20;

        // um botao correto e um botao errado em seguida
        $monitor("\n--- Teste 3: Botao Errado no Meio da Sequencia ---");
        press_btn(4'b1110); // aperta o correto
        
        press_btn(4'b1011); // aperta um botao depois do que deveria
        
        // é pra maquina voltar a init
        #10;
        $monitor("\nFechadura pos-erro: open = %b", open);

        // acabando a simulação
        #50;
        $monitor("\n--------------------------------------");
        $finish;
    end

endmodule
