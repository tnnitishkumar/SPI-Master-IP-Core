module shift_register_tb();
 reg pclk,preset,ss,send_data,lsbfe,cpha,cpol,miso_recieve_sclk_o,miso_recieve_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,miso,rcv_data;
 reg [7:0]data_mosi;
 wire mosi_o;
 wire[7:0]data_miso_o;
 reg spi_swai;
 reg[2:0]sppr_i,spr_i;
 reg[1:0]spi_mode;
 reg sclk;
 reg[11:0]brd;
 reg [15:0]count;
 parameter CYCLE=10;
  shift_register DUT(pclk,preset,ss,send_data,lsbfe,cpha,cpol,miso_recieve_sclk_o,miso_recieve_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,data_mosi,miso,rcv_data,mosi,data_miso);
 // logic for count
always@(posedge pclk or negedge preset)
begin
	if(!preset)
        count<=16'b0;
 else if(((spi_mode==2'b00)||(spi_mode==2'b01))&&(!ss)&&(!spi_swai))
 begin
	 if(count==((brd/2)-1'b1))
		 count<=16'b0;
  
	 else
		 count<=count+1'b1;
 end

end
//logic for miso_recieve_sclk0_o
always@(posedge pclk or negedge preset)
begin
	if(!preset)
		miso_recieve_sclk0_o<=1'b0;
	else if((~cpha&&cpol)||(~cpol&&cpha))
	begin
            if(~	sclk)
               begin 
		if(count==(brd/2)-1'b1)
			miso_recieve_sclk0_o<=1'b1;
		else
			miso_recieve_sclk0_o<=1'b0;
end
else 
 miso_recieve_sclk0_o<=1'b0;
	end
end
//logic for miso_recieve_sclk_o
always@(posedge pclk or negedge preset)
begin
	if(!preset)
		miso_recieve_sclk_o<=1'b0;
	else if((~cpha&&~cpol)||(cpol&&cpha))
	begin
         if(sclk)
               begin
		if(count==((brd/2)-1'b1))
			miso_recieve_sclk_o<=1'b1;
		else
			miso_recieve_sclk_o<=1'b0;
	end
		else 
		      miso_recieve_sclk_o<=1'b0;
end
end
//logic for mosi_send_sclk_o
always@(posedge pclk or negedge preset)
begin
	if(!preset)
		mosi_send_sclk_o<=1'b0;
	else if((cpha&&cpol)||(~cpol&&~cpha))
	begin
            if(~sclk)
              begin
		if(count==((brd/2)-2'b10))
			mosi_send_sclk_o<=1'b1;
		else
			mosi_send_sclk_o<=1'b0;
		end
else
			mosi_send_sclk_o<=1'b0;
	end
		else
			mosi_send_sclk_o<=1'b0;
end
//logic for mosi_send_sclk0_o
always@(posedge pclk or negedge preset)
begin
	if(!preset)
		mosi_send_sclk0_o<=1'b0;
	else if((cpha&&~cpol)||(cpol&&~cpha))
	begin
             if(sclk)
               begin
		if(count==((brd/2)-2'b10))
			mosi_send_sclk0_o<=1'b1;
		else
			mosi_send_sclk0_o<=1'b0;
	end
		else
			mosi_send_sclk0_o<=1'b0;
end
end
always
begin
	#(CYCLE/2) pclk=1'b0;
	#(CYCLE/2)pclk=1'b1;
end
always
begin
	#(CYCLE*2) sclk=1'b0;
	#(CYCLE*2) sclk=1'b1;
end
task resets();
	begin
		@(negedge pclk)
		preset=1'b0;
		@(negedge pclk)
		preset=1'b1;
	end
endtask
task inputs4(input[1:0]a,input b,input c);
	begin
               @(negedge pclk)
		spi_mode=a;
		ss=b;
		spi_swai=c;
	end
endtask

task inputs1();
	begin
		@(negedge pclk)
		cpol=0;
		cpha=1;
		lsbfe=1;
                send_data=1;
                brd=12'd4;
	end
endtask
task inputs2();
	begin
		@(negedge pclk)
		miso=1;
		data_mosi=8'd4;
	end
endtask
task inputs3();
	begin
		@(negedge pclk)
		cpol=1;
		cpha=1;
		lsbfe=1;
                send_data=0;
                brd=12'd4;
	end
endtask
initial 
begin
	resets();
   fork
	inputs1();
	inputs2();
        inputs4(2'b00,0,0);
   join
//resets();
//@(negedge pclk);
//send_data=0;
@(negedge pclk);
send_data=1;
@(negedge pclk);
send_data=0;
rcv_data=0;
repeat(8)
@(negedge sclk);
rcv_data=1;
@(negedge sclk);
rcv_data=0;
	#250 $finish;
end
initial $monitor("mosi=%b,data_miso=%b,data_mosi=%b,miso=%b,rcv_data=%b",mosi,data_miso,data_mosi,miso,rcv_data);
endmodule
