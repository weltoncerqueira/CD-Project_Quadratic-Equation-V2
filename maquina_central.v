module maquina_central (
    input clk,
    input reset,
    input sel_d,
    // Entradas para o estado CALCULA_VERTICE
    input ovf_v1_in,
    input ovf_v2_in,
    input ovf_f1_in,
    input ovf_f2_in,
    // Entrada para o ciclo CALCULA_PONTOS <-> REG_BUSY
    input reg_full,
    
    // Saídas de erro
    output reg err_v1,
    output reg err_v2,
    output reg err_f1,
    output reg err_f2,
    
    // Saídas de controle do sistema/desenho
    output reg ativar_desenho,   // Ativa o módulo de desenho dos eixos
    output reg desenho_pronto,   // Indica que o desenho já foi feito
    output reg estado_e2         // Mantido para compatibilidade ou uso geral
);

    // Codificação dos Estados da FSM (One-Hot ou Binária com 3 bits)
    localparam [2:0] 
        INICIO           = 3'b000,
        CALCULA_VERTICE  = 3'b001,
        DES_EIXOS        = 3'b010,
        CALCULA_PONTOS   = 3'b011,
        REG_BUSY         = 3'b100;

    reg [2:0] estado_atual, proximo_estado;

    // 1. Registrador de Estado (Síncrono)
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado_atual <= INICIO;
        else
            estado_atual <= proximo_estado;
    end

    // 2. Lógica de Próximo Estado (Combinacional)
    always @(*) begin
        proximo_estado = estado_atual; // Valor padrão para evitar latches

        case (estado_atual)
            INICIO: begin
                if (sel_d == 1'b1)
                    proximo_estado = CALCULA_VERTICE;
                else
                    proximo_estado = INICIO;
            end

            CALCULA_VERTICE: begin
                // Avança automaticamente para o desenho dos eixos após processar os vértices
                proximo_estado = DES_EIXOS;
            end

            DES_EIXOS: begin
                // Assim que o desenho estiver pronto, avança para o cálculo de pontos
                proximo_estado = CALCULA_PONTOS;
            end

            CALCULA_PONTOS: begin
                if (reg_full == 1'b1)
                    proximo_estado = REG_BUSY;
                else
                    proximo_estado = CALCULA_PONTOS;
            end

            REG_BUSY: begin
                if (reg_full == 1'b0)
                    proximo_estado = CALCULA_PONTOS;
                else
                    proximo_estado = REG_BUSY;
            end

            default: begin
                proximo_estado = INICIO;
            end
        endcase
    end

    // 3. Lógica de Saídas e Atribuições (Sequencial)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            err_v1         <= 1'b0;
            err_v2         <= 1'b0;
            err_f1         <= 1'b0;
            err_f2         <= 1'b0;
            ativar_desenho <= 1'b0;
            desenho_pronto <= 1'b0;
            estado_e2      <= 1'b0;
        end else begin
            // Comportamento padrão das saídas de erro para manter o estado se ativadas
            case (estado_atual)
                INICIO: begin
                    err_v1         <= 1'b0;
                    err_v2         <= 1'b0;
                    err_f1         <= 1'b0;
                    err_f2         <= 1'b0;
                    ativar_desenho <= 1'b0;
                    desenho_pronto <= 1'b0;
                    estado_e2      <= 1'b0;
                end

                CALCULA_VERTICE: begin
                    estado_e2 <= 1'b1;
                    // Se qualquer entrada de overflow for 1, trava a respectiva flag de erro em 1
                    if (ovf_v1_in) err_v1 <= 1'b1;
                    if (ovf_v2_in) err_v2 <= 1'b1;
                    if (ovf_f1_in) err_f1 <= 1'b1;
                    if (ovf_f2_in) err_f2 <= 1'b1;
                end

                DES_EIXOS: begin
                    ativar_desenho <= 1'b1; // Ativa o módulo de desenho dos eixos
                    desenho_pronto <= 1'b1; // Sinaliza que o processo de desenho foi concluído/executado
                end

                CALCULA_PONTOS: begin
                    ativar_desenho <= 1'b0; // Desativa o sinal de disparo do desenho
                    // Realiza cálculos de pontos...
                end

                REG_BUSY: begin
                    // Tratamento ou espera do registrador cheio
                end
            endcase
        end
    end

endmodule