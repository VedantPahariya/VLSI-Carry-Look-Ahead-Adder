`timescale 1ns/1ns
`include "CompleteCLA.v"

module CLAtb;
    // Test inputs
    reg [3:0] A, B;
    reg Cin;
    reg clk;
    
    // Test outputs
    wire [3:0] S;
    wire Cout, Gout, Pout;
    
    // Instantiate the CLA with clock
    CLA4bit cla_inst(
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .S(S),
        .Cout(Cout),
        .Gout(Gout),
        .Pout(Pout)
    );

    // Test stimulus with periodic pulses
    initial begin
        $dumpfile("cla_test.vcd");
        $dumpvars(0, CLAtb);

        // Initialize inputs
        A = 4'b0000;
        B = 4'b0000;
        Cin = 0;
        clk = 0;

         #1000;
        $finish;
    end

    // Generate periodic pulses for A bits
    always begin
        #10 A[0] = ~A[0];  // Toggle every 10ns
        #20 A[1] = ~A[1];  // Toggle every 20ns
        #40 A[2] = ~A[2];  // Toggle every 40ns
        #80 A[3] = ~A[3];  // Toggle every 80ns
    end

    // Generate periodic pulses for B bits with different frequencies
    always begin
        #14 B[0] = ~B[0];  // Toggle every 14ns
        #28 B[1] = ~B[1];  // Toggle every 28ns
        #56 B[2] = ~B[2];  // Toggle every 56ns
        #112 B[3] = ~B[3]; // Toggle every 112ns
    end

    // Toggle Cin periodically
    always #160 Cin = ~Cin;  // Toggle every 160ns
    always #5 clk = ~clk;  // 100MHz clock
    
    // Monitor changes
    initial begin
        $monitor($time, " A=%b, B=%b, Cin=%b, S=%b, Cout=%b", A, B, Cin, S, Cout);
    end
endmodule
