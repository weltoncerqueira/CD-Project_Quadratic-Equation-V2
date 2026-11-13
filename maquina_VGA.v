module maquina_VGA (
    input clk,          
    input btn_reset,          
    output VGA_HS, VGA_VS,    
    output [3:0] VGA_R,      
    output [3:0] VGA_G,      
    output [3:0] VGA_B        
);

    wire [9:0] eixo_x, eixo_y;
    wire area_visivel;
    wire p_tick; // Clock de pixel (25MHz gerado pelo sincronizador)

    // 1. Instancia correta e completa do módulo vga_sync
    vga_sync meu_vga (
        .clk(clk),            // Clock principal da placa (ex: 50 MHz)
        .reset(~btn_reset),   // Ajuste de polaridade do reset
        .hsync(VGA_HS),       // Sincronismo horizontal
        .vsync(VGA_VS),       // Sincronismo vertical
        .video_on(area_visivel), // Sinal de área visível
        .p_tick(p_tick),      // Pulso do pixel clock (essencial!)
        .x(eixo_x),           // Coordenada X atual
        .y(eixo_y)            // Coordenada Y atual
    );

    // 2. Definição dos Estados da FSM
    localparam [1:0] 
        ST_BLANK = 2'b00,
        ST_FUNDO = 2'b01,
        ST_EIXO  = 2'b10;

    reg [1:0] estado_atual, proximo_estado;

    // Lógica sequencial do registrador de estados (disparada pelo p_tick)
    always @(posedge p_tick or posedge btn_reset) begin
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
            if ((eixo_x == 320) || (eixo_y == 240)) begin
                proximo_estado = ST_EIXO;
            end else begin
                proximo_estado = ST_FUNDO;
            end
        end
    end

    // 3. Lógica de Saída (Fundo escuro e eixos brancos)
    reg [3:0] cor_r, cor_g, cor_b;

    always @(*) begin
        case (estado_atual)
            ST_EIXO: begin
                // Eixos em Branco
                cor_r = 4'b1111;
                cor_g = 4'b1111;
                cor_b = 4'b1111;
            end
            ST_FUNDO: begin
                // Fundo Escuro (Preto)
                cor_r = 4'b0000;
                cor_g = 4'b0000;
                cor_b = 4'b0000;
            end
            default: begin // ST_BLANK
                // Fora da área visível (Blanking)
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