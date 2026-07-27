// Now using the adder module to create a full 8 bit ripple carry adder using loops to generate it.
//FA_df referenced so when compiling reference both files $ iverilog -o adderx8 adderx8.v fadder.v
module adder_8bit #(parameter N=8)(
//Declaring all the inputs and outputs
    input [N-1:0] A,
    input [N-1:0] B,
    input C_in,
    output [N-1:0] S,
    output C_out
);
//number of wires needed for the carries
    wire [N:0] carry;
//asign C_in and C_out to the first and last carry
    assign carry[0]=C_in;
    assign C_out=carry[N];

    genvar i; //genvar declares a variable 
    generate //generates the instances
        for (i=0;i<N;i=i+1)begin: addergen //the loop that gnerate N ammounts of the instance
            FA_df fa( //the function being instanced with a name (fa)
                .A(A[i]), //.A refers to the A in the full adder module in the diferent file and associates it to whats inside the parenthesis which is what there is in THIS file
                .B(B[i]),
                .C_in(carry[i]),
                .S(S[i]),
                .C_out(carry[i+1])
            );
        end

    endgenerate

endmodule