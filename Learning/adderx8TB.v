
`timescale 1ns/1ns

module adderx8TB;

    parameter N = 8;
    //reg=input wire=output for this purpose
    reg  [N-1:0] A, B;
    reg          C_in;
    wire [N-1:0] S;
    wire         C_out;

    integer i;// loop variable — use integer, not genvar, since this is runtime, not generate-time
    reg [N:0] expected; //9bit expected result

    adder_8bit uut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .S(S),
        .C_out(C_out)
    );

    initial begin
        $dumpfile("adderx8TB.vcd");
        $dumpvars(0, adderx8TB);

        for (i = 0; i < 131072; i = i + 1) begin
            A    = i[7:0];
            B    = i[15:8];
            C_in = i[16];
            #10;

            expected = A + B + C_in; // 9-bit expected sum

            if ({C_out, S} !== expected) begin
                $display("UNEXPECTED VALUE at time %0t: A=%d B=%d Cin=%b | got S=%d C_out=%b (=%d) | expected %d",
                $time, A, B, C_in, S, C_out, {C_out, S}, expected);
            end
        end

        $display("Test complete: %0d cases checked.", 131072);
        $finish;
    end


endmodule
