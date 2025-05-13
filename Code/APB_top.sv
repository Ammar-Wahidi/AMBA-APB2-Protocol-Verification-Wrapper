module APB_top ;
bit PCLK ;
always #5 PCLK=~PCLK;

APB_interface apb_intf (PCLK);
APB_Wrapper DUT (apb_intf);

APB_Wrapper_tb Test (apb_intf);
bind APB_Wrapper APB_svr sva (apb_intf);


endmodule