`timescale 1ns/1ns
`include "fadder.v"

module hadderTB;

//variables (basically inputs reg, outputs wire)
    reg A,B,C_in;
    wire S,C_out;

    //uut is just a name, you can call it whatever. uut means unit under test.
    FA_df uut(S,C_out,A,B,C_in);

    initial begin
        //creates vcd file
        $dumpfile("fadderTB.vcd");
        $dumpvars(0, hadderTB);
        //debug display and formating
        $display("Time\tA B Cin| S Cout");
        $monitor("%g\t%b %b %b | %b %b", $time, A,B,C_in,S,C_out);

        //Test cases (#10 is a 10ns delay)
        A=0;B=0;C_in=0;#10;
        A=1;B=0;C_in=0;#10;
        A=0;B=1;C_in=0;#10;
        A=1;B=1;C_in=0;#10;
        A=0;B=0;C_in=1;#10;
        A=1;B=0;C_in=1;#10;
        A=0;B=1;C_in=1;#10;
        A=1;B=1;C_in=1;#10;


    end



endmodule
