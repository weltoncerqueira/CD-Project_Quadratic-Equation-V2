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

    // 1. Instância do gerador de sincronismo VGA
    vga_sync meu_vga (
        .clk(clk),           
        .reset(~btn_reset),   // Ajuste conforme a polaridade do botão da sua placa
        .hsync(VGA_HS),      
        .vsync(VGA_VS),      
        .video_on(area_visivel), 
        .p_tick(p_tick),     
        .x(eixo_x),          
        .y(eixo_y)           
    );

    // 2. Definição dos Estados da FSM
    localparam [1:0] 
        ST_BLANK = 2'b00,
        ST_FUNDO = 2'b01,
        ST_EIXO  = 2'b10;

    reg [1:0] estado_atual, proximo_estado;

    // 3. Bloco Sequencial da FSM (Rodando no clock principal da placa)
    // Usamos o 'p_tick' como condição de enable para atualizar o estado apenas no momento exato do pixel.
    always @(posedge clk or posedge ~btn_reset) begin
        if (~btn_reset) begin
            estado_atual <= ST_BLANK;
        end else if (p_tick) begin
            estado_atual <= proximo_estado;
        end
    end

    // 4. Lógica Combinacional de Transição de Estados (Automática)
    always @* begin
        if (!area_visivel) begin
            proximo_estado = ST_BLANK;
        end else begin
            // Se estiver nas coordenadas centrais (X=320 ou Y=240), desenha o eixo
            if ((eixo_x == 10'd320) || (eixo_y == 10'd240)) begin
                proximo_estado = ST_EIXO;
            end else begin
                proximo_estado = ST_FUNDO;
            end
        end
    end

    // 5. Lógica de Saída (Máquina de Moore: Fundo Escuro / Eixos Brancos)
    reg [3:0] r_reg, g_reg, b_reg;

    always @* begin
        case (estado_atual)
            ST_EIXO: begin
                // Eixos em Branco Brilhante
                r_reg = 4'b0000;
                g_reg = 4'b0000;
                b_reg = 4'b0000;
            end
            ST_FUNDO: begin
                // Fundo Escuro (Preto)
                r_reg = 4'b1111;
                g_reg = 4'b1111;
                b_reg = 4'b1111;
            end
            default: begin // ST_BLANK
                // Fora da área visível (obrigatório desligar os canais de cor)
                r_reg = 4'b0000;
                g_reg = 4'b0000;
                b_reg = 4'b0000;
            end
        endcase
    end

    // Atribuição final das cores para os pinos
    assign VGA_R = r_reg;
    assign VGA_G = g_reg;
    assign VGA_B = b_reg;

endmodule