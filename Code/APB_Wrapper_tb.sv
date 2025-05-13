//Ammar Ahmed Wahidi
import APB_sequence_item_pkg ::*;
import APB_monitor_pkg ::*;
module APB_Wrapper_tb (APB_interface.Test apb_intf ) ;

APB_sequence_item seq = new();
APB_monitor monitor = new();


task automatic drive_to_scoreboard();
  seq.PREADY = apb_intf.PREADY;
  seq.PRDATA = apb_intf.PRDATA;
  monitor.monitor(seq);       
endtask

task automatic drive_apb_transaction(
        bit write,              
        logic [15:0] addr,      
        logic [31:0] data 
    );
    logic [1:0] encoding;
    logic [3:0] address_encoding;
    bit correct_slave;
    //IDLE Phase: PSELx = 0, PENABLE = 0
    assert (seq.randomize() with {
        PENABLE == 0;
        PWRITE == write;
        PADDR == addr;
        PWDATA == data;
    });
    apb_intf.PADDR   = seq.PADDR;
    apb_intf.PWRITE  = seq.PWRITE;
    apb_intf.PWDATA  = seq.PWDATA;
    apb_intf.PSELx   = seq.PSELx;
    apb_intf.PENABLE = seq.PENABLE;
    apb_intf.PRESETn = seq.PRESETn;
    @(posedge apb_intf.PCLK);
    drive_to_scoreboard();

    if (!seq.PRESETn && ~seq.PSELx) begin
        $display("Reset active (PRESETn = 0), staying in IDLE at time %0t", $time); 
        return;
    end
    //SETUP phase: PSELx = 1, PENABLE = 0
    assert (seq.randomize() with {
        PENABLE == 0;
        PSELx == 1;
        PWRITE == write;
        PADDR == addr;
        PWDATA == data;
        });
    apb_intf.PADDR   = seq.PADDR;
    apb_intf.PWRITE  = seq.PWRITE;
    apb_intf.PWDATA  = seq.PWDATA;
    apb_intf.PSELx   = seq.PSELx;
    apb_intf.PENABLE = seq.PENABLE;
    apb_intf.PRESETn = seq.PRESETn;
     $display("SETUP: addr=0x%h write=%b", addr, write); 
    @(posedge apb_intf.PCLK);
    drive_to_scoreboard();
    encoding = seq.PADDR[15:14];
    case (encoding)
        2'b00: address_encoding = 4'b0001; 
        2'b01: address_encoding = 4'b0010; 
        2'b10: address_encoding = 4'b0100; 
        2'b11: address_encoding = 4'b1000; 
        default: address_encoding = 4'b0000;
    endcase
    correct_slave = seq.PSELx & (4'b0001 == address_encoding);
    //Check if we should return to IDLE
    if (!seq.PSELx || !correct_slave || ~seq.PRESETn) begin
        $display("Returning to IDLE due to ~PSELx or incorrect slave at time %0t", $time); 
        return;
    end
    //Hold When Enable = 0
    while (~seq.PENABLE) begin
      assert (seq.randomize())
        apb_intf.PSELx   = seq.PSELx;
        apb_intf.PENABLE = seq.PENABLE;
        apb_intf.PRESETn = seq.PRESETn;
        $display("SETUP: addr=0x%h write=%b", addr, write); 
        @(posedge apb_intf.PCLK);
        drive_to_scoreboard();
        case (encoding)
        2'b00: address_encoding = 4'b0001; 
        2'b01: address_encoding = 4'b0010; 
        2'b10: address_encoding = 4'b0100; 
        2'b11: address_encoding = 4'b1000; 
        default: address_encoding = 4'b0000;
    endcase
    correct_slave = seq.PSELx & (4'b0001 == address_encoding);
    // Check if we should return to IDLE
    if (!seq.PSELx || !correct_slave || ~seq.PRESETn) begin
        $display("Returning to IDLE due to ~PSELx or incorrect slave at time %0t", $time);
        return;
    end
    end
    // ENABLE phase: PENABLE = 1
    assert (seq.randomize() with {
        PENABLE == 0;
        PWRITE == write;
        PADDR == addr;
        PWDATA == data;
        PRESETn==1;
        });
    apb_intf.PADDR   = seq.PADDR;
    apb_intf.PWRITE  = seq.PWRITE;
    apb_intf.PWDATA  = seq.PWDATA;
    apb_intf.PSELx   = seq.PSELx;
    apb_intf.PENABLE = seq.PENABLE;
    apb_intf.PRESETn = seq.PRESETn;
    $display("ENABLE: addr=0x%h write=%b", addr, write); 
    @(posedge apb_intf.PCLK);
    drive_to_scoreboard();

    // READY phase: Wait for PREADY
    repeat (10) begin // Timeout after 10 cycles
        if (apb_intf.PREADY) begin
            $display("READY: addr=0x%h write=%b PREADY=%b PRDATA=0x%h",
            addr, write, apb_intf.PREADY, apb_intf.PRDATA); 
            break;
        end
        @(posedge apb_intf.PCLK);
        drive_to_scoreboard();
    end
    if (!apb_intf.PREADY) begin
        $warning("Timeout waiting for PREADY at addr=0x%h write=%b", addr, write); 
    end
    @(posedge apb_intf.PCLK);
    drive_to_scoreboard();
    // Post-READY transition: Decide next state based on PSELx and correct_slave
    assert (seq.randomize() with {
        PWRITE == 0;
        PWDATA == data;
        PADDR == addr;
        PENABLE == 0;
    });
    apb_intf.PADDR   = seq.PADDR;
    apb_intf.PWRITE  = seq.PWRITE;
    apb_intf.PWDATA  = seq.PWDATA;
    apb_intf.PSELx   = seq.PSELx;
    apb_intf.PENABLE = seq.PENABLE;
    apb_intf.PRESETn = seq.PRESETn;
    @(posedge apb_intf.PCLK);
    drive_to_scoreboard();

    encoding = seq.PADDR[15:14];
    case (encoding)
        2'b00: address_encoding = 4'b0001; 
        2'b01: address_encoding = 4'b0010; 
        2'b10: address_encoding = 4'b0100; 
        2'b11: address_encoding = 4'b1000; 
        default: address_encoding = 4'b0000;
    endcase
    correct_slave = seq.PSELx & (4'b0001 == address_encoding);

    if (!seq.PRESETn) begin
        $display("Reset active (PRESETn = 0), returning to IDLE at time %0t", $time);  
        return;
    end

    // Transition after READY
    if (!seq.PSELx) begin
        $display("PSELx = 0 after READY, returning to IDLE at time %0t", $time); 
        // Drive IDLE state
        return;
    end 
    else if (seq.PSELx && correct_slave) begin
        $display("PSELx = 1 and correct_slave = 1 after READY, moving to SETUP at time %0t", $time); 
        // Drive SETUP state
        assert (seq.randomize() with {
            PSELx == 1;
            PENABLE == 0;
            PWDATA == data;
            PWRITE == 0;
            PRESETn == 1;
        });
        apb_intf.PADDR   = seq.PADDR;
        addr             = seq.PADDR;
        apb_intf.PWRITE  = seq.PWRITE;
        apb_intf.PWDATA  = seq.PWDATA;
        apb_intf.PSELx   = seq.PSELx;
        apb_intf.PENABLE = seq.PENABLE;
        apb_intf.PRESETn = seq.PRESETn;
        @(posedge apb_intf.PCLK);
        drive_to_scoreboard();
        
        encoding = seq.PADDR[15:14];
        case (encoding)
            2'b00: address_encoding = 4'b0001; 
            2'b01: address_encoding = 4'b0010; 
            2'b10: address_encoding = 4'b0100; 
            2'b11: address_encoding = 4'b1000; 
            default: address_encoding = 4'b0000;
        endcase
        correct_slave = seq.PSELx & (4'b0001 == address_encoding);
        if (!seq.PSELx || !correct_slave || ~seq.PRESETn) begin
            $display("Returning to IDLE due to ~PSELx or incorrect slave at time %0t", $time); 
            return;
        end
        //Hold when enable =0
        while (~seq.PENABLE) begin
            assert (seq.randomize())
            apb_intf.PSELx   = seq.PSELx;
            apb_intf.PENABLE = seq.PENABLE;
            apb_intf.PRESETn = seq.PRESETn;
            $display("SETUP: addr=0x%h write=%b", addr, write); 
            @(posedge apb_intf.PCLK);
            drive_to_scoreboard();
            case (encoding)
            2'b00: address_encoding = 4'b0001; 
            2'b01: address_encoding = 4'b0010; 
            2'b10: address_encoding = 4'b0100; 
            2'b11: address_encoding = 4'b1000; 
            default: address_encoding = 4'b0000;
        endcase
        correct_slave = seq.PSELx & (4'b0001 == address_encoding);
        if (!seq.PSELx || !correct_slave || ~seq.PRESETn) begin
            $display("Returning to IDLE due to ~PSELx or incorrect slave at time %0t", $time); 
            return;
        end
        end
        // ENABLE phase: PSELx = 1, PENABLE = 1
        assert (seq.randomize() with {
            PENABLE == 0;
            PADDR == addr;
            PWDATA == data;
            PRESETn==1;
            PWRITE ==0;
        });
        apb_intf.PADDR   = seq.PADDR;
        apb_intf.PWRITE  = seq.PWRITE;
        apb_intf.PWDATA  = seq.PWDATA;
        apb_intf.PSELx   = seq.PSELx;
        apb_intf.PENABLE = seq.PENABLE;
        apb_intf.PRESETn = seq.PRESETn;
        $display("ENABLE: addr=0x%h write=%b", addr, write); 
        @(posedge apb_intf.PCLK);
        drive_to_scoreboard();

        // READY phase: Wait for PREADY
        repeat (10) begin // Timeout after 10 cycles
            if (apb_intf.PREADY) begin
                $display("READY: addr=0x%h write=%b PREADY=%b PRDATA=0x%h",
                         addr, write, apb_intf.PREADY, apb_intf.PRDATA); 
                break;
            end
            @(posedge apb_intf.PCLK);
            drive_to_scoreboard();
        end
        if (!apb_intf.PREADY) begin
            $warning("Timeout waiting for PREADY at addr=0x%h write=%b", addr, write); 
        end
        @(posedge apb_intf.PCLK); // Complete transaction
        drive_to_scoreboard();

    end 
    endtask

initial begin
apb_intf.PRESETn = 0;
seq.PRESETn = 0;
apb_intf.PSELx = 0;
apb_intf.PENABLE = 0;
apb_intf.PWRITE = 0;
apb_intf.PADDR = 0;
apb_intf.PWDATA = 0;
repeat (5) begin
    assert (seq.randomize());
    apb_intf.PRESETn =0;
    seq.PRESETn=apb_intf.PRESETn;
    @(posedge apb_intf.PCLK);
    seq.PREADY = apb_intf.PREADY;
    seq.PRDATA = apb_intf.PRDATA;
    monitor.monitor(seq);
    @(posedge apb_intf.PCLK);
end

@(posedge apb_intf.PCLK);
drive_to_scoreboard();  // First cycle

repeat (1500)
begin
    assert (seq.randomize());
        apb_intf.PADDR   = seq.PADDR;
        apb_intf.PWRITE  = seq.PWRITE;
        apb_intf.PWDATA  = seq.PWDATA;
        apb_intf.PSELx   = seq.PSELx;
        apb_intf.PENABLE = seq.PENABLE;
        apb_intf.PRESETn = seq.PRESETn;
        drive_apb_transaction(seq.PWRITE,seq.PADDR,seq.PWDATA);
  
end

$stop;
end

endmodule


