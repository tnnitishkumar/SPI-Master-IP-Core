 module shift_register (pclk,preset,ss,send_data,lsbfe,cpha,cpol,miso_recieve_sclk,miso_recieve_sclk0,mosi_send_sclk,mosi_send_sclk0,data_mosi,miso,rcv_data,mosi,data_miso	);
 input pclk,preset,ss,send_data,lsbfe,cpha,cpol,miso_recieve_sclk,miso_recieve_sclk0,mosi_send_sclk,mosi_send_sclk0,miso,rcv_data;
 input [7:0]data_mosi;
 output reg  mosi;
 output [7:0]data_miso;

 reg [7:0]temp_shift_reg;
 reg[7:0]temp;
 reg[2:0]count,count1,count2,count3;
 //logic for data_miso
 assign data_miso=rcv_data?temp:8'b0;
 //logic for shift_reg
 always@(posedge pclk or negedge preset)
 begin
	 if(!preset)
		 temp_shift_reg<=8'b0;
	 else if(send_data)
		 temp_shift_reg<=data_mosi;
	 else
		 temp_shift_reg<=temp_shift_reg;
 end
 //logic for mosi(parallel to serial)
 always@(posedge pclk or negedge preset)
 begin
	 if(!preset)
		 mosi<=1'b0;
	 else if(!ss)
	 begin
		 if((~cpol&&cpha)||(cpol&&~cpha))
		 begin
			 if(lsbfe)
			 begin
				 if(count<=3'd7)
				 begin
					 if(mosi_send_sclk0)
						 mosi<=temp_shift_reg[count];
					 else
						 mosi<=mosi;
				 end
				 else
					 mosi<=mosi;
			 end
			 else if(!lsbfe)
			 begin
				 if(count1>=3'd0)
				 begin
					 if(mosi_send_sclk)
						 mosi<=temp_shift_reg[count1];
					 else
						 mosi<=mosi;
				 end
					 else
						 mosi<=3'd7;
				 end
			 end
			 else if((cpol&&cpha)||(~cpol&&~cpha))
			 begin
				 if(lsbfe)
				 begin
					 if(count<=3'd7)
					 begin
						 if(mosi_send_sclk0)
							 mosi<=temp_shift_reg[count];
						 else  
							 mosi<=mosi;
					 end
					 else
						 mosi<=3'd0;
				 end
				 else if(!lsbfe)
				 begin
					 if(count1>=3'd0)
					 begin
						 if(mosi_send_sclk0)
							 mosi<=temp_shift_reg[count1];
						 else
							 mosi<=mosi;
					 end
					 else
						 mosi<=3'd7;
				 end
			 end
end
end
//logic for count/count1
 always@(posedge pclk or negedge preset)
 begin
	 if(!preset)
	 begin
		 count<=3'b000;
	         count1<=3'b111;
	 end
	 else if(!ss)
	 begin
		 if((~cpol&&cpha)||(cpol&&~cpha))
		 begin
			 if(lsbfe)
			 begin
				 if(count<=3'd7)
				 begin
					 if(mosi_send_sclk0)
						 count<=count+1'b1;
					 else
						 count<=count;
				 end
				 else
					 count<=3'd0;
			 end
                         end
			 else if(!lsbfe)
			 begin
				 if(count1>=3'd0)
				 begin
					 if(mosi_send_sclk0)
						 count1<=count-1'b1;
					 else
						 count1<=count1;
				 end
					 else
						 count1<=3'd7;
				 end
			 end
			 else if((cpol&&cpha)||(~cpol&&~cpha))
			 begin
				 if(lsbfe)
				 begin
					 if(count<=3'd7)
					 begin
						 if(mosi_send_sclk)
							 count<=count+1;
						 else  
							 count<=count;
					 end
					 else
						 count<=3'd0;
				 end
				 else if(!lsbfe)
				 begin
					 if(count1>=3'd0)
					 begin
						 if(mosi_send_sclk)
							 count1<=count1-1;
						 else
							 count1<=count1;
					 end
					 else
						 count1<=3'd7;
				 end
			 end
end
// logic for count2 and count3
always@(posedge pclk or negedge preset)
 begin
	 if(!preset)
	 begin
		 count2<=3'b000;
	         count3<=3'b111;
	 end
	 else if(!ss)
	 begin
		 if((~cpol&&cpha)||(cpol&&~cpha))
		 begin
			 if(lsbfe)
			 begin
				 if(count2<=3'd7)
				 begin
					 if(miso_recieve_sclk0)
						 count2<=count2+1'b1;
					 else
						 count2<=count2;
				 end
				 else
					 count2<=3'd0;
			 end
end
			 else if(!lsbfe)
			 begin
				 if(count3>=3'd0)
				 begin
					 if(miso_recieve_sclk0)
						 count3<=count3-1'b1;
					 else
						 count3<=count3;
				 end
					 else
						 count3<=3'd7;
				 end
			 end
			 else if((cpol&&cpha)||(~cpol&&~cpha))
			 begin
				 if(lsbfe)
				 begin
					 if(count2<=3'd7)
					 begin
						 if(miso_recieve_sclk)
							 count2<=count2+1;
						 else  
							 count2<=count2;
					 end
					 else
						 count2<=3'd0;
				 end
				 else if(!lsbfe)
				 begin
					 if(count3>=3'd0)
					 begin
						 if(miso_recieve_sclk)
							 count3<=count3-1;
						 else
							 count3<=count3;
					 end
					 else
						 count3<=3'd7;
				 end
			 end
end
//logic for temp[count2]/temp[count3]
always@(posedge pclk or negedge preset)
 begin
	 if(!preset)
	 begin
		 temp<=8'd0;
	 end
	 else if(!ss)
	 begin
		 if((~cpol&&cpha)||(cpol&&~cpha))
		 begin
			 if(lsbfe)
			 begin
				 if(count2<=3'd7)
				 begin
					 if(miso_recieve_sclk0)
						 temp[count2]<=miso;
					 else
						 temp[count2]<=temp[count2];
				 end
				 else
					 temp[count2]<=8'b0;
			 end
end
			 else if(!lsbfe)
			 begin
				 if(count3>=3'd0)
				 begin
					 if(miso_recieve_sclk0)
						 temp[count3]<=miso;
					 else
						 temp[count3]<=temp[count3];
				 end
					 else
						 temp[count3]<=8'd7;
				 end
			 end
			 else if((cpol&&cpha)||(~cpol&&~cpha))
			 begin
				 if(lsbfe)
				 begin
					 if(count2<=3'd7)
					 begin
						 if(miso_recieve_sclk)
							 temp[count2]<=miso;
						 else  
							 temp[count2]<=temp[count2];
					 end
					 else
						 temp[count2]<=8'd0;
				 end
				 else if(!lsbfe)
				 begin
					 if(count3>=3'd0)
					 begin
						 if(miso_recieve_sclk)
							 temp[count3]<=miso;
						 else
							 temp[count3]<=temp[count3];
					 end
					 else
						 temp[count3]<=3'd7;
				 end
			 end
end
endmodule
	





		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

