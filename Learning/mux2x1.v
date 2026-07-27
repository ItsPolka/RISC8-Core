module MUX2X1(output y,input a,b,sel);

    // Functiponallity of a 2x1 Multiplexer
    assign y= (sel) ? b : a;

endmodule