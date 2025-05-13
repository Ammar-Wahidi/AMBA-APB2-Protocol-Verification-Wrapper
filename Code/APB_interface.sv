//Ammar Ahmed Wahidi
interface APB_interface(PCLK);

    parameter DATA_WIDTH = 32				 ;
    parameter ADDR_WIDTH = 16                ;

input bit PCLK ;

bit                      PRESETn;

logic [ADDR_WIDTH-1 : 0] PADDR ;
logic                    PWRITE;
logic [DATA_WIDTH-1 : 0] PWDATA;
logic                    PENABLE;
logic                    PSELx;

logic                    PREADY;

logic [DATA_WIDTH-1 : 0] PRDATA;



modport DUT (input PCLK,PRESETn,PADDR,PWRITE,PWDATA,PENABLE,PSELx, output PREADY ,PRDATA  ) ; 
modport Test (input PCLK,PREADY,PRDATA, output PRESETn,PADDR,PWRITE,PWDATA ,PENABLE,PSELx);

endinterface