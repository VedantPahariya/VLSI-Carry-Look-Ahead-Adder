`timescale 1ns/1ns
`include "CLA.v"

module CLAtb;
    // Test inputs
    reg [3:0] A, B;
    reg Cin;
    reg clk;  // Added clock signal
    
    // Test outputs
    wire [3:0] S;
    wire Cout, Gout, Pout;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock (10ns period)
    end
    
    // Instantiate the CLA with clock
    CLA4bit cla_inst(
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),  // Added clock connection
        .S(S),
        .Cout(Cout),
        .Gout(Gout),
        .Pout(Pout)
    );
    
    // Test stimulus
    initial begin
        // Generate VCD file for waveform viewing
        $dumpfile("cla_test.vcd");
        $dumpvars(0, CLAtb);

        // Initialize inputs
        A = 4'b0000;
        B = 4'b0000;
        Cin = 0;
        
        // Wait for 2 clock cycles for initialization
        @(posedge clk);
        @(posedge clk);
        
        // Test case 1: Simple addition
        A = 4'b0010; // 2
        B = 4'b0011; // 3
        Cin = 0;
        @(posedge clk);  // Wait for next clock edge
        @(posedge clk);  // Wait for result
        $display("Test 1: %d + %d + %d = %d, Cout = %d", A, B, Cin, S, Cout);
        
        // Test case 2: Addition with carry in
        A = 4'b0011; // 3
        B = 4'b0100; // 4
        Cin = 1;
        @(posedge clk);
        @(posedge clk);
        $display("Test 2: %d + %d + %d = %d, Cout = %d", A, B, Cin, S, Cout);
        
        // Test case 3: Maximum value
        A = 4'b1111; // 15
        B = 4'b1111; // 15
        Cin = 0;
        @(posedge clk);
        @(posedge clk);
        $display("Test 3: %d + %d + %d = %d, Cout = %d", A, B, Cin, S, Cout);
        
        // Test case 4: Overflow case
        A = 4'b1111; // 15
        B = 4'b0001; // 1
        Cin = 1;
        @(posedge clk);
        @(posedge clk);
        $display("Test 4: %d + %d + %d = %d, Cout = %d", A, B, Cin, S, Cout);
        
        #20 $finish;
    end
    
    initial begin
        $monitor($time, " A=%b, B=%b, Cin=%b, S=%b, Cout=%b", A, B, Cin, S, Cout);
    end
endmodule
