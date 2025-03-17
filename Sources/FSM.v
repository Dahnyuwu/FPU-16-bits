module FSM(
// Inputs
    input   wire                        clk, rst, start,                        // Señales de control
    input   wire    [17:0]              A, B,
    input   wire    [1:0]               O,
    input   wire    [15:0]              R,
// Outputs
    output  reg                         enaAFSM, enaBFSM, enaOFSM, enaRFSM, ready, error,                            // Señales de salida de la FSM
    output  reg     [15:0]              result
); 

    reg         sa, sb, st;
    reg [4:0]   ea, eb, et;
    reg [11:0]  ma, mb, mt;
    reg [21:0]  mm, md;
    reg [1:0]   op;

    reg [10:0]  temp;


// Variables de estados
    (* syn_encoding = "user" *) reg [3:0] state;                                //\\ Variable para control de estados

    localparam [3:0]IDDLE           = 4'h0;                                   // Estado de reposo
    localparam [3:0]GETA            = 4'h1;                                   // Estado de inicio, se inicializan módulos auxiliares
    localparam [3:0]GETB            = 4'h2;                                   // Estado de transiciones
    localparam [3:0]GETOP           = 4'h3;                                   // Se generan 2 para provocar un cambio en las salidas
    localparam [3:0]SELECT          = 4'h4;                                   // Se generan 2 para provocar un cambio en las salidas
    localparam [3:0]ADDITION        = 4'h5;                                   // Estado de cálculo de paridad
    localparam [3:0]SUBTRACTION     = 4'h6;                                   // Estado de cálculo de paridad
    localparam [3:0]MULTIPLICATION  = 4'h7;                                   // Estado de cálculo de paridad
    localparam [3:0]DIVISION        = 4'h8;                                   // Estado de cálculo de paridad
    localparam [3:0]EVALUATION      = 4'h9;                                   // Estado de cálculo de paridad
    localparam [3:0]READY           = 4'ha;                                   // Estado de cálculo de paridad
    localparam [3:0]ERROR           = 4'hb;                                   // Estado transmición de bit stop
// Bloque de cambio de estados
    always @(posedge clk, negedge rst) begin
        if (!rst)
            state = IDDLE;

        else
            case (state)                                                   
                IDDLE:
                    if (start)                                           
                        state = GETA;

                    else
                        state = IDDLE;

                GETA:
                    if (start)  
                        state = GETB;

                    else 
                        state = GETA;

                GETB: 
                    if (start)
                        state = GETOP;

                    else
                        state = GETB;

                GETOP:
                    if (start)
                        state = SELECT;

                    else
                        state = GETOP;

                SELECT:
                    case (O)
                        2'b00:
                            state = ADDITION;

                        2'b01:
                            state = SUBTRACTION;

                        2'b10:
                            state = MULTIPLICATION;

                        2'b11:
                            state = DIVISION;

                        default: 
                            state = ERROR;

                    endcase
                    

                ADDITION:
                    state = EVALUATION;

                SUBTRACTION:
                    state = EVALUATION;

                MULTIPLICATION:
                    state = EVALUATION;

                DIVISION:
                    state = EVALUATION;

                EVALUATION:
                    if (R[14:10] == 31)
                        state = ERROR;

                    else
                        state = READY;

                ERROR:
                    state = IDDLE;

                READY:
                    state = IDDLE;

                default: 
                    state = ERROR;

            endcase
        
    end

// Generacion de datos
    always @(state) begin
// Default values
        error  = 1'b0;
        ready  = 1'b0;
        sa     = 1'b0;
        sb     = 1'b0;
        st     = 1'b0;
        ea     = 5'b0;
        eb     = 5'b0;
        et     = 5'b0;
        ma     = 12'b0;
        mb     = 12'b0;
        mt     = 12'b0;
        mm     = 22'b0;
        md     = 22'b0;
        op     = 2'b0;
        result = 16'b0;
        temp   = 11'b0;

        case (state)             
// IDDLE
            IDDLE:  begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
            end
// GET A
            GETA: begin
                error   = 1'b0;
                ready   = 1'b0;
                enaAFSM = 1'b1;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;

            end
// GET B
            GETB: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b1;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;
                
            end  
// GET OP
            GETOP: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b1;
                enaRFSM = 1'b0;

                // ma = {1'b0, 1'b1, ma[9:0]};     // Ajustando 1.M
                // mb = {1'b0, 1'b1, mb[9:0]};
            end 
// Select
            SELECT: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
            end
// Addtion
            ADDITION: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b1;

                sa = A[17];
                ea = A[16:12];
                ma = A[11:0];   

                sb = B[17];
                eb = B[16:12];
                mb = B[11:0];   
                
                if (ea > eb) begin              // Resta del menor exponente para hacer shifteo
                    temp = ea - eb;
                    et = ea;
                    st = sa;
                    mb = mb >> temp;
                end

                else
                    if (eb > ea) begin
                        temp = eb - ea;
                        et = eb;
                        st = sb;
                        ma = ma >> temp;
                    end

                    else begin
                        temp = 10'b0;
                        et = ea;
                        st = sa;
                    end

                if (sa ^ sb)                    // Verificación de tipo de operacion a realizar. Signos iguales suma, diferentes resta
                    if (ma > mb) begin
                        mt = ma - mb;
                        st = sa;
                    end

                    else begin
                        mt = mb - ma;
                        st = sb;
                    end

                else 
                    mt = ma + mb;

                if (mt[11]) begin               // Normalización de carry 10.M >> 1.M (+1 exp)
                    mt = mt >> 1'b1;
                    et = et + 1'b1;
                end

                else 
                    while (mt[10] != 1 && mt > 0) begin  // Normalización de carry 0.0001M << 1.M (-1 exp)
                        mt = mt << 1'b1;
                        et = et - 1'b1;
                    end

                result = {st, et, mt[9:0]};     // 

            end 
// Subtraction
            SUBTRACTION: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b1;

                sa = A[17];
                ea = A[16:12];
                ma = A[11:0];   

                sb = ~(B[17]);
                eb = B[16:12];
                mb = B[11:0];   
                
                if (ea > eb) begin              // Resta del menor exponente para hacer shifteo
                    temp = ea - eb;
                    et = ea;
                    st = sa;
                    mb = mb >> temp;
                end

                else
                    if (eb > ea) begin
                        temp = eb - ea;
                        et = eb;
                        st = sb;
                        ma = ma >> temp;
                    end

                    else begin
                        temp = 10'b0;
                        et = ea;
                        st = sa;
                    end

                if (sa ^ sb)                    // Verificación de tipo de operacion a realizar. Signos iguales suma, diferentes resta
                    if (ma > mb) begin
                        mt = ma - mb;
                        st = sa;
                    end

                    else begin
                        mt = mb - ma;
                        st = sb;
                    end

                else 
                    mt = ma + mb;

                if (mt[11]) begin               // Normalización de carry 10.M >> 1.M (+1 exp)
                    mt = mt >> 1'b1;
                    et = et + 1'b1;
                end

                else 
                    while (mt[10] != 1 && mt > 0) begin  // Normalización de carry 0.0001M << 1.M (-1 exp)
                        mt = mt << 1'b1;
                        et = et - 1'b1;
                    end

                result = {st, et, mt[9:0]};     // 
            end

// Multiplication 
            MULTIPLICATION: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b1;

                sa = A[17];
                ea = A[16:12];
                ma = A[11:0];   

                sb = B[17];
                eb = B[16:12];
                mb = B[11:0];   

                ea = ea - 4'hF;
                eb = eb - 4'hF;
                mm = ma * mb;
                mt = mm[21:10];                   // Truncamos los bits más significativos
                st = sa ^ sb;
                et = ea + eb;

                if (et != 5'h1E) begin               // Caso de OVERFLOW
                    if (mt[11]) begin               // Normalización de carry 10.M >> 1.M (+1 exp)
                        mt = mt >> 1'b1;
                        et = et + 1'b1;
                    end

                    else 
                        while (mt[10] != 1 && mt > 0) begin  // Normalización de carry 0.0001M << 1.M (-1 exp)
                            mt = mt << 1'b1;
                            et = et - 1'b1;
                        end

                    et = et + 4'hF;
                    result = {st, et, mt[9:0]};     // 

                end

                else 
                    et = 5'd31;

            end 

// Division
            DIVISION: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b1;

                sa = A[17];
                ea = A[16:12];
                ma = A[11:0];   

                sb = B[17];
                eb = B[16:12];
                mb = B[11:0];   

                if (eb != 1'b0) begin               // Caso de division por 0
                    ea = ea - 4'hF;
                    eb = eb - 4'hF;
                    md = ma << 10;
                    mt = md / mb;
                    st = sa ^ sb;
                    et = ea - eb;
                
                    if (mt) begin
                        if (mt[11]) begin               // Normalización de carry 10.M >> 1.M (+1 exp)
                            mt = mt >> 1'b1;
                            et = et + 1'b1;
                        end

                        else
                            while (mt[10] != 1 && mt > 0) begin  // Normalización de carry 0.0001M << 1.M (-1 exp)
                                mt = mt << 1'b1;
                                et = et - 1'b1;
                            end

                        et = et + 4'hF;
                        result = {st, et, mt[9:0]};     // 
                    end

                    else 
                        et = 5'd31;
                end

                else 
                    et = 5'd31;

            end 

            EVALUATION: begin
                error = 1'b0;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;
            end

            READY: begin
                error = 1'b0;
                ready = 1'b1;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;
            end


            ERROR: begin
                error = 1'b1;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;
            end

            default: begin
                error = 1'b1;
                ready = 1'b0;
                enaAFSM = 1'b0;
                enaBFSM = 1'b0;
                enaOFSM = 1'b0;
                enaRFSM = 1'b0;
            end

        endcase

    end
endmodule
