// f ′(x) = 2ax + b (Versão Redimensionada e Otimizada)
module calcula_y_linha (
    input  [10:0] x,
    input  [7:0]  a,
    input  [7:0]  b,
    output [19:0] y_linha
);

    wire [8:0]  produto1; // 2 * a (9 bits)
    wire [19:0] produto2; // (2a) * x (20 bits)
    wire [19:0] b_ext;    // b estendido para 20 bits
    wire        ovf1;
    
    // 1. Cálculo de 2a (8 bits x 2 bits fixos -> 9 bits)
    multiplicador_8x8_sinalizado multp_1 (
        .A(a),
        .B(2'b10),
        .S(produto1)
    );
     
    // 2. Cálculo de 2ax (9 bits x 11 bits -> 20 bits)
    multiplicador_9x11_sinalizado multp_2 (
        .A(produto1), 
        .B(x),
        .S(produto2)  
    );
     
    // 3. Extensão de sinal da variável 'b' (8 bits -> 20 bits)
    assign b_ext = {{12{b[7]}}, b};
     
    // 4. Soma final: 2ax + b (20 bits)
    somador_20b soma20 (
        .A(produto2),
        .B(b_ext),
        .cin(1'b0),
        .S(y_linha),
        .cout(),
        .overflow(ovf1)
    );
        
endmodule


// Somador otimizado de 20 bits com detecção de overflow em complemento de dois
module somador_20b (
    input  [19:0] A,
    input  [19:0] B,
    input         cin,
    output [19:0] S,
    output        cout,
    output        overflow
);
    
    wire [18:0] c;

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
    somador_completo fa19 (.A(A[19]), .B(B[19]), .cin(c[18]), .S(S[19]), .cout(cout));
    
    // Overflow em complemento de dois: XOR entre o carry de entrada e o carry de saída do MSB
    xor (overflow, c[18], cout);
     
endmodule