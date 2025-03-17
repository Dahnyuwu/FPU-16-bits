//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo nos ayuda a generar los registros       //
//              necesarios para las señales de entrada y sal-       //
//              ida de la ALU, con un parámetro de entrada L-       //
//              ENGTH que nos ayuda a determinar su tamaño.         //
//                                                                  //
//  Date    :   20/Feb/2024                                         //
//////////////////////////////////////////////////////////////////////

module Register #(parameter N = 32, RSTVALUE = 32'b0)(
// Entradas
    input   wire    [(N-1):0]      in,                         // Señal de entrada del registro
    input   wire                        clk, rst, ena,              // Señales de control
    
// Salidas    
    output  reg     [(N-1):0]      out                         // Salida del registro
);

    always @(posedge clk) begin

        if (!rst)                                                   // Reset
            out <= {RSTVALUE};

        else
            if (ena)                                                // Enable
                out <= in;
					 
			else                                                    // Memoria
				out <= out;
        
    end

endmodule