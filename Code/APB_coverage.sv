//Ammar Ahmed Wahidi
package APB_coverage_pkg ;
import APB_sequence_item_pkg ::*;

class APB_coverage ;

APB_sequence_item seq = new();
covergroup cg;
cp_reset: coverpoint seq.PRESETn ;
cp_Register_Adress: coverpoint seq.PADDR 
{
    bins    SYS_STATUS_REG   =      {16'h0000};
	bins	INT_CTRL_REG     =		{16'h0040};
	bins	DEV_ID_REG       =		{16'h0080}; 
	bins	MEM_CTRL_REG     =		{16'h00c0}; 
	bins	TEMP_SENSOR_REG  =		{16'h0100}; 
	bins	ADC_CTRL_REG     =		{16'h0140}; 
	bins	DBG_CTRL_REG     =		{16'h0180}; 
	bins	GPIO_DATA_REG    =		{16'h01c0}; 
	bins	DAC_OUTPUT_REG   =		{16'h0200}; 
	bins	VOLTAGE_CTRL_REG =	    {16'h0240}; 
	bins	CLK_CONFIG_REG   =		{16'h0280}; 
	bins	TIMER_COUNT_REG  =		{16'h02c0}; 
	bins	INPUT_DATA_REG   =		{16'h0300}; 
	bins	OUTPUT_DATA_REG  =		{16'h0340};
	bins	DMA_CTRL_REG     =		{16'h0380};
	bins	SYS_CTRL_REG     =		{16'h03c0};
    bins    others           =      default;
}
cp_select : coverpoint seq.PSELx 
{
    bins High =  {1};
    bins Low  =  {0};
}

cp_Write_Read: coverpoint seq.PWRITE
{
    bins High =  {1};
    bins Low  =  {0};    
}

cross cp_Register_Adress,cp_select,cp_Write_Read;

endgroup :cg

task sample_data (APB_sequence_item item);
seq = item ;
cg.sample();
endtask

function new() ;
cg=new();    
endfunction
endclass :APB_coverage
endpackage :APB_coverage_pkg