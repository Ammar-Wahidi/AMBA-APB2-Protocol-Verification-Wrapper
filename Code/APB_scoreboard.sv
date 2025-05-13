//Ammar Ahmed Wahidi
package APB_scoreboard_pkg ;
import APB_sequence_item_pkg ::*;
class APB_scoreboard;
parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;
int right_count,wrong_count;
	typedef enum logic [2:0] {
	IDLE   = 3'b001,
	SETUP  = 3'b011,
	ENABLE = 3'b010,
	READY  = 3'b110} state_e;

    logic [ADDR_WIDTH-1 : 0]        PADDR_ex    ;
    logic                           PWRITE_ex   ;
    logic [DATA_WIDTH-1 : 0]        PWDATA_ex   ;
    logic                           PENABLE_ex  ;
    logic                           PSELx_ex    ;

    logic                           PREADY_ex   ;
    logic [DATA_WIDTH-1 : 0]        PRDATA_ex   ;  

APB_sequence_item score_sequence =new();
state_e CurrentState,NextState;
bit correct_slave;
logic [1:0] encoding;
logic [3:0] address_encoding;

task display_signals();
  $display("\n---[APB Signal Snapshot @ time = %0t]---", $time);
  $display("Input Sequence:");
  $display("  PRESETn   = %0b", score_sequence.PRESETn);
  $display("  PADDR     = 0x%0h", score_sequence.PADDR);
  $display("  PWRITE    = %0b", score_sequence.PWRITE);
  $display("  PWDATA    = 0x%0h", score_sequence.PWDATA);
  $display("  PENABLE   = %0b", score_sequence.PENABLE);
  $display("  PSELx     = %0b", score_sequence.PSELx);
  $display("  PREADY    = %0b", score_sequence.PREADY);
  $display("  PRDATA    = 0x%0h", score_sequence.PRDATA);
  
  $display("Expected Outputs (Based on FSM):");
  $display("  PREADY_ex = %0b", PREADY_ex);
  $display("  PRDATA_ex = 0x%0h", PRDATA_ex);
  $display("--------------------------------------\n");
endtask

task referencemodal();
// ADDRESS Decoding
encoding = score_sequence.PADDR[ADDR_WIDTH-1:ADDR_WIDTH-2];
        if (score_sequence.PSELx) begin
            case (encoding)
                2'b00: address_encoding = 4'b0001; 
                2'b01: address_encoding = 4'b0010; 
                2'b10: address_encoding = 4'b0100; 
                2'b11: address_encoding = 4'b1000; 
                default: address_encoding = 4'b0000;
            endcase
        end else begin
            address_encoding = 0;
        end
correct_slave = score_sequence.PSELx & (4'b0001==address_encoding) ; //working on one slave ID=0001

//output logic 
if (!score_sequence.PRESETn)
begin
        PREADY_ex                      =0;
        PRDATA_ex                      =0;
end
else
begin
    case(CurrentState)
    IDLE: begin
        PREADY_ex                      =0; 
    end
    SETUP: begin
        PREADY_ex                      =0;
    end
    ENABLE: begin
        PREADY_ex                      =0;
    end
    READY: begin
        PREADY_ex                      =1;
        PRDATA_ex                      =score_sequence.PRDATA;
    end
    endcase
end    
// Next State Logic
    case (CurrentState)
    IDLE :begin
        if (score_sequence.PSELx & correct_slave)
        begin
            NextState=SETUP;
        end
        else begin
            NextState=IDLE;
        end
    end
    SETUP: begin
        if (~score_sequence.PSELx & ~correct_slave ) begin
            NextState = IDLE;
        end
        else if (~score_sequence.PENABLE) begin
            NextState=SETUP;
        end
        else if (score_sequence.PENABLE) begin
            NextState= ENABLE;
        end
        else begin
            NextState=SETUP;
        end
    end 
    ENABLE: begin
            NextState=READY;
    end
    READY: begin
        if (score_sequence.PSELx & correct_slave) begin 
            NextState=SETUP;
        end
        else begin
            NextState=IDLE;
        end
    end

    endcase 
//State Memory
    if (!score_sequence.PRESETn)
    begin
        CurrentState = IDLE;
        CurrentState = IDLE;
    end
    else
    begin
        CurrentState = NextState;
    end

endtask

task scoreboard(APB_sequence_item score_sequence_task);
score_sequence = score_sequence_task;
referencemodal();
if (score_sequence.PREADY==PREADY_ex && score_sequence.PRDATA===PRDATA_ex)
begin
    right_count++;
    $display ("Right count = %0d, Wrong count = %0d, time =%0t",right_count,wrong_count,$time);
end
else
begin
    wrong_count++;
    $display ("Right count = %0d, Wrong count = %0d, time =%0t",right_count,wrong_count,$time);  
end
 display_signals();
endtask

endclass
endpackage