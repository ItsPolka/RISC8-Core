// Alu implementation trough different separate modules for each function
//opcode 000 selected by funct3

/* INDEX
-ALU module
-Aritmetic
-Logic
-Shifts
-MUX
*/

// ALU Module
module(
    input [7:0]a,b,
    input [2:0]sel,
    output[7:0]y
);
    wire [7:0] add_y, sub_y, and_y, or_y, xor_y, sll_y, srl_y, sra_y;

    //Initiates the modules

    add      u_add (.a(a), .b(b), .y(add_y));
    sub      u_sub (.a(a), .b(b), .y(sub_y));
    and_gate u_and (.a(a), .b(b), .y(and_y));
    or_gate  u_or  (.a(a), .b(b), .y(or_y));
    xor_gate u_xor (.a(a), .b(b), .y(xor_y));
    sll      u_sll (.a(a), .b(b[2:0]), .y(sll_y));
    srl      u_srl (.a(a), .b(b[2:0]), .y(srl_y));
    sra      u_sra (.a(a), .b(b[2:0]), .y(sra_y));

    alu_mux u_mux(
        .add_y(add_y), .sub_y(sub_y), .and_y(and_y), .or_y(or_y),
        .xor_y(xor_y), .sll_y(sll_y), .srl_y(srl_y), .sra_y(sra_y),
        .sel(sel), .y(y)
    );
endmodule




// Arithmetic Modules
module add(
    input [7:0]a,b,
    output [7:0]y
);
    assign y=a+b;
endmodule
module sub(
    input [7:0]a,b,
    output [7:0]y
);
    assign y=a-b;
endmodule
/*
The adder could be implemented in the data flow level with chained modules: 

module FA_df(S,C_out,A,B,C_in);

    input A,B,C_in;
    output S,C_out;

    assign S = A ^ B ^ C_in;
    assign C_out = ( A & B ) | ( C_in & ( A ^ B ));

endmodule

*/


//Logic Modules

module and_gate(
    input [7:0]a,b,
    output [7:0]y
);
    assign y=a&b;
endmodule
module or_gate(
    input [7:0]a,b,
    output [7:0]y
);
    assign y=a|b;
endmodule
module xor_gate(
    input [7:0]a,b,
    output [7:0]y
);
    assign y=a^b;
endmodule

//Register Shifting

//rd = rs1 << rs2[2:0]
module sll(
    input [7:0]a, //rs1
    input [2:0]b, //rs2[2:0] shift amount (8bit)
    output [7:0]y
);
    assign y=a<<b;
endmodule
//rd = rs1 >> rs2[2:0] (logical)
module srl(
    input [7:0]a, //rs1
    input [2:0]b, //rs2[2:0] shift amount (8bit)
    output [7:0]y
);
    assign y=a>>b; //logical shift (zero fill)
endmodule
//rd = rs1 >> rs2[2:0] (arithmetic)
module sra(
    input [7:0]a, //rs1
    input [2:0]b, //rs2[2:0] shift amount (8bit)
    output [7:0]y
);
    assign y=$signed(a)>>>b; //arithmetic shift (sign extend)
endmodule

// MUX module to select what output you want to take.
module alu_mux(
    input  [7:0] add_y, sub_y, and_y, or_y, xor_y, sll_y, srl_y, sra_y,
    input  [2:0] sel,        // function select
    output reg [7:0] y
);
    always @(*) begin
        case (sel)
            3'b000: y = add_y;   // ADD
            3'b001: y = sub_y;   // SUB
            3'b010: y = and_y;   // AND
            3'b011: y = or_y;    // OR
            3'b100: y = xor_y;   // XOR
            3'b101: y = sll_y;   // SLL
            3'b110: y = srl_y;   // SRL
            3'b111: y = sra_y;   // SRA
        endcase
    end
endmodule