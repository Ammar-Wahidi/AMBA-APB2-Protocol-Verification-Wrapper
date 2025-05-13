module APB_top ;
bit PCLK ;
always #5 PCLK=~PCLK;

APB_interface apb_intf (PCLK);
APB_Wrapper DUT (
  .PCLK     (apb_intf.PCLK),      // Clock input
  .PRESETn  (apb_intf.PRESETn),   // Active-low reset
  .PADDR    (apb_intf.PADDR),     // Address bus
  .PWRITE   (apb_intf.PWRITE),    // Write enable
  .PWDATA   (apb_intf.PWDATA),    // Write data
  .PENABLE  (apb_intf.PENABLE),   // Enable signal
  .PSELx    (apb_intf.PSELx),     // Select signal (may be vector if multiple slaves)
  .PREADY   (apb_intf.PREADY),    // Slave ready output
  .PRDATA   (apb_intf.PRDATA)     // Read data output
);

APB_Wrapper_tb Test (apb_intf);
//bind APB_Wrapper APB_svr sva (apb_intf);
//bind APB_Wrapper APB_svr APB_Wrapper_sva(apb_intf);

endmodule