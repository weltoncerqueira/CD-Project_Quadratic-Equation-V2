module multiplicador_8x22_sinalizado (
    input  signed [7:0]  A,
    input  signed [21:0] B,
    output signed [29:0] S
);
    assign S = A * B;
endmodule