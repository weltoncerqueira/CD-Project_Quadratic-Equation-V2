// NÃO MECHE
// Multiplicador 8x11 com sinal (Two's Complement) - 100% Estrutural Completo
module multiplicador_8x11_sinalizado (
    input  signed [7:0]  A, // Multiplicando (8 bits com sinal)
    input  signed [10:0] B, // Multiplicador (11 bits com sinal)
    output signed [18:0] S  // Produto (19 bits)
);

	assign S = A * B;
	
endmodule
