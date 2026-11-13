module desenha_eixo_cartesiano (
    input clk,          
    input btn_reset,          
    output VGA_HS, VGA_VS,    
    output [3:0] VGA_R,      
    output [3:0] VGA_G,      
    output [3:0] VGA_B        
);

    wire [9:0] eixo_x, eixo_y;
    wire area_visivel;
    wire p_tick;

    // 1. Instancia do "motor" VGA
    vga_sync meu_vga (
        .clk(clk), 
        .reset(~btn_reset), 
        .hsync(VGA_HS), 
        .vsync(VGA_VS), 
        .video_on(area_visivel), 
        .p_tick(p_tick), 
        .x(eixo_x), 
        .y(eixo_y)
    );

    // 2. Definição dos Estados da FSM
    // ST_BLANK: Fora da área visível (por exemplo, durante o Back/Front Porch ou Blanking)
    // ST_FUNDO: Na área visível, pintando o fundo
    // ST_EIXO: Na área visível, exatamente nas coordenadas dos eixos (X=320 ou Y=240)
    localparam [1:0] 
        ST_BLANK = 2'b00,
        ST_FUNDO = 2'b01,
        ST_EIXO  = 2'b10;

    reg [1:0] estado_atual, proximo_estado;

    // Lógica sequencial do registrador de estados (disparada pelo p_tick ou clk do pixel)
    always @(posedge clk or posedge btn_reset) begin
        if (btn_reset) begin
            estado_atual <= ST_BLANK;
        end else begin
            estado_atual <= proximo_estado;
        end
    end

    // Lógica combinacional de transição de estados da FSM
    always @(*) begin
        if (!area_visivel) begin
            proximo_estado = ST_BLANK;
        end else begin
            // Se estiver na área visível, verifica se o pixel atual pertence ao eixo central
            if ((eixo_x == 320) || (eixo_y == 240)) begin
                proximo_estado = ST_EIXO;
            end else begin
                proximo_estado = ST_FUNDO;
            end
        end
    end

    // 3. Lógica de Saída baseada no Estado Atual (Máquina de Estados de Moore)
    // No seu código original, ~desenhar colocava branco onde NÃO era eixo e preto no eixo.
    // Ou seja: Eixo = Preto (4'b0000), Fundo = Branco (4'b1111).
    reg [3:0] cor_r, cor_g, cor_b;

    always @(*) begin
        case (estado_atual)
            ST_EIXO: begin
                // Desenho do eixo (Cor preta ou outra cor desejada)
                cor_r = 4'b0000;
                cor_g = 4'b0000;
                cor_b = 4'b0000;
            end
            ST_FUNDO: begin
                // Cor do fundo (Branco, conforme sua lógica original ~desenhar)
                cor_r = 4'b1111;
                cor_g = 4'b1111;
                cor_b = 4'b1111;
            end
            default: begin	// ST_BLANK
                // Fora da área visível (Blanking deve enviar preto)
                cor_r = 4'b0000;
                cor_g = 4'b0000;
                cor_b = 4'b0000;
            end
        endcase
    end

    // Atribuição final aos pinos de saída
    assign VGA_R = cor_r;
    assign VGA_G = cor_g;
    assign VGA_B = cor_b;

endmodule
