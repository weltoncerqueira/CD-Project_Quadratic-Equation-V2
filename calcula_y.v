// Calculo de y = ax² + bx + c (100% Estrutural)
module calcula_y (
    input  [10:0] x,
    input  [7:0]  a,
    input  [7:0]  b,
    input  [7:0]  c,
    output        overflow,
    output        cout,
    output [29:0] y
);
    
    wire [21:0] produto1; // x^2 (22 bits)
    wire [29:0] produto2; // a * x^2 (30 bits)
    wire [18:0] produto3; // b * x (19 bits)
    wire [29:0] soma1;    // ax^2 + bx (30 bits)
    
    wire ovf1, ovf2;

    // x² (11x11 -> 22 bits)
    multiplicador_11x11_sinalizado multp_1 (
        .A(x),
        .B(x),
        .S(produto1)
    );
     
    // a * x² (8x22 -> 30 bits)
    multiplicador_8x22_sinalizado multp_2 (
        .A(a),
        .B(produto1),
        .S(produto2)
    );
     
    // b * x (8x11 -> 19 bits)
    multiplicador_8x11_sinalizado multp_3 (
        .A(b),
        .B(x),
        .S(produto3)
    );
     
    wire [29:0] produto3_ext;
    wire [29:0] c_ext;
    
    // -------------------------------------------------------------------------
    // Extensão de sinal do produto3 (19 bits [18:0] -> 30 bits)
    // Bit de sinal verdadeiro: produto3[18]
    // -------------------------------------------------------------------------
    buf (produto3_ext[0],  produto3[0]);
    buf (produto3_ext[1],  produto3[1]);
    buf (produto3_ext[2],  produto3[2]);
    buf (produto3_ext[3],  produto3[3]);
    buf (produto3_ext[4],  produto3[4]);
    buf (produto3_ext[5],  produto3[5]);
    buf (produto3_ext[6],  produto3[6]);
    buf (produto3_ext[7],  produto3[7]);
    buf (produto3_ext[8],  produto3[8]);
    buf (produto3_ext[9],  produto3[9]);
    buf (produto3_ext[10], produto3[10]);
    buf (produto3_ext[11], produto3[11]);
    buf (produto3_ext[12], produto3[12]);
    buf (produto3_ext[13], produto3[13]);
    buf (produto3_ext[14], produto3[14]);
    buf (produto3_ext[15], produto3[15]);
    buf (produto3_ext[16], produto3[16]);
    buf (produto3_ext[17], produto3[17]);
    buf (produto3_ext[18], produto3[18]);

    // Replicando o bit de sinal produto3[18]
    buf (produto3_ext[19], produto3[18]);
    buf (produto3_ext[20], produto3[18]);
    buf (produto3_ext[21], produto3[18]);
    buf (produto3_ext[22], produto3[18]);
    buf (produto3_ext[23], produto3[18]);
    buf (produto3_ext[24], produto3[18]);
    buf (produto3_ext[25], produto3[18]);
    buf (produto3_ext[26], produto3[18]);
    buf (produto3_ext[27], produto3[18]);
    buf (produto3_ext[28], produto3[18]);
    buf (produto3_ext[29], produto3[18]);

    // -------------------------------------------------------------------------
    // Extensão de sinal de c (8 bits [7:0] -> 30 bits)
    // Bit de sinal verdadeiro: c[7]
    // -------------------------------------------------------------------------
    buf (c_ext[0], c[0]);
    buf (c_ext[1], c[1]);
    buf (c_ext[2], c[2]);
    buf (c_ext[3], c[3]);
    buf (c_ext[4], c[4]);
    buf (c_ext[5], c[5]);
    buf (c_ext[6], c[6]);
    buf (c_ext[7], c[7]);

    // Replicando o bit de sinal c[7]
    buf (c_ext[8],  c[7]);
    buf (c_ext[9],  c[7]);
    buf (c_ext[10], c[7]);
    buf (c_ext[11], c[7]);
    buf (c_ext[12], c[7]);
    buf (c_ext[13], c[7]);
    buf (c_ext[14], c[7]);
    buf (c_ext[15], c[7]);
    buf (c_ext[16], c[7]);
    buf (c_ext[17], c[7]);
    buf (c_ext[18], c[7]);
    buf (c_ext[19], c[7]);
    buf (c_ext[20], c[7]);
    buf (c_ext[21], c[7]);
    buf (c_ext[22], c[7]);
    buf (c_ext[23], c[7]);
    buf (c_ext[24], c[7]);
    buf (c_ext[25], c[7]);
    buf (c_ext[26], c[7]);
    buf (c_ext[27], c[7]);
    buf (c_ext[28], c[7]);
    buf (c_ext[29], c[7]);

    // (ax²) + (bx)
    somador_30b soma30_1 (
        .A(produto2),
        .B(produto3_ext),
        .cin(1'b0),
        .S(soma1),
        .cout(),
        .overflow(ovf1)
    );

    // y = (ax² + bx) + c
    somador_30b soma30_2 (
        .A(soma1),
        .B(c_ext),
        .cin(1'b0),
        .S(y),
        .cout(cout),
        .overflow(ovf2)
    );

    or (overflow, ovf1, ovf2);

endmodule


module somador_30b (
    input  [29:0] A,
    input  [29:0] B,
    input         cin,
    output [29:0] S,
    output        cout,
    output        overflow
);

    wire [28:0] c;

    somador_completo fa0  (.A(A[0]),  .B(B[0]),  .cin(cin),   .S(S[0]),  .cout(c[0]));
    somador_completo fa1  (.A(A[1]),  .B(B[1]),  .cin(c[0]),  .S(S[1]),  .cout(c[1]));
    somador_completo fa2  (.A(A[2]),  .B(B[2]),  .cin(c[1]),  .S(S[2]),  .cout(c[2]));
    somador_completo fa3  (.A(A[3]),  .B(B[3]),  .cin(c[2]),  .S(S[3]),  .cout(c[3]));
    somador_completo fa4  (.A(A[4]),  .B(B[4]),  .cin(c[3]),  .S(S[4]),  .cout(c[4]));
    somador_completo fa5  (.A(A[5]),  .B(B[5]),  .cin(c[4]),  .S(S[5]),  .cout(c[5]));
    somador_completo fa6  (.A(A[6]),  .B(B[6]),  .cin(c[5]),  .S(S[6]),  .cout(c[6]));
    somador_completo fa7  (.A(A[7]),  .B(B[7]),  .cin(c[6]),  .S(S[7]),  .cout(c[7]));
    somador_completo fa8  (.A(A[8]),  .B(B[8]),  .cin(c[7]),  .S(S[8]),  .cout(c[8]));
    somador_completo fa9  (.A(A[9]),  .B(B[9]),  .cin(c[8]),  .S(S[9]),  .cout(c[9]));
    somador_completo fa10 (.A(A[10]), .B(B[10]), .cin(c[9]),  .S(S[10]), .cout(c[10]));
    somador_completo fa11 (.A(A[11]), .B(B[11]), .cin(c[10]), .S(S[11]), .cout(c[11]));
    somador_completo fa12 (.A(A[12]), .B(B[12]), .cin(c[11]), .S(S[12]), .cout(c[12]));
    somador_completo fa13 (.A(A[13]), .B(B[13]), .cin(c[12]), .S(S[13]), .cout(c[13]));
    somador_completo fa14 (.A(A[14]), .B(B[14]), .cin(c[13]), .S(S[14]), .cout(c[14]));
    somador_completo fa15 (.A(A[15]), .B(B[15]), .cin(c[14]), .S(S[15]), .cout(c[15]));
    somador_completo fa16 (.A(A[16]), .B(B[16]), .cin(c[15]), .S(S[16]), .cout(c[16]));
    somador_completo fa17 (.A(A[17]), .B(B[17]), .cin(c[16]), .S(S[17]), .cout(c[17]));
    somador_completo fa18 (.A(A[18]), .B(B[18]), .cin(c[17]), .S(S[18]), .cout(c[18]));
    somador_completo fa19 (.A(A[19]), .B(B[19]), .cin(c[18]), .S(S[19]), .cout(c[19]));
    somador_completo fa20 (.A(A[20]), .B(B[20]), .cin(c[19]), .S(S[20]), .cout(c[20]));
    somador_completo fa21 (.A(A[21]), .B(B[21]), .cin(c[20]), .S(S[21]), .cout(c[21]));
    somador_completo fa22 (.A(A[22]), .B(B[22]), .cin(c[21]), .S(S[22]), .cout(c[22]));
    somador_completo fa23 (.A(A[23]), .B(B[23]), .cin(c[22]), .S(S[23]), .cout(c[23]));
    somador_completo fa24 (.A(A[24]), .B(B[24]), .cin(c[23]), .S(S[24]), .cout(c[24]));
    somador_completo fa25 (.A(A[25]), .B(B[25]), .cin(c[24]), .S(S[25]), .cout(c[25]));
    somador_completo fa26 (.A(A[26]), .B(B[26]), .cin(c[25]), .S(S[26]), .cout(c[26]));
    somador_completo fa27 (.A(A[27]), .B(B[27]), .cin(c[26]), .S(S[27]), .cout(c[27]));
    somador_completo fa28 (.A(A[28]), .B(B[28]), .cin(c[27]), .S(S[28]), .cout(c[28]));
    somador_completo fa29 (.A(A[29]), .B(B[29]), .cin(c[28]), .S(S[29]), .cout(cout));

    xor (overflow, c[28], cout);

endmodule
