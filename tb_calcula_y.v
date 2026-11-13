`timescale 1ns / 1ps

module tb_calcula_y();

    // Entradas do módulo (reg para poder atribuir valores no bloco initial)
    reg  [10:0] x;
    reg  [7:0]  a;
    reg  [7:0]  b;
    reg  [7:0]  c;

    // Saídas do módulo (wire)
    wire        overflow;
    wire        cout;
    wire [29:0] y;

    // Instanciação da Unidade Under Test (UUT)
    calcula_y uut (
        .x(x),
        .a(a),
        .b(b),
        .c(c),
        .overflow(overflow),
        .cout(cout),
        .y(y)
    );

    // Bloco de Estímulos
    initial begin
        // Configuração para exibir o formato dos números no console (decimal com sinal e hexadecimal)
        $display("--------------------------------------------------------------------------------------------------");
        $display("  TIME  |   X (dec/hex)   |   A (dec/hex)   |   B (dec/hex)   |   C (dec/hex)   |   Y (dec)   | OV | CO ");
        $display("--------------------------------------------------------------------------------------------------");

        // Caso 1: Valores positivos simples
        // y = 2*(4^2) + 3*(4) + 5 = 2*(16) + 12 + 5 = 32 + 12 + 5 = 49
        x = 11'd4;  a = 8'd2;   b = 8'd3;   c = 8'd5;
        #10;
        $display("%0t ns | %5d (h%03h) | %4d (h%02h) | %4d (h%02h) | %4d (h%02h) | %10d |  %b |  %b", 
                 $time, x, x, a, a, b, b, c, c, $signed(y), overflow, cout);

        // Caso 2: Valores zerados
        // y = 0*(0^2) + 0*(0) + 0 = 0
        x = 11'd0;  a = 8'd0;   b = 8'd0;   c = 8'd0;
        #10;
        $display("%0t ns | %5d (h%03h) | %4d (h%02h) | %4d (h%02h) | %4d (h%02h) | %10d |  %b |  %b", 
                 $time, x, x, a, a, b, b, c, c, $signed(y), overflow, cout);

        // Caso 3: Coeficientes negativos (Complemento de Dois)
        // a = -2, b = -3, c = 10, x = 5
        // y = (-2)*(5^2) + (-3)*(5) + 10 = (-2)*(25) - 15 + 10 = -50 - 15 + 10 = -55
        x = 11'd5;  a = -8'd2;  b = -8'd3;  c = 8'd10;
        #10;
        $display("%0t ns | %5d (h%03h) | %4d (h%02h) | %4d (h%02h) | %4d (h%02h) | %10d |  %b |  %b", 
                 $time, x, x, $signed(a), a, $signed(b), b, $signed(c), c, $signed(y), overflow, cout);

        // Caso 4: Entrada x negativa (-4)
        // y = 2*((-4)^2) + 3*(-4) + 5 = 2*(16) - 12 + 5 = 32 - 12 + 5 = 25
        x = -11'd4; a = 8'd2;   b = 8'd3;   c = 8'd5;
        #10;
        $display("%0t ns | %5d (h%03h) | %4d (h%02h) | %4d (h%02h) | %4d (h%02h) | %10d |  %b |  %b", 
                 $time, x, x, a, a, b, b, c, c, $signed(y), overflow, cout);

        // Caso 5: Valores maiores para testar robustez da escala
        // y = 5*(10^2) + 10*(10) + 20 = 5*(100) + 100 + 20 = 500 + 100 + 20 = 620
        x = 11'd10; a = 8'd5;   b = 8'd10;  c = 8'd20;
        #10;
        $display("%0t ns | %5d (h%03h) | %4d (h%02h) | %4d (h%02h) | %4d (h%02h) | %10d |  %b |  %b", 
                 $time, x, x, a, a, b, b, c, c, $signed(y), overflow, cout);

        $display("--------------------------------------------------------------------------------------------------");
        $finish;
    end

endmodule