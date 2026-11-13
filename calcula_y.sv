
// MUDAR PARA O DE 8 BITS
// Calculo de y = ax² + bx + c com entradas de 11 bits
module calcula_y (
    input  [10:0] x,
    input  [10:0] a,
    input  [10:0] b,
    input  [10:0] c,
    output        overflow,
    output        cout,
    output [32:0] y
);
    
    wire [21:0] produto1; // x^2 (22 bits)
    wire [32:0] produto2; // a * x^2 (33 bits)
    wire [21:0] produto3; // b * x (22 bits)
    wire [32:0] soma1;    // ax^2 + bx (33 bits)
    
    wire ovf1, ovf2;

    // x² (11x11 -> 22 bits) - Substituir pelo multiplicador adequado
    multiplicador_11x11_sinalizado multp_1 (
        .A(x),
        .B(x),
        .S(produto1)
    );
     
    // a * x² (11x22 -> 33 bits) - Substituir pelo multiplicador adequado
    multiplicador_22x11_sinalizado multp_2 (
        .A(produto1),
        .B(a),
        .P(produto2)
    );
     
    // b * x (11x11 -> 22 bits) - Substituir pelo multiplicador adequado
    multiplicador_11x11_sinalizado multp_3 (
        .A(b),
        .B(x),
        .S(produto3)
    );
     
    wire [32:0] produto3_ext;
    wire [32:0] c_ext;
    
    // Extensão do produto3 para 33 bits (replicando o bit de sinal em [21])
    genvar i;
    generate
        for (i = 22; i <= 32; i = i + 1) begin : gen_p3_ext
            buf P3_ext (produto3_ext[i], produto3[21]);
        end
        for (i = 0; i <= 21; i = i + 1) begin : gen_p3_val
            buf P3_val (produto3_ext[i], produto3[i]);
        end
    endgenerate
    
    // Extensão do c para 33 bits (replicando o bit de sinal em [10])
    generate
        for (i = 11; i <= 32; i = i + 1) begin : gen_c_ext
            buf C_ext (c_ext[i], c[10]);
        end
        for (i = 0; i <= 10; i = i + 1) begin : gen_c_val
            buf C_val (c_ext[i], c[i]);
        end
    endgenerate
    
    // (ax²) + (bx)
    somador_33b soma24_1 (
        .A(produto2),
        .B(produto3_ext),
        .cin(1'b0),
        .S(soma1),
        .cout(),
        .overflow(ovf1)
    );
     
    // y = (ax² + bx) + c
    somador_33b soma24_2 (
        .A(soma1),
        .B(c_ext),
        .cin(1'b0),
        .S(y),
        .cout(cout),
        .overflow(ovf2)
    );
    
    or (overflow, ovf1, ovf2);

endmodule


module somador_33b (
    input  [32:0] A,
    input  [32:0] B,
    input         cin,
    output [32:0] S,
    output        cout,
    output        overflow
);
    
    wire [31:0] c;

    somador_completo fa0  (.A(A[0]),  .B(B[0]),  .cin(cin),  .S(S[0]),  .cout(c[0]));
    somador_completo fa1  (.A(A[1]),  .B(B[1]),  .cin(c[0]), .S(S[1]),  .cout(c[1]));
    somador_completo fa2  (.A(A[2]),  .B(B[2]),  .cin(c[1]), .S(S[2]),  .cout(c[2]));
    somador_completo fa3  (.A(A[3]),  .B(B[3]),  .cin(c[2]), .S(S[3]),  .cout(c[3]));
    somador_completo fa4  (.A(A[4]),  .B(B[4]),  .cin(c[3]), .S(S[4]),  .cout(c[4]));
    somador_completo fa5  (.A(A[5]),  .B(B[5]),  .cin(c[4]), .S(S[5]),  .cout(c[5]));
    somador_completo fa6  (.A(A[6]),  .B(B[6]),  .cin(c[5]), .S(S[6]),  .cout(c[6]));
    somador_completo fa7  (.A(A[7]),  .B(B[7]),  .cin(c[6]), .S(S[7]),  .cout(c[7]));
    somador_completo fa8  (.A(A[8]),  .B(B[8]),  .cin(c[7]), .S(S[8]),  .cout(c[8]));
    somador_completo fa9  (.A(A[9]),  .B(B[9]),  .cin(c[8]), .S(S[9]),  .cout(c[9]));
    somador_completo fa10 (.A(A[10]), .B(B[10]), .cin(c[9]), .S(S[10]), .cout(c[10]));
    somador_completo fa11 (.A(A[11]), .B(B[11]), .cin(c[10]),.S(S[11]), .cout(c[11]));
    somador_completo fa12 (.A(A[12]), .B(B[12]), .cin(c[11]),.S(S[12]), .cout(c[12]));
    somador_completo fa13 (.A(A[13]), .B(B[13]), .cin(c[12]),.S(S[13]), .cout(c[13]));
    somador_completo fa14 (.A(A[14]), .B(B[14]), .cin(c[13]),.S(S[14]), .cout(c[14]));
    somador_completo fa15 (.A(A[15]), .B(B[15]), .cin(c[14]),.S(S[15]), .cout(c[15]));
    somador_completo fa16 (.A(A[16]), .B(B[16]), .cin(c[15]),.S(S[16]), .cout(c[16]));
    somador_completo fa17 (.A(A[17]), .B(B[17]), .cin(c[16]),.S(S[17]), .cout(c[17]));
    somador_completo fa18 (.A(A[18]), .B(B[18]), .cin(c[17]),.S(S[18]), .cout(c[18]));
    somador_completo fa19 (.A(A[19]), .B(B[19]), .cin(c[18]),.S(S[19]), .cout(c[19]));
    somador_completo fa20 (.A(A[20]), .B(B[20]), .cin(c[19]),.S(S[20]), .cout(c[20]));
    somador_completo fa21 (.A(A[21]), .B(B[21]), .cin(c[20]),.S(S[21]), .cout(c[21]));
    somador_completo fa22 (.A(A[22]), .B(B[22]), .cin(c[21]),.S(S[22]), .cout(c[22]));
    somador_completo fa23 (.A(A[23]), .B(B[23]), .cin(c[22]),.S(S[23]), .cout(c[23]));
    somador_completo fa24 (.A(A[24]), .B(B[24]), .cin(c[23]),.S(S[24]), .cout(c[24]));
    somador_completo fa25 (.A(A[25]), .B(B[25]), .cin(c[24]),.S(S[25]), .cout(c[25]));
    somador_completo fa26 (.A(A[26]), .B(B[26]), .cin(c[25]),.S(S[26]), .cout(c[26]));
    somador_completo fa27 (.A(A[27]), .B(B[27]), .cin(c[26]),.S(S[27]), .cout(c[27]));
    somador_completo fa28 (.A(A[28]), .B(B[28]), .cin(c[27]),.S(S[28]), .cout(c[28]));
    somador_completo fa29 (.A(A[29]), .B(B[29]), .cin(c[28]),.S(S[29]), .cout(c[29]));
    somador_completo fa30 (.A(A[30]), .B(B[30]), .cin(c[29]),.S(S[30]), .cout(c[30]));
    somador_completo fa31 (.A(A[31]), .B(B[31]), .cin(c[30]),.S(S[31]), .cout(c[31]));
    somador_completo fa32 (.A(A[32]), .B(B[32]), .cin(c[31]),.S(S[32]), .cout(cout));
    
    xor (overflow, c[31], cout);
     
endmodule
