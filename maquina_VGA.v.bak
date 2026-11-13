module maquina_VGA (
    input clk,
    input reset,
    input e2,                    // Sinal de acionamento vindo da primeira máquina
    input acabou_estado,
    input reg_full,
    output reg [1:0] estado_atual_out
);

    parameter DESENHA_VERTICES = 2'b00,
              CALCULA_PONTOS   = 2'b01,
              PINTA            = 2'b10;
              
    reg [1:0] estado_atual, proximo_estado;

    always @(*) begin
        estado_atual_out = estado_atual;
    end

    // 1. Registrador de estado (Apenas clock e reset assíncrono padrão)
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado_atual <= DESENHA_VERTICES;
        else
            estado_atual <= proximo_estado;
    end
            
    // 2. Lógica de próximo estado (O sinal 'e2' é tratado aqui como condição)
    always @(*) begin
        // Se a primeira máquina não estiver em PROCESSAMENTO (e2 == 0), 
        // a máquina de VGA fica travada/retorna para DESENHA_VERTICES.
        if (e2 == 1'b0) begin
            proximo_estado = DESENHA_VERTICES;
        end else begin
            proximo_estado = estado_atual; // Valor padrão para evitar latches
            
            case (estado_atual)
                DESENHA_VERTICES: begin
                    if (acabou_estado == 1'b1)
                        proximo_estado = CALCULA_PONTOS;
                    else
                        proximo_estado = DESENHA_VERTICES;
                end
                
                CALCULA_PONTOS: begin
                    if (reg_full == 1'b1)
                        proximo_estado = PINTA;
                    else
                        proximo_estado = CALCULA_PONTOS;
                end
                
                PINTA: begin
                    if (reg_full == 1'b0)
                        proximo_estado = CALCULA_PONTOS;
                    else
                        proximo_estado = PINTA;
                end
                
                default: proximo_estado = DESENHA_VERTICES;
            endcase
        end
    end

endmodule