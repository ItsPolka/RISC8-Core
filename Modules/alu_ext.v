// Comparator implementation trough different separate modules for each function
//opcode 0001 and 0010


/* INDEX
-SLT
-SLTU

* Separeted from main ALU Module as they use a different opcode from the alu, 
in a fisical implementation they would be sharing the same circuit, 
but as we are simulating and for practical/organizational reasons 
I moved them to their own file.

*/

//
module slt(
    input  [7:0] a, b,   // rs1, rs2
    output [7:0] y
);
    assign y = ($signed(a) < $signed(b)) ? 8'b1 : 8'b0;
endmodule

module sltu(
    input  [7:0] a, b,
    output [7:0] y
);
    assign y = (a < b) ? 8'b1 : 8'b0;
endmodule