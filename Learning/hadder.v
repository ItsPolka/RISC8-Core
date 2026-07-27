// Half adder implementation with diferent level of abstaction.
//S=A⊕B
//C=AB

//Define a module with the outputs (sum, carry) first and the 
//inpits (a,b) after (as a convention).
module HA_df(s,c,a,b);//data flow
//define inputs and outputs
    output s,c;
    input a,b;
//implementation of the logic
    assign s=a^b;
    assign c=a&b;

endmodule
/*
module HA_bh(s,c,a,b);//Behavioral Level
//define inputs and outputs
    input a,b;
    output reg s,c;

    always @(*)//if any variable changes "always" will execut. the elements inside @(*) are the ones who trigger its, * just means "all".
    begin
        s=a^b;
        c=a&b;
    end
    
endmodule

module HA_sl(s,c,a,b);//Structural Level
//define inputs and outputs
    input a,b;
    output s,c;
//instances of primitive modules
    XOR xor1(s,a,b);
    AND and1(c,a,b);
endmodule
    */