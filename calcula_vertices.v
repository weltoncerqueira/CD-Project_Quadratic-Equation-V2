
//Calcula os vertices com saidas de erro
// verificar se a= 0 e retornar overflow
// Verificar se o resultado de qualquer um dos modulos esta fora da area de exibiçao da tela:
// Rejeita se 0 > resultado > 640 
// Calcula os vértices e valida:
//   err_a0 : a = 0  -> não é parábola (ERR Fn)
//   err_v  : vértice fora da tela (ERR Vn). Só vale quando err_a0 = 0.
// Janela visível: x em [-320, 319] (Vx sempre dentro, pois |Vx| <= 64)
//                 y em [-239, 240]
module calcula_vertices (
    input  [7:0]  a,
    input  [7:0]  b,
    input  [17:0] delta,
    output [8:0]  Vx,
    output [17:0] Vy,
    output        err_a0,
    output        err_v
);

    // ---------------- Vértices ----------------
    vertice_x vx_inst (
        .a(a),
        .b(b),
        .Vx(Vx)
    );

    vertice_y vy_inst (
        .a(a),
        .delta(delta),
        .Vy(Vy)
    );

    // ---------------- Erro: a = 0 ----------------
    wire a_nz;                                   // 1 se a != 0
    or  (a_nz, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
    not (err_a0, a_nz);

    // ---------------- Janela de Vy: -239 <= Vy <= 240 ----------------
    wire nib_any;       // algum bit de Vy[3:0] em 1
    wire top4;          // Vy[7:4] = 1111
    wire hi_any;        // algum bit de Vy[16:8] em 1
    wire hi_all;        // Vy[17:8] todos em 1
    wire sgn_n;         // ~Vy[17]

    or  (nib_any, Vy[0], Vy[1], Vy[2], Vy[3]);
    and (top4,    Vy[4], Vy[5], Vy[6], Vy[7]);
    or  (hi_any,  Vy[8],  Vy[9],  Vy[10], Vy[11], Vy[12],
                  Vy[13], Vy[14], Vy[15], Vy[16]);
    and (hi_all,  Vy[8],  Vy[9],  Vy[10], Vy[11], Vy[12],
                  Vy[13], Vy[14], Vy[15], Vy[16], Vy[17]);
    not (sgn_n, Vy[17]);

    // Vy positivo: fora se Vy > 240
    wire t_top, pos_cond, pos_fora;
    and (t_top,    top4, nib_any);               // low byte > 240
    or  (pos_cond, hi_any, t_top);               // > 255 ou > 240
    and (pos_fora, sgn_n, pos_cond);

    // Vy negativo: fora se Vy < -239  (low byte < 17 ou bits altos != 1)
    wire t_n4, low_ge17, neg_ok, neg_ok_n, neg_fora;
    and (t_n4,     Vy[4], nib_any);
    or  (low_ge17, Vy[7], Vy[6], Vy[5], t_n4);   // low byte >= 17
    and (neg_ok,   hi_all, low_ge17);
    not (neg_ok_n, neg_ok);
    and (neg_fora, Vy[17], neg_ok_n);

    // Fora da janela (só significativo se a != 0)
    wire fora;
    or  (fora, pos_fora, neg_fora);
    and (err_v, fora, a_nz);

endmodule


// Vx = -b / (2a)
module vertice_x (
    input  [7:0] a,
    input  [7:0] b,
    output [8:0] Vx
);

    wire [8:0] b_ext;       // b com sinal estendido
    wire [8:0] b_neg;       // -b em 9 bits (sem overflow para b = -128)
    wire [8:0] produto;     // 2a

    // Extensão de sinal: 8 bits -> 9 bits
    assign b_ext = {b[7], b};

    // -b
    complementoDe2_9bits neg_b (
        .A(b_ext),
        .bs(1'b1),
        .out(b_neg)
    );

    // 2a
    multiplicador_8x8_sinalizado multp_1 (
        .A(a),
        .B(8'sd2),
        .S(produto)         // confira a largura real da saída do seu módulo
    );

    // (-b) / (2a)
    divisor_9x9_sinalizado div_1 (
        .A(b_neg),          // dividendo
        .B(produto),        // divisor
        .S(Vx),
        .resto()
    );

endmodule


// Vy = -delta / (4a)
module vertice_y (
    input  [7:0]  a,
    input  [17:0] delta,
    output [17:0] Vy
);

    wire [17:0] delta_neg;
    wire [9:0]  produto;        
    wire [17:0] produto_ext;   

    // -delta
    complementoDe2_18bits neg_delta (
        .A(delta),
        .bs(1'b1),
        .out(delta_neg)
    );

    // 4a
    multiplicador_8x8_sinalizado multp_1 (
        .A(a),
        .B(8'sd4),
        .S(produto)             // confira a largura real da saída do seu módulo
    );

    // Extensão de sinal: 10 bits -> 18 bits
    assign produto_ext = {{8{produto[9]}}, produto};

    // (-delta) / (4a)
    divisor_18x18_sinalizado div_1 (
        .A(delta_neg),
        .B(produto_ext),
        .S(Vy),
        .resto()
    );

endmodule
















