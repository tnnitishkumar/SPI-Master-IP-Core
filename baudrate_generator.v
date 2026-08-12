module baud_rate_generator(input pclk,preset_n,
	input [1:0]spi_mode,
	input spiswai,
	input [2:0]sppr,spr,
	input cpol,cpha,ss,
	output reg sclk,miso_receive_sclk,miso_receive_sclk0,mosi_send_sclk,mosi_send_sclk0,
	output [11:0]baud_rate_divisor);
reg [11:0]count;
wire pre_sclk;
parameter RUN=2'b00,
	WAIT=2'b01;
//baud rate division
assign baud_rate_divisor = ((sppr + 3'b1) * (2**(spr + 3'b1)));
//sclk generation
assign pre_sclk = cpol ? 1'b1 : 1'b1;
always@(posedge pclk or negedge preset_n)
	if(!preset_n)
	begin
		count<=0;
		sclk<=pre_sclk;
	end
	else if((ss==1'b0) && (spiswai==1'b0) && ((spi_mode==2'b00 || spi_mode==2'b01)))
	begin
		if(count==(baud_rate_divisor/2)-1'b1)
		begin
			count<=0;
			sclk<=~sclk;
		end
		else
		begin
			count<=count+1;
			sclk<=sclk;
		end
	end
//miso receive flag
always@(posedge pclk or negedge preset_n)
begin
	if(!preset_n)
	begin
		miso_receive_sclk<=1'b0;
		miso_receive_sclk0<=1'b0;
	end
	else if(cpol==cpha)
	begin
		if(!sclk)
		begin
			miso_receive_sclk<=(count==(baud_rate_divisor/2)-1)?1'b1:1'b0;
			miso_receive_sclk0<=1'b0;
		end
		else
			miso_receive_sclk<=0;
	end
	else if(cpol!=cpha)
	begin
		if(sclk)
		begin
			miso_receive_sclk0<=(count==(baud_rate_divisor/2)-1)?1'b1:1'b0;
			miso_receive_sclk<=1'b0;
		end
		else
			miso_receive_sclk0<=0;
	end
end
//mosi send flag
always@(posedge pclk or negedge preset_n)
begin
	if(!preset_n)
	begin
		mosi_send_sclk<=1'b0;
		mosi_send_sclk0<=1'b0;
	end
	else if(cpol==cpha)
	begin
		if(!sclk)
		begin
			mosi_send_sclk<=(count==(baud_rate_divisor/2)-2)?1'b1:1'b0;
			mosi_send_sclk0<=1'b0;
		end
		else
			mosi_send_sclk<=0;
	end
	else if(cpol!=cpha)
	begin
		if(sclk)
		begin
			mosi_send_sclk0<=(count==(baud_rate_divisor/2)-2)?1'b1:1'b0;
			mosi_send_sclk<=1'b0;
		end
		else
			mosi_send_sclk0<=0;
	end
end
endmodule
