module FPU(
// Inputs
    input   wire          clk, rst, rx,
// Outputs
    output  wire          ready, error, tx
);

    wire [15:0] rxData;
    // BaudRate
    wire        baudRateOut/*synthesis keep*/;                                                // Configurado a 9600 Baudios

// Counter
    wire [3:0]  counterOutTx;
    wire [3:0]  counterOutTx2;
    wire [3:0]  counterOutRx;
    wire [3:0]  counterOutRx2;

// FSM
    wire        FSMEnaTx;
    wire        FSMEnaTx2;
    wire        FSMEnaCRx;
    wire        FSMEnaRRx;
    wire        FSMrstTxOut;
    wire        FSMrstTx2Out;
    wire        FSMrstRxOut;
    wire        rxFlag;
    wire        rxFlag8;
    wire        rxFlag16;
    wire        txSendOut;
    wire        txReady;

// Register
    wire        [8:0] outRegisterRx;

//  Mix
    wire        bothRstTx; 
    wire        bothRstTx2; 
    wire        bothRstRx; 
    wire        start;
    wire        mrst;

// Assing   
    assign      bothRstTx   =   rst & FSMrstTxOut;                                   // Señal para incluir el reset recibido por la parte de la FSM
    assign      bothRstTx2  =   rst & FSMrstTx2Out;                                   // Señal para incluir el reset recibido por la parte de la FSM
    assign      bothRstRx   =   rst & FSMrstRxOut;                                   // Señal para incluir el reset recibido por la parte de la FSM
    assign      rxFlag8     =   counterOutRx[3] & ~counterOutRx[2] & ~counterOutRx[1] & ~counterOutRx[0];
    assign      rxFlag16    =   counterOutRx[3] & ~counterOutRx[2] & ~counterOutRx[1] & ~counterOutRx[0] & counterOutRx2[0];

// FSM FPU
    wire    [17:0]  AOut, BOut;
    wire    [15:0]  RIn, ROut;
    wire    [1:0]   OOut;
    wire            enaAFSM, enaBFSM, enaOFSM, enaRFSM;

    FSM     I0  (.clk(baudRateOut), .rst(rst), .A(AOut), .B(BOut), .O(OOut), .R(ROut), .start(rxFlag16), .ready(ready), .error(error), .enaAFSM(enaAFSM), .enaBFSM(enaBFSM), .enaOFSM(enaOFSM), .enaRFSM(enaRFSM), .result(RIn), .txSend(txSendOut), .txReady(txReady));

    Register    #(.N(18))       RA(.clk(baudRateOut), .rst(rst), .ena(enaAFSM), .in({rxData[15:10], 2'b01, rxData[9:0]}),        .out(AOut));
    Register    #(.N(18))       RB(.clk(baudRateOut), .rst(rst), .ena(enaBFSM), .in({rxData[15:10], 2'b01, rxData[9:0]}),        .out(BOut));
    Register    #(.N(16))       RR(.clk(baudRateOut), .rst(rst), .ena(enaRFSM), .in(RIn),           .out(ROut));
    Register    #(.N(2))        RO(.clk(baudRateOut), .rst(rst), .ena(enaOFSM), .in(rxData[1:0]),   .out(OOut));



    Counter     #(.STOP(434))       I1  (.in(clk), .rst(rst), .ena(1'b1), .clk(baudRateOut));               // 115200
    
    Counter	    #(.STOP(16))        ITx (.in(baudRateOut),  .rst(bothRstTx), .ena(FSMEnaTx),   .cnt(counterOutTx));
    Counter	    #(.STOP(16))        ITx2(.in(baudRateOut),  .rst(bothRstTx2), .ena(FSMEnaTx2),   .cnt(counterOutTx2));
    FSM_UART_TRANS                  I2  (.clk(baudRateOut), .rst(rst), .txSend(txSendOut), .dataCntTx(counterOutTx), .dataCntTx2(counterOutTx2), .txData(ROut), .tx(tx), .countEnaTx(FSMEnaTx), .countEnaTx2(FSMEnaTx2), .tx4BFlag(txReady), .dataCntTxRST(FSMrstTxOut), .dataCntTxRST2(FSMrstTx2Out));
    
    Counter	    #(.STOP(16))        IRx (.in(baudRateOut), .rst(bothRstRx), .ena(FSMEnaCRx),  .cnt(counterOutRx));
    Counter	    #(.STOP(2))         IRx2(.in(baudRateOut), .rst(rst), .ena(rxFlag8),  .cnt(counterOutRx2));
    RSRegister  #(.N(16))           I4  (.clk(baudRateOut), .rst(rst), .ena(FSMEnaRRx), .SIn(rx), .out(rxData));
    FSM_UART_REC                    I3  (.clk(baudRateOut), .rst(rst), .rx(rx), .dataCntRx(counterOutRx), .countEnaRx(FSMEnaCRx), .regEna(FSMEnaRRx), .rxFlag(rxFlag), .FSMrst(FSMrstRxOut));
endmodule

