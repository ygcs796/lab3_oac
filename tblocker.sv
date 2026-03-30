`timescale 1ns / 1ps // setando o tempo e a precisao

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
            btn = press_val;      // joga 1 no botao(apertado)
            #20;                  //espera
            btn = 4'b0000;        // volta pra 0
            #20;                  // espera mais um pouco
        end
    endtask

    initial begin
        $monitor("------------------------");
        clk   = 0;
        rst_n = 0;
        btn   = 4'b0000; // nenhum botao pressionado
        
        #20;
        rst_n = 1;       //tira do reset
        #20;

        // cenario do ciclo completo
        $monitor("\n--- Teste 1: Senha Correta ---");

        press_btn(4'b0001); 
        press_btn(4'b0010); 
        press_btn(4'b0010); 
        press_btn(4'b1000); 

        // Verifica se abriu
        #10;
        if (open) $monitor("SUCESSO: A fechadura abriu!");
        else      $monitor("FALHA: A fechadura nao abriu.");
        
        //reseta para o proximo teste
        #20;
        rst_n = 1; #20; rst_n = 0; #20;

        // um botao correto e depois 2 botoes ao mesmo tempo
        $monitor("\n--- Teste 2: Dois Botoes Apertados Juntos ---");
        press_btn(4'b0001); // correto
        
        press_btn(4'b0110); // pressiona dois ao mesmo tempo
        
        // é pra maquina voltar pra init
        #10;
        $monitor("\nFechadura pos-erro duplo: open = %b", open);

       //resetando de novo
        #20;
        rst_n = 1; #20; rst_n = 0; #20;

        // um botao correto e um botao errado em seguida
        $monitor("\n--- Teste 3: Botao Errado no Meio da Sequencia ---");
        press_btn(4'b0001); // aperta o correto
        
        press_btn(4'b1000); // aperta um botao depois do que deveria
        
        // é pra maquina voltar a init
        #10;
        $monitor("\nFechadura pos-erro: open = %b", open);

        // acabando a simulacao
        #50;
        $monitor("\n--------------------------------------");
        $finish;
    end

endmodule
