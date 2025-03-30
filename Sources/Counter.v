//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo cumple la función de un contador        //
//              de N bits de largo y generacion de division de      //
//              reloj.                                              //
//                                                                  //
//  Date    :   17/Mar/2024                                         //
//////////////////////////////////////////////////////////////////////

module Counter #(parameter STOP = -1, N = $clog2(STOP), RSTVALUE = 0)(
// Inputs
    input   wire                in, rst, ena,         // Señales de control
// Outputs
    output  reg                 clk,
    output  reg                 rstOne,
    output  reg     [N-1'b1:0]  cnt
);


    always @(posedge in, negedge rst) begin
        if (!rst) begin                                   // Condición de reset
            clk <= 1'b0;
            rstOne <= 1'b0; 
            cnt <= RSTVALUE;                      
        end

        else
            if (cnt < (STOP))
                if (ena) begin
                    if (cnt < STOP/2)
                        clk <= 1'b0;

                    else 
                        clk <= 1'b1;

                    cnt <= cnt + 1'b1;                      // Aumento del contador en función de clk (en este caso cuenta Shifts)
                    rstOne <= rstOne;
                end
                
                else begin 
                    cnt <= cnt;                             // Aumento del contador en función de clk (en este caso cuenta Shifts)
                    rstOne <= rstOne;
                    clk <= clk;
                end
            
            else begin
                cnt <= RSTVALUE;
                rstOne <= 1'b1;
                clk <= clk;
            end
    end
    
endmodule