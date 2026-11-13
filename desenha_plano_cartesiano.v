
module desenha_plano_cartesiano (
    input clk,                // Clock de 50MHz da placa DE10-Lite
    input btn_reset,          // Botão de reset
    output VGA_HS, VGA_VS,    // Pinos de sincronismo do conector VGA
    output [3:0] VGA_R,       // Pinos Vermelhos (4 bits)
    output [3:0] VGA_G,       // Pinos Verdes (4 bits)
    output [3:0] VGA_B       // Pinos Azuis (4 bits)
);
	 wire [9:0] eixo_x, eixo_y;
	 wire area_visivel;
	 wire p_tick;
	 
	 vga_sync meu_vga (clk, btn_reset, VGA_HS, VGA_VS, area_visivel, p_tick, eixo_x, eixo_y);
	 
	 wire desenha_eixo_x, desenha_eixo_y;

	 assign desenha_eixo_x = (eixo_x >= 50 && eixo_x <= 590) && (eixo_y == 240);
	 assign desenha_eixo_y = (eixo_x == 320) && (eixo_y >= 50 && eixo_y <= 430);
	 
	 wire desenha_eixos;
	 assign desenha_eixos = desenha_eixo_x || desenha_eixo_y;
	 
	 assign VGA_R = (area_visivel && desenha_eixos) ? 4'b1111 : 4'b0000;
    assign VGA_G = (area_visivel && desenha_eixos) ? 4'b1111 : 4'b0000;
	 assign VGA_B = (area_visivel && desenha_eixos) ? 4'b1111 : 4'b0000;
	 
    //assign VGA_B = 4'b0000; // Azul desligado = Vermelho + Verde = Amarelo
	
endmodule