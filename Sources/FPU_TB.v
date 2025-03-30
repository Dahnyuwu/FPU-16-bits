module FPU_TB();
// Inputs
    reg         clk, rst, start, rx;
// Outputs
    wire        ready, error, tx;

    integer i;
    reg [15:0] DATA0, DATA1, DATA2;

FPU     I0  (.clk(clk), .rst(rst), .ready(ready), .error(error), .rx(rx), .tx(tx));

initial begin
    start = 1'b0;
    rx  = 1'b1;
    DATA0 = 16'h5780;
    DATA1 = 16'h3D05;
    DATA2 = 16'h2;

    rst = 1'b1;
    #10 rst = 1'b0;
    #10 rst = 1'b1;
    clk = 1'b0;
end

always begin
    #10 clk = ~clk;
end

always begin
        #4360   rx = 1'b0;

        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA0[i];
            #8696;
        end
        rx = 1'b1;          // Stop bit

        #8696 rx = 1'b0;
        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA0[i+8];
            #8696;
        end
        rx = 1'b1;          // Stop bit

        #8696 rx = 1'b0;



        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA1[i];
            #8696;
        end
        rx = 1'b1;          // Stop bit

        #8696 rx = 1'b0;
        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA1[i+8];
            #8696;
        end
        rx = 1'b1;          // Stop bit

        #8696 rx = 1'b0;



        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA2[i];
            #8696;
        end
        rx = 1'b1;          // Stop bit

        #8696 rx = 1'b0;
        #8696;
        for (i=0;i<8;i=i+1) begin
            rx = DATA2[i+8];
            #8696;
        end
        rx = 1'b1;          // Stop bit




        #1231231231;

       

        

end
    
endmodule

