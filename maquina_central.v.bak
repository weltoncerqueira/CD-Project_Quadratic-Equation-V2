
module maquina_central (
    input clk,
    input reset,
    input sel_d,
    input ovf1, 
    input ovf2,
    output reg e2,
    output reg flag_err1,
    output reg flag_err2
);

    // Definição dos estados (1 bit é suficiente para 2 estados)
    parameter INICIO        = 1'b0,
              PROCESSAMENTO = 1'b1;
              
    reg estado_atual, proximo_estado;

    // 1. Registrador de estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            estado_atual <= INICIO;
        else
            estado_atual <= proximo_estado;
    end
            
    // 2. Lógica de próximo estado (Combinacional)
    always @(*) begin
        proximo_estado = estado_atual; // Valor padrão para evitar latches
        
        case (estado_atual)
            INICIO: begin
                if (sel_d == 1'b1) 
                    proximo_estado = PROCESSAMENTO;
                else 
                    proximo_estado = INICIO;
            end
            
            PROCESSAMENTO: begin
                if (sel_d == 1'b0) 
                    proximo_estado = INICIO;
                else 
                    proximo_estado = PROCESSAMENTO;
            end
            
            default: begin
                proximo_estado = INICIO;
            end
        endcase
    end
    
    // 3. Lógica de saídas e controle de erros (Sequencial)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flag_err1 <= 1'b0;
            flag_err2 <= 1'b0;
            e2        <= 1'b0;
        end else begin
            case (estado_atual)
                INICIO: begin
                    e2        <= 1'b0;
                    flag_err1 <= 1'b0; // Limpa os erros no estado inicial
                    flag_err2 <= 1'b0;
                end
                
                PROCESSAMENTO: begin
                    e2 <= 1'b1;
                    
                    // Aciona os erros ativamente enquanto estiver processando
                    if (ovf1 == 1'b1)
                        flag_err1 <= 1'b1;
                        
                    if (ovf2 == 1'b1)
                        flag_err2 <= 1'b1;
                end
            endcase
        end
    end

endmodule