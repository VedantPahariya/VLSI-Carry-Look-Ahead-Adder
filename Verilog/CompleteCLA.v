// Propagate and Generate Block
module progen(
    input Ai, Bi,
    output Gi, Pti, Pi
);
    nor(Pti, Ai, Bi);     // Pti is complement of Ai + Bi
    nand(Gi, Ai, Bi);     // Gi is complement of Ai & Bi
    xor(Pi, Ai, Bi);      // Propagate signal
endmodule

// Intermediate carry calculation
module inter(
    input Gi, Pti, Gi_1, Pti_1,
    output Pij, GPG
);
    wire t1;
    nor(Pij, Pti, Pti_1);         // Pij = (Pti + Pti_1)'
    or(t1, Pti, Gi_1);            // t1 = Pti + Gi_1
    nand(GPG, Gi, t1);            // GPG = (Gi(Pti + Gi_1))'
endmodule

// For C2 and C3 calculation
module AndOr(
    input Pij, GPG, C,
    output Cout
);
    wire t1;
    and(t1, Pij, C);
    or(Cout, GPG, t1);
endmodule

// Main CLA module
module CLA4bit(
    input [3:0] A, B,
    input Cin, clk,     // Added clock input
    output reg [3:0] S, // Changed to registered output
    output reg Cout, Gout, Pout  // Changed to registered outputs
);
    // Add input registers
    reg [3:0] A_reg, B_reg;
    reg Cin_reg;

    // Register inputs
    always @(posedge clk) begin
        A_reg <= A;
        B_reg <= B;
        Cin_reg <= Cin;
    end

    wire [3:0] G, Pt, P;
    wire C1, C2, C3, C4;
    wire Cinbar, P10, P21, P32;
    wire GPG1, GPG2, GPG3;
    wire Puseless, temp1, temp2;
    wire [3:0] Sum_wire;    // Temporary wires for combinational outputs
    wire Cout_wire, Gout_wire, Pout_wire;

    // Generate Cinbar
    not(Cinbar, Cin_reg);

    // Generate P and G for each bit
    progen pg0(A_reg[0], B_reg[0], G[0], Pt[0], P[0]);
    progen pg1(A_reg[1], B_reg[1], G[1], Pt[1], P[1]);
    progen pg2(A_reg[2], B_reg[2], G[2], Pt[2], P[2]);
    progen pg3(A_reg[3], B_reg[3], G[3], Pt[3], P[3]);

    // Intermediate carry calculations
    inter i0(G[0], Pt[0], Cinbar, Pt[0], Puseless, C1);
    inter i1(G[1], Pt[1], G[0], Pt[0], P10, GPG1);
    inter i2(G[2], Pt[2], G[1], Pt[1], P21, GPG2);
    inter i3(G[3], Pt[3], G[2], Pt[2], P32, GPG3);

    // C2 and C3 calculation
    AndOr ao1(P10, GPG1, Cin, C2);
    AndOr ao2(P21, GPG2, C1, C3);

    // Sum calculation
    xor(Sum_wire[0], Cin_reg, P[0]);
    xor(Sum_wire[1], C1, P[1]);
    xor(Sum_wire[2], C2, P[2]);
    xor(Sum_wire[3], C3, P[3]);

    // Gout calculation
    and(temp1, P32, GPG1);
    nor(Gout_wire, temp1, GPG3);

    // Pout calculation
    nand(Pout_wire, P32, P10);

    // Cout calculation
    or(temp2, Pout_wire, Cinbar);
    nand(Cout_wire, temp2, Gout_wire);

    // Register outputs on clock edge
    always @(posedge clk) begin
        S <= Sum_wire;
        Cout <= Cout_wire;
        Gout <= Gout_wire;
        Pout <= Pout_wire;
    end

endmodule