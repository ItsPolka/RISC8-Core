`timescale 1ns/1ns
`include "hadder.v"

module hadderTB;

//variables (basically inputs reg, outputs wire)
    reg A,B;
    wire S,C;

    //uut is just a name, you can call it whatever. uut means unit under test.
    HA_df uut(S,C,A,B);

    initial begin
        //creates vcd file
        $dumpfile("hadderTB.vcd");
        $dumpvars(0, hadderTB);
        //debug display and formating
        $display("Time\tA B | S C");
        $monitor("%g\t%b %b | %b %b", $time, A,B,S,C);

        //Test cases (#10 is a 10ns delay)
        A=0;B=0;#10;
        A=1;B=0;#10;
        A=0;B=1;#10;
        A=1;B=1;#10;
    end



endmodule


