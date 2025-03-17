module FPU_TB();
// Inputs
    reg         clk, rst, start;
    reg [15:0]  data;
// Outputs
    wire        ready, error;

    integer i;

FPU     I0  (.clk(clk), .rst(rst), .data(data), .start(start), .ready(ready), .error(error));

initial begin
    start = 1'b0;
    data = 15'b0;
    rst = 1'b1;
    #10 rst = 1'b0;
    #10 rst = 1'b1;
    clk = 1'b0;
end

always begin
    #10 clk = ~clk;
end


always begin
    for (i=0; i<255; i=i+1) begin
        #20;

        // data = $urandom_range(0, 65534);
        start = 1'b1;
        #10 start = 1'b0;
        #10;

        // data = $urandom_range(0, 65534);
        start = 1'b1;
        #10 start = 1'b0;
        #10;

        // data = $urandom_range(0, 3);
        // data = 0;
        start = 1'b1;
        #10 start = 1'b0;
        #10;

        start = 1'b1;
        #10 start = 1'b0;
        #10;

        while (!ready && !error)
            #20;

    end
end

always begin
    data = 16'hxx;
    #20;

    data = $urandom_range(0, 65534);
    #25;
    data = $urandom_range(0, 65534);
    #20;
    data = $urandom_range(0, 3);
    #20;
    data = 16'hxx;

    while (!ready && !error) 
        @(posedge clk);
end
    
endmodule

