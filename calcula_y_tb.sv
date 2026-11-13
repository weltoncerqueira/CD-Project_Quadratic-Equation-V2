timescale 1ns / 1ps

module calcula_y_tb;

    // Sinais de entrada do Testbench
    reg clk;
    reg rst;
    reg start;
    reg [10:0] x;
    reg [10:0] a;
    reg [10:0] b;
    reg [10:0] c;

    // Sinais de saída do Módulo Principal
    wire overflow;
    wire cout;
    wire [32:0] y;
    wire done;

    // Instanciação da Unidade Sob Teste (UUT)
    calcula_y uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x(x),
        .a(a),
        .b(b),
        .c(c),
        .overflow(overflow),
        .cout(cout),
        .y(y),
        .done(done)
    );

    // Geração do Clock: Período de 10ns (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Inicialização dos sinais
        clk = 0;
        rst = 1;
        start = 0;
        x = 11'sd0;
        a = 11'sd0;
        b = 11'sd0;
        c = 11'sd0;

        // Mantém o reset ativo por 25ns
        #25;
        rst = 0;
        #15;

        // -----------------------------------------------------------------
        // CASO DE TESTE 1: y = 2*(3)^2 + 4*(3) + 5
        // Esperado: 2*(9) + 12 + 5 = 18 + 12 + 5 = 35
        // -----------------------------------------------------------------
        $display("[%0t ns] Iniciando Teste 1...", $time);
        a = 11'sd2;
        x = 11'sd3;
        b = 11'sd4;
        c = 11'sd5;
        
        // Pulso de start
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Aguarda o sinal de término (done)
        @(posedge done);
        #1;
        $display("[%0t ns] Teste 1 Finalizado -> x=%d, a=%d, b=%d, c=%d | y = %d (Hex: %h) | Overflow = %b", 
                 $time, $signed(x), $signed(a), $signed(b), $signed(c), $signed(y), y, overflow);

        #30;

        // -----------------------------------------------------------------
        // CASO DE TESTE 2 com números negativos: y = -1*(-2)^2 + 3*(-2) + 10
        // Esperado: -1*(4) - 6 + 10 = -4 - 6 + 10 = 0
        // -----------------------------------------------------------------
        $display("[%0t ns] Iniciando Teste 2...", $time);
        a = -11'sd1;
        x = -11'sd2;
        b = 11'sd3;
        c = 11'sd10;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        @(posedge done);
        #1;
        $display("[%0t ns] Teste 2 Finalizado -> x=%d, a=%d, b=%d, c=%d | y = %d (Hex: %h) | Overflow = %b", 
                 $time, $signed(x), $signed(a), $signed(b), $signed(c), $signed(y), y, overflow);

        #50;
        $finish;
    end

endmodule