//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo es la máquina de estados propuesta      //
//              en el diseño presentado en PP. La implementac-      //
//              ión es el módulo recepción.                         //
//                                                                  //
//  Date    :   13/Abr/2024                                         //
//////////////////////////////////////////////////////////////////////

module FSM_UART_REC (
    input   wire                        clk, rst, rx,         // Señales de control
    input   wire    [3:0]               dataCntRx,                      // Señal de monitoreo

    output  reg                         countEnaRx, regEna, rxFlag, FSMrst        // Señales de salida de la FSM
); 
    
    (* syn_encoding = "user" *) reg [2:0] state;                            // Variable para control de estados
                                                                            // Definición de los estados
    localparam [2:0]IDDLE       = 3'b000;                                   // Estado iddle
    localparam [2:0]RECEPT      = 3'b001;                                    // Estado para comenzar la transición de datos
    localparam [2:0]STOP        = 3'b010;                                     

    always @(posedge clk, negedge rst) begin
        if (!rst)
            state <= IDDLE;

        else
            case (state)                                                // Movimiento de estados 
                IDDLE:
                    if (!rx)                                            // Botón presionado
                        state <= RECEPT;

                    else
                        state <= IDDLE;

                RECEPT: 
                    if (dataCntRx < 7)                        //6 jala simulacion          // La condición de cambio de estado a PARITY es que se hayan transmitido los 8 bits de información
                        state <= RECEPT;
                    
                    else
                        state <= STOP;

                STOP:
                    state <= IDDLE;

                default: 
                    state <= IDDLE;

            endcase
        
    end

    always @(state) begin                                               // Banderas de los estados
        case (state)
            IDDLE:  begin
                countEnaRx  = 1'b0;                                      // Bandera para activar el conteo de los bits de información
                regEna      = 1'b0;                                          // Bandera para activar la captura de datos en el registro serial
                rxFlag      = 1'b0;                                          // Bandera para indicar que todos los datos se han mandado correctamente
                FSMrst      = 1'b0;                                          // Reset del registro por medio de la máquina de estados
            end

            RECEPT: begin
                countEnaRx  = 1'b1;                                      
                regEna      = 1'b1;
                rxFlag      = 1'b0;
                FSMrst      = 1'b1;
            end

            STOP: begin
                countEnaRx  = 1'b0;
                regEna      = 1'b0;
                rxFlag      = 1'b1;
                FSMrst      = 1'b1;
            end

            default: begin
                countEnaRx  = 1'b0;
                regEna      = 1'b0;
                rxFlag      = 1'b0;
                FSMrst      = 1'b0;
            end

        endcase

    end

endmodule