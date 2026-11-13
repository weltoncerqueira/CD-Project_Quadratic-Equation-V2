module contador_3b (
    input  clk,
    input  rst,
    input  pulso,
    output [2:0] Q
);

    wire parar, Nparar;    
    wire habilita;
    wire T1, T2;

    // Detecta quando Q = 3'b111 (parar = Q[2] & Q[1] & Q[0])
    and (parar, Q[2], Q[1], Q[0]);
    not (Nparar, parar);

    // Habilita a contagem apenas se houver pulso e o contador não tiver parado em 111
    and (habilita, pulso, Nparar);

    // Primeiro Flip-Flop T (Q[0])
    ff_T FFT0 (
        .t(habilita),
        .clk(clk),
        .rst(rst),
        .q(Q[0])
    );

    // Entrada T do segundo Flip-Flop (Q[1]) -> Ativa quando Q[0] == 1
    and (T1, habilita, Q[0]);

    ff_T FFT1 (
        .t(T1),
        .clk(clk),
        .rst(rst),
        .q(Q[1])
    );

    // Entrada T do terceiro Flip-Flop (Q[2]) -> Ativa quando Q[1] e Q[0] são 1
    and (T2, T1, Q[1]); // Correção aplicada aqui

    ff_T FFT2 (
        .t(T2),
        .clk(clk),
        .rst(rst),
        .q(Q[2])
    );

endmodule