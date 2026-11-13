
// Módulo: detector_de_borda
module detector_de_borda (
    input  clk,
    input  rst,
    input  sinal,   // 1 = solto, 0 = pressionado (convenção KEY da DE10-Lite)
    output pulso
);

    wire Q1, Q2, Q1N;

    ff_D FF_Detector1 (
        .D(sinal),
        .clk(clk),
        .reset(rst),
          .Q(Q1)
    );

    ff_D FF_Detector2 (
        .D(Q1),
        .clk(clk),
        .reset(rst),
          .Q(Q2)
    );
     
     not (Q1N, Q1);
     and (pulso, Q1N, Q2);
    
     
endmodule