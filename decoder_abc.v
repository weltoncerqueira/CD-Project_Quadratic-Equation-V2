module decoder_abc (
    input [2:0] count,
    output [6:0] sel
);
    wire countN0, countN1, countN2;
    
    not (countN0, count[0]);
    not (countN1, count[1]);
    not (countN2, count[2]);
    
    // count = 000 (0) -> sel[0]
    and (sel[0], countN2, countN1, countN0);

    // count = 001 (1) -> sel[1]
    and (sel[1], countN2, countN1, count[0]);

    // count = 010 (2) -> sel[2]
    and (sel[2], countN2, count[1], countN0);
    
    // count = 011 (3) -> sel[3]
    and (sel[3], countN2, count[1], count[0]);
    
    // count = 100 (4) -> sel[4]
    and (sel[4], count[2], countN1, countN0);
    
    // count = 101 (5) -> sel[5]
    and (sel[5], count[2], countN1, count[0]);

    // count = 110 (6) -> sel[6]
    and (sel[6], count[2], count[1], countN0);

    // count = 111 (7) -> Sobra livre (parado)
endmodule
