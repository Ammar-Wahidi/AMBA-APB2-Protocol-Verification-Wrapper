//Ammar Ahmed Wahidi
package APB_sequence_item_pkg ;
class APB_sequence_item;

    parameter DATA_WIDTH = 32				  ;
    parameter ADDR_WIDTH = 16         ;

// Global Sinals
rand bit                        PRESETn       ;
// Slave FROM Master
rand logic [ADDR_WIDTH-1 : 0]   PADDR         ;
rand logic                      PWRITE        ;
rand logic [DATA_WIDTH-1 : 0]   PWDATA        ;
rand logic                      PENABLE       ;
rand logic                      PSELx         ;
// Slave TO Master
logic                           PREADY        ;
logic      [DATA_WIDTH-1 : 0]   PRDATA        ;  

const logic [15:0] specific_addrs [0:15] = '{
        16'h0000, 16'h0040, 16'h0080, 16'h00c0,
        16'h0100, 16'h0140, 16'h0180, 16'h01c0,
        16'h0200, 16'h0240, 16'h0280, 16'h02c0,
        16'h0300, 16'h0340, 16'h0380, 16'h03c0
    };

constraint seq 
{
    PRESETn dist {1:=90, 0:=10 };


        PADDR dist {
            specific_addrs :/ 90, // 90% weight for specific addresses
            [0:16'hFFFF]   :/ 10  // 10% weight for all other addresses
        };
                PWDATA inside {[0:32'hFFFFFFFF]};
    // Allow any 32-bit value for write data
    PWRITE  dist {1:=50, 0:=50 };
    PENABLE dist {1:=90, 0:=10 };
    PSELx   dist {1:=90, 0:=10 }; 

}
endclass
endpackage