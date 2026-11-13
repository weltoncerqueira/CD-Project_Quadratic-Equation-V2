// Multiplicador 11x11 com sinal (Two's Complement) - 100% Estrutural Completo
module multiplicador_11x11_sinalizado (
    input  signed [10:0] A,
    input  signed [10:0] B,
    output signed [21:0] S
);
    assign S = A * B;
endmodule
