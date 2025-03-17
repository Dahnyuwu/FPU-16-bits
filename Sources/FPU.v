module FPU(
// Inputs
    input   wire          clk, rst, start,
    input   wire [15:0]   data,
// Outputs
    output  wire          ready, error
);

    wire    [17:0]  AOut, BOut;
    wire    [15:0]  RIn, ROut;
    wire    [1:0]   OOut;
    wire            enaAFSM, enaBFSM, enaOFSM, enaRFSM;

FSM     I0  (.clk(clk), .rst(rst), .A(AOut), .B(BOut), .O(OOut), .R(ROut), .start(start), .ready(ready), .error(error), .enaAFSM(enaAFSM), .enaBFSM(enaBFSM), .enaOFSM(enaOFSM), .enaRFSM(enaRFSM), .result(RIn));

Register    #(.N(18))   RA(.clk(clk), .rst(rst), .ena(enaAFSM), .in({data[15:10], 1'b0, 1'b1, data[9:0]}), .out(AOut));
Register    #(.N(18))   RB(.clk(clk), .rst(rst), .ena(enaBFSM), .in({data[15:10], 1'b0, 1'b1, data[9:0]}), .out(BOut));
Register    #(.N(16))   RR(.clk(clk), .rst(rst), .ena(enaRFSM), .in(RIn), .out(ROut));
Register    #(.N(2))    RO(.clk(clk), .rst(rst), .ena(enaOFSM), .in(data[1:0]), .out(OOut));

endmodule

