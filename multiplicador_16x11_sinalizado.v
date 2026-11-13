// Multiplicador 16x11 com sinal (Two's Complement) - 100% Estrutural Completo
module multiplicador_16x11_sinalizado (
    input  signed [15:0] A, // Multiplicando (16 bits com sinal)
    input  signed [10:0] B, // Multiplicador (11 bits com sinal)
    output signed [26:0] S  // Produto (27 bits)
);

    assign S = A * B;

endmodule
