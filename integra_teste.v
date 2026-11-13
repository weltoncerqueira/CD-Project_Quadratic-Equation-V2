
module integra_teste (
    input [7:0] sw,
    input botao,
    input clk,
    input reset,
	 output [6:0] sel_abc
);

    wire [7:0] reg_a1, reg_b1, reg_c1;
	 wire [7:0] reg_a2, reg_b2, reg_c2;
	 wire [23:0] y1, y2;
    wire [2:0] count;
	 
    wire botao_pulse; 
     
    wire rst_interno;
    not (rst_interno, reset);
     
    // captura um pulso único do botão
   detector_de_borda borda_1 (
       .clk(clk),
       .rst(rst_interno),
       .sinal(botao),
       .pulso(botao_pulse)
    );
	 
	 // Conta até 3, com base em cada pulso do botao
	 contador_3b cont_3b(
		 .clk(clk),
		 .rst(rst_interno),
		 .pulso(botao_pulse),
		 .Q(count)
	 );
	 
	 // Decodifica o contador para escolher qual registrador receberá o valor das chaves
	 decoder_abc decoder_abc(
		 .count(count),
		 .sel(sel_abc)
	);
	   
    // registradores 1
    registrador_8b reg8_a11 (.D(sw), .enable(sel_abc[0]), .rst(rst_interno), .clk(clk), .S(reg_a1));
    registrador_8b reg8_b12 (.D(sw), .enable(sel_abc[1]), .rst(rst_interno), .clk(clk), .S(reg_b1));
    registrador_8b reg8_c13 (.D(sw), .enable(sel_abc[2]), .rst(rst_interno), .clk(clk), .S(reg_c1));
	 
	 // registradores 2
    registrador_8b reg8_a21 (.D(sw), .enable(sel_abc[3]), .rst(rst_interno), .clk(clk), .S(reg_a2));
    registrador_8b reg8_b22 (.D(sw), .enable(sel_abc[4]), .rst(rst_interno), .clk(clk), .S(reg_b2));
    registrador_8b reg8_c23 (.D(sw), .enable(sel_abc[5]), .rst(rst_interno), .clk(clk), .S(reg_c2));
	 
	 wire [9:0] cont_x;
	 contador_fsm cont_320(
		 .clk(clk),
		 .rst(rst_interno),    // reset assíncrono, ativo em alto
		 .start(sel_abc[6]),  // inicia a contagem
		 .contagem(cont_x),
		 .fase(),     			// 0 = contando até -320, 1 = contando até +320
		 .done()      			// 1 quando as duas contagens terminaram
	 );
	 
	 calcula_y calcula_y1 (
      .x(sw),
      .a(reg_a1),
      .b(reg_b1),
      .c(reg_c1),
      .overflow(),
      .cout(),
      .y(y1)
    );
	 
	 calcula_y calcula_y2 (
      .x(sw),
      .a(reg_a2),
      .b(reg_b2),
      .c(reg_c2),
      .overflow(),
      .cout(),
      .y(y2)
    );
	 
	 wire [8:0]  Vx;
    wire [17:0] Vy;
    wire ovf_a0, ovf_v;

	calcula_vertices (
    .a(a),
    .b(b),
    .delta(),
    .Vx(Vx),
    .Vy(Vy),
    .err_a0(ovf_a0),
    .err_v(ovf_v)
);
	 
	 
	 
	
	 
	 
	 
endmodule







