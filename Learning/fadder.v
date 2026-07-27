/* Full Adder implementation

S= A⊕B⊕Cin
Cout=(A&B||Cin(A⊕B))

*/
//Data Flow
module FA_df(S,C_out,A,B,C_in);

    input A,B,C_in;
    output S,C_out;

    assign S = A ^ B ^ C_in;
    assign C_out = ( A & B ) | ( C_in & ( A ^ B ));

endmodule

//Behavioral Level
/*
module FA_bl(S,C_out,A,B,C_in);

    input A,B,C_in;
    output reg S,C_out;

    always @(*)begin
        S = A ^ B ^ C_in;
        C_out = ( A & B ) | ( C_in & ( A ^ B ));
    end

endmodule
*/

//Gate level Modeling
/*
module FA_gl(S,C_out,A,B,C_in);

    input A,B,C_in;
    output S,C_out;

    //literal wire, think of them as temp values or "holding spaces"
    wire S1,C1,C2;

    //Sum
    xor u1(S1,A,B);
    xor u2(S,S1,C_in);

    //Carry
    and u3(C1,A,B);
    and u4(C2,S1,C_in);
    or u5 (C_out,C1,C2);

endmodule
    */