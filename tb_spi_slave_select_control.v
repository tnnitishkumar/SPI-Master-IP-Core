module slave_control_select_tb;
reg pclk,preset_n,mstr,spiswai,send_data;
reg [1:0]spi_mode;
reg [11:0]baud_rate_divisor;
wire receive_data,ss,tip;
slave_control_select UUT(pclk,preset_n,mstr,spiswai,spi_mode,send_data,baud_rate_divisor,ss,receive_data,tip);
always #10 pclk =~pclk;
task initialize;
	begin
		{pclk,preset_n,mstr,spiswai,spi_mode,send_data,baud_rate_divisor}=0;
	end
endtask
task reset;
	begin
		@(negedge pclk);
		preset_n=0;
		@(negedge pclk);
		preset_n=1;
	end
endtask
task mode_selection(input [1:0]s);
	begin
		spi_mode=s;
	end
endtask
task stimulus(input [11:0]b);
	begin
		mstr=1'b1;
		spiswai=1'b0;
		baud_rate_divisor=b;
		send_data=1'b1;
		@(negedge pclk);
		send_data=1'b0;
	end
endtask
initial
begin
	initialize;
	reset;
	mode_selection(0);
	stimulus(4);
	#2000 $finish;
end
endmodule
