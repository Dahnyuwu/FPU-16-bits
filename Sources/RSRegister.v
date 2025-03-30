//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo cumple la función de un registro        //
//              con desplazamiento a la derecha y carga par-        //
//              alela y serial y reset síncrono.                    //
//                                                                  //
//  Date    :   17/Mar/2024                                         //
//////////////////////////////////////////////////////////////////////

module RSRegister #(parameter N = 8)(  
// Inputs
    input   wire                clk, rst, ena,                  // Señales de control del registro
    input   wire                SIn,                            // Entrada del bit serial
// Outputs
    output  reg     [N-1'b1:0]  out                             // Salida del registro
);
    
    always @(posedge clk, negedge rst) begin
        if (!rst)                                           // Condición de reset
            out <= {N{1'b0}};                               

        else
            if (ena)                                       // Desplazamiento a la derecha con entrada del dato serial en el MSB
                out <= {SIn, out[N-1'b1:1]};
            
            else                               
                out <= out;                                 // Memoria
    end

endmodule