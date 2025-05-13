//Ammar Ahmed Wahidi
module APB_svr (APB_interface.DUT apb_intf);

always_comb 
begin
    if (~apb_intf.PRESETn)
    check_reset:assert final ( ~apb_intf.PREADY && ~apb_intf.PRDATA );
end

property set_up;
    @(posedge apb_intf.PCLK) disable iff (!apb_intf.PRESETn)
    (apb_intf.PSELx && !apb_intf.PENABLE) |-> ##1 ~apb_intf.PREADY ;
endproperty

check_setup:assert property (set_up) else $error("Ready rised on set up");
cover_setup:cover property (set_up) ;

property readyphase;
    @(posedge apb_intf.PCLK) disable iff (!apb_intf.PRESETn)
    (apb_intf.PSELx && apb_intf.PENABLE) |-> ##1 apb_intf.PREADY  ; 
endproperty

check_readyphase:assert property (readyphase) else $error ("Ready didn't rise on READY phase after Enable had rasied immediately");
cover_readtphase:cover property (readyphase);

property read;
    @(posedge apb_intf.PCLK) disable iff (!apb_intf.PRESETn)
      apb_intf.PSELx && apb_intf.PENABLE && !apb_intf.PWRITE |-> ##1 !apb_intf.PWRITE;
endproperty

apb_read_assert: assert property(read) else $error("Assertion failed: Write detected during read!");
cover_apb_readas:cover property(read);


endmodule