module complementoDe2_9bits (
    input  wire [8:0] A,
    input  wire       bs,
    output wire [8:0] out
);

    wire [8:0] xA;
    wire [8:0] c;

    // Inverte condicionalmente cada bit (XOR com bs)
    xor (xA[0], A[0], bs);
    xor (xA[1], A[1], bs);
    xor (xA[2], A[2], bs);
    xor (xA[3], A[3], bs);
    xor (xA[4], A[4], bs);
    xor (xA[5], A[5], bs);
    xor (xA[6], A[6], bs);
    xor (xA[7], A[7], bs);
    xor (xA[8], A[8], bs);

    somador_completo fa0 (.A(xA[0]), .B(1'b0), .cin(bs),   .S(out[0]), .cout(c[0]));
    somador_completo fa1 (.A(xA[1]), .B(1'b0), .cin(c[0]), .S(out[1]), .cout(c[1]));
    somador_completo fa2 (.A(xA[2]), .B(1'b0), .cin(c[1]), .S(out[2]), .cout(c[2]));
    somador_completo fa3 (.A(xA[3]), .B(1'b0), .cin(c[2]), .S(out[3]), .cout(c[3]));
    somador_completo fa4 (.A(xA[4]), .B(1'b0), .cin(c[3]), .S(out[4]), .cout(c[4]));
    somador_completo fa5 (.A(xA[5]), .B(1'b0), .cin(c[4]), .S(out[5]), .cout(c[5]));
    somador_completo fa6 (.A(xA[6]), .B(1'b0), .cin(c[5]), .S(out[6]), .cout(c[6]));
    somador_completo fa7 (.A(xA[7]), .B(1'b0), .cin(c[6]), .S(out[7]), .cout(c[7]));
    somador_completo fa8 (.A(xA[8]), .B(1'b0), .cin(c[7]), .S(out[8]), .cout(c[8]));

endmodule