// =====================================================================
// divisor_18x18_sinalizado.v
// Divisor binário SINALIZADO de 18 bits (divisão restauradora)
// Quociente truncado em direção a zero; resto com o sinal do dividendo.
// Depende de: somador_completo, mux_2x1, complementoDe2_18bits
// =====================================================================

module divisor_18x18_sinalizado (
	input  [17:0] A,       // dividendo
	input  [17:0] B,       // divisor
	output [17:0] S,       // quociente
	output [17:0] resto
);

	wire [17:0] A_final, B_final, div_result, resto_sem_sinal;
	wire sinal;

	// Sinais iguais = 0, Sinais diferentes = 1
	xor (sinal, A[17], B[17]);

	numero_Final_18b num1 (.entrada(A), .valor_absoluto(A_final));
	numero_Final_18b num2 (.entrada(B), .valor_absoluto(B_final));

	divisor_18bits div1 (
		.A(A_final),
		.B(B_final),
		.Q(div_result),
		.R(resto_sem_sinal)
	);

	complementoDe2_18bits complemento4 (
		.A(div_result),
		.bs(sinal),
		.out(S)
	);

	complementoDe2_18bits complemento2 (
		.A(resto_sem_sinal),
		.bs(A[17]),            // resto segue APENAS o sinal do dividendo
		.out(resto)
	);

endmodule

// ---------------------------------------------------------------------
// Subtrator de 19 bits: dif = a - b (a + ~b + 1)
// sel = 1 se a < b (subtração "inválida", precisa restaurar)
// ---------------------------------------------------------------------
module subtrator_19b (
	input  [18:0] a,
	input  [18:0] b,
	output [18:0] dif,
	output sel
);

	wire [18:0] nb;
	wire [17:0] c;
	wire cout;


	not (nb[0], b[0]);
	not (nb[1], b[1]);
	not (nb[2], b[2]);
	not (nb[3], b[3]);
	not (nb[4], b[4]);
	not (nb[5], b[5]);
	not (nb[6], b[6]);
	not (nb[7], b[7]);
	not (nb[8], b[8]);
	not (nb[9], b[9]);
	not (nb[10], b[10]);
	not (nb[11], b[11]);
	not (nb[12], b[12]);
	not (nb[13], b[13]);
	not (nb[14], b[14]);
	not (nb[15], b[15]);
	not (nb[16], b[16]);
	not (nb[17], b[17]);
	not (nb[18], b[18]);

	somador_completo soma0(a[0], nb[0], 1'b1, dif[0], c[0]);
	somador_completo soma1(a[1], nb[1], c[0], dif[1], c[1]);
	somador_completo soma2(a[2], nb[2], c[1], dif[2], c[2]);
	somador_completo soma3(a[3], nb[3], c[2], dif[3], c[3]);
	somador_completo soma4(a[4], nb[4], c[3], dif[4], c[4]);
	somador_completo soma5(a[5], nb[5], c[4], dif[5], c[5]);
	somador_completo soma6(a[6], nb[6], c[5], dif[6], c[6]);
	somador_completo soma7(a[7], nb[7], c[6], dif[7], c[7]);
	somador_completo soma8(a[8], nb[8], c[7], dif[8], c[8]);
	somador_completo soma9(a[9], nb[9], c[8], dif[9], c[9]);
	somador_completo soma10(a[10], nb[10], c[9], dif[10], c[10]);
	somador_completo soma11(a[11], nb[11], c[10], dif[11], c[11]);
	somador_completo soma12(a[12], nb[12], c[11], dif[12], c[12]);
	somador_completo soma13(a[13], nb[13], c[12], dif[13], c[13]);
	somador_completo soma14(a[14], nb[14], c[13], dif[14], c[14]);
	somador_completo soma15(a[15], nb[15], c[14], dif[15], c[15]);
	somador_completo soma16(a[16], nb[16], c[15], dif[16], c[16]);
	somador_completo soma17(a[17], nb[17], c[16], dif[17], c[17]);
	somador_completo soma18(a[18], nb[18], c[17], dif[18], cout);

	not (sel, cout);

endmodule

// ---------------------------------------------------------------------
// Estágio da divisão restauradora (1 bit)
// ---------------------------------------------------------------------
module divisor_estagio_18b (
	input  Abit,
	input  [17:0] R_in,
	input  [17:0] B,
	output [17:0] Resto,
	output Qbit
);

	wire [18:0] Rshift;       // {R_in[17:0], Abit}
	wire [18:0] B_extendido;  // {1'b0, B[17:0]}
	wire [18:0] dif;
	wire sel;

	buf (Rshift[0], Abit);
	buf (Rshift[1], R_in[0]);
	buf (Rshift[2], R_in[1]);
	buf (Rshift[3], R_in[2]);
	buf (Rshift[4], R_in[3]);
	buf (Rshift[5], R_in[4]);
	buf (Rshift[6], R_in[5]);
	buf (Rshift[7], R_in[6]);
	buf (Rshift[8], R_in[7]);
	buf (Rshift[9], R_in[8]);
	buf (Rshift[10], R_in[9]);
	buf (Rshift[11], R_in[10]);
	buf (Rshift[12], R_in[11]);
	buf (Rshift[13], R_in[12]);
	buf (Rshift[14], R_in[13]);
	buf (Rshift[15], R_in[14]);
	buf (Rshift[16], R_in[15]);
	buf (Rshift[17], R_in[16]);
	buf (Rshift[18], R_in[17]);

	buf (B_extendido[0], B[0]);
	buf (B_extendido[1], B[1]);
	buf (B_extendido[2], B[2]);
	buf (B_extendido[3], B[3]);
	buf (B_extendido[4], B[4]);
	buf (B_extendido[5], B[5]);
	buf (B_extendido[6], B[6]);
	buf (B_extendido[7], B[7]);
	buf (B_extendido[8], B[8]);
	buf (B_extendido[9], B[9]);
	buf (B_extendido[10], B[10]);
	buf (B_extendido[11], B[11]);
	buf (B_extendido[12], B[12]);
	buf (B_extendido[13], B[13]);
	buf (B_extendido[14], B[14]);
	buf (B_extendido[15], B[15]);
	buf (B_extendido[16], B[16]);
	buf (B_extendido[17], B[17]);
	buf (B_extendido[18], 1'b0);

	subtrator_19b sub0(Rshift, B_extendido, dif, sel);

	// Se sel=1 (deu negativo), restaura Rshift; senão usa dif
	mux_2x1 m0(.A(dif[0]), .B(Rshift[0]), .S(sel), .Y(Resto[0]));
	mux_2x1 m1(.A(dif[1]), .B(Rshift[1]), .S(sel), .Y(Resto[1]));
	mux_2x1 m2(.A(dif[2]), .B(Rshift[2]), .S(sel), .Y(Resto[2]));
	mux_2x1 m3(.A(dif[3]), .B(Rshift[3]), .S(sel), .Y(Resto[3]));
	mux_2x1 m4(.A(dif[4]), .B(Rshift[4]), .S(sel), .Y(Resto[4]));
	mux_2x1 m5(.A(dif[5]), .B(Rshift[5]), .S(sel), .Y(Resto[5]));
	mux_2x1 m6(.A(dif[6]), .B(Rshift[6]), .S(sel), .Y(Resto[6]));
	mux_2x1 m7(.A(dif[7]), .B(Rshift[7]), .S(sel), .Y(Resto[7]));
	mux_2x1 m8(.A(dif[8]), .B(Rshift[8]), .S(sel), .Y(Resto[8]));
	mux_2x1 m9(.A(dif[9]), .B(Rshift[9]), .S(sel), .Y(Resto[9]));
	mux_2x1 m10(.A(dif[10]), .B(Rshift[10]), .S(sel), .Y(Resto[10]));
	mux_2x1 m11(.A(dif[11]), .B(Rshift[11]), .S(sel), .Y(Resto[11]));
	mux_2x1 m12(.A(dif[12]), .B(Rshift[12]), .S(sel), .Y(Resto[12]));
	mux_2x1 m13(.A(dif[13]), .B(Rshift[13]), .S(sel), .Y(Resto[13]));
	mux_2x1 m14(.A(dif[14]), .B(Rshift[14]), .S(sel), .Y(Resto[14]));
	mux_2x1 m15(.A(dif[15]), .B(Rshift[15]), .S(sel), .Y(Resto[15]));
	mux_2x1 m16(.A(dif[16]), .B(Rshift[16]), .S(sel), .Y(Resto[16]));
	mux_2x1 m17(.A(dif[17]), .B(Rshift[17]), .S(sel), .Y(Resto[17]));

	not (Qbit, sel);

endmodule

// ---------------------------------------------------------------------
// Divisor 18x18 não-sinalizado: 18 estágios em cascata
// ---------------------------------------------------------------------
module divisor_18bits (
	input  [17:0] A,   // dividendo
	input  [17:0] B,   // divisor
	output [17:0] Q,   // quociente
	output [17:0] R    // resto
);

	wire [17:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16, R17;

	// Resto inicial zerado
	buf (R0[0], 1'b0);
	buf (R0[1], 1'b0);
	buf (R0[2], 1'b0);
	buf (R0[3], 1'b0);
	buf (R0[4], 1'b0);
	buf (R0[5], 1'b0);
	buf (R0[6], 1'b0);
	buf (R0[7], 1'b0);
	buf (R0[8], 1'b0);
	buf (R0[9], 1'b0);
	buf (R0[10], 1'b0);
	buf (R0[11], 1'b0);
	buf (R0[12], 1'b0);
	buf (R0[13], 1'b0);
	buf (R0[14], 1'b0);
	buf (R0[15], 1'b0);
	buf (R0[16], 1'b0);
	buf (R0[17], 1'b0);

	// Do bit mais significativo (A[17]) ao menos significativo (A[0])
	divisor_estagio_18b div17(.R_in(R0), .Abit(A[17]), .B(B), .Resto(R1), .Qbit(Q[17]));
	divisor_estagio_18b div16(.R_in(R1), .Abit(A[16]), .B(B), .Resto(R2), .Qbit(Q[16]));
	divisor_estagio_18b div15(.R_in(R2), .Abit(A[15]), .B(B), .Resto(R3), .Qbit(Q[15]));
	divisor_estagio_18b div14(.R_in(R3), .Abit(A[14]), .B(B), .Resto(R4), .Qbit(Q[14]));
	divisor_estagio_18b div13(.R_in(R4), .Abit(A[13]), .B(B), .Resto(R5), .Qbit(Q[13]));
	divisor_estagio_18b div12(.R_in(R5), .Abit(A[12]), .B(B), .Resto(R6), .Qbit(Q[12]));
	divisor_estagio_18b div11(.R_in(R6), .Abit(A[11]), .B(B), .Resto(R7), .Qbit(Q[11]));
	divisor_estagio_18b div10(.R_in(R7), .Abit(A[10]), .B(B), .Resto(R8), .Qbit(Q[10]));
	divisor_estagio_18b div9(.R_in(R8), .Abit(A[9]), .B(B), .Resto(R9), .Qbit(Q[9]));
	divisor_estagio_18b div8(.R_in(R9), .Abit(A[8]), .B(B), .Resto(R10), .Qbit(Q[8]));
	divisor_estagio_18b div7(.R_in(R10), .Abit(A[7]), .B(B), .Resto(R11), .Qbit(Q[7]));
	divisor_estagio_18b div6(.R_in(R11), .Abit(A[6]), .B(B), .Resto(R12), .Qbit(Q[6]));
	divisor_estagio_18b div5(.R_in(R12), .Abit(A[5]), .B(B), .Resto(R13), .Qbit(Q[5]));
	divisor_estagio_18b div4(.R_in(R13), .Abit(A[4]), .B(B), .Resto(R14), .Qbit(Q[4]));
	divisor_estagio_18b div3(.R_in(R14), .Abit(A[3]), .B(B), .Resto(R15), .Qbit(Q[3]));
	divisor_estagio_18b div2(.R_in(R15), .Abit(A[2]), .B(B), .Resto(R16), .Qbit(Q[2]));
	divisor_estagio_18b div1(.R_in(R16), .Abit(A[1]), .B(B), .Resto(R17), .Qbit(Q[1]));
	divisor_estagio_18b div0(.R_in(R17), .Abit(A[0]), .B(B), .Resto(R), .Qbit(Q[0]));

endmodule

// ---------------------------------------------------------------------
// Valor absoluto de um número em complemento de 2 (18 bits)
// ---------------------------------------------------------------------
module numero_Final_18b (
	input  wire [17:0] entrada,
	output wire [17:0] valor_absoluto
);
	wire bs;

	buf b1 (bs, entrada[17]);

	complementoDe2_18bits complemento_18bit (
		.A(entrada),
		.bs(bs),
		.out(valor_absoluto)
	);

endmodule