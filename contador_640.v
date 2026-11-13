module contador_640 (
    input clk,
    input rst,
    input habilita,       // Controla se o contador avança a cada pulso de clock
    output reg signed [10:0] Q   // 11 bits em complemento de dois (-1024 a +1023)
);

    // Parâmetros dos limites da contagem
    localparam signed [10:0] VALOR_MIN = -11'sd640;
    localparam signed [10:0] VALOR_MAX = 11'sd640;

    // Codificação dos estados usando parâmetros (compatível com Verilog padrão)
    localparam [0:0] IDLE     = 1'b0,
                     CONTANDO = 1'b1;

    reg estado_atual, proximo_estado;

    // FSM: Lógica de transição de estados
    always @(posedge clk or posedge rst) begin
        if (rst)
            estado_atual <= IDLE;
        else
            estado_atual <= proximo_estado;
    end

    // FSM: Próximo estado e lógica de controle
    always @(*) begin
        proximo_estado = estado_atual;
        case (estado_atual)
            IDLE: begin
                if (habilita)
                    proximo_estado = CONTANDO;
            end
            CONTANDO: begin
                // Se chegou ao máximo, retorna ao IDLE
                if (Q >= VALOR_MAX)
                    proximo_estado = IDLE;
                else if (!habilita)
                    proximo_estado = IDLE;
            end
            default: proximo_estado = IDLE;
        endcase
    end

    // Datapath: Atualização do valor do contador em complemento de dois
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= VALOR_MIN; // Inicia em -640
        end else if (estado_atual == CONTANDO) begin
            if (Q >= VALOR_MAX)
                Q <= VALOR_MIN; // Reinicia o ciclo ao atingir 640
            else
                Q <= Q + 1'b1;  // Incrementa mantendo o complemento de dois natural
        end
    end

endmodule
