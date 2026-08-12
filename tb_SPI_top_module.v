module top1_module_tb();
reg pclk,presetn,pwrite,psel,penable,miso;
reg[2:0]paddr;
reg [7:0]pwdata;
wire ss,sclk,spi_interrupt_req,pready,pslverr;
wire mosi;
wire[7:0]pr_data;
//integer i;
top_module dut(pclk,presetn,paddr,pwrite,psel,penable,pwdata,miso,ss,sclk,spi_interrupt_req,mosi,pr_data,pready,pslverr);
initial 
begin
	pclk=1'b0;
	forever #5 pclk=~pclk;
end
task resets();
	begin
		@(negedge pclk);
		presetn=1'b0;
		@(negedge pclk);
		presetn=1'b1;
	end
endtask
task initialize();
	begin
		@(negedge pclk);
		paddr=3'b0;
		pwdata=8'h0;
		psel=1'b0;
		penable=1'b0;
		pwrite=1'b0;
                miso=1'b0;
	end
endtask
task inputs1(input[7:0]data,input[2:0]addr);
	begin
		@(negedge pclk);
		paddr=addr;
		pwdata=data;
		psel=1'b1;
		penable=1'b0;
		pwrite=1'b1;
		@(negedge pclk);
		penable=1'b1;
		wait(!pready)
		@(negedge pclk);
		psel=1'b0;
		penable=1'b0;
	end
endtask
task inputs2(/*input [7:0]miso_data*/);
	begin
		miso=0;
		wait(~ss)
        	begin
			@(negedge sclk);
	        	miso=1'b1;
			@(negedge sclk);
	        	miso=1'b0;

			@(negedge sclk);
	        	miso=1'b1;

			@(negedge sclk);
	        	miso=1'b0;

			@(negedge sclk);
	        	miso=1'b1;

			@(negedge sclk);
	        	miso=1'b0;

			@(negedge sclk);
	        	miso=1'b1;
			@(negedge sclk);
	        	miso=1'b0;
		end




		end
endtask

task read(input[2:0]addr);
	begin
		@(negedge pclk);
		paddr=addr;
		psel=1'b1;
		penable=1'b0;
		pwrite=1'b0;
		@(negedge pclk);
		penable=1'b1;
		wait(!pready)
		@(negedge pclk);
		psel=1'b0;
		penable=1'b0;
	end
endtask
initial 
begin
	resets;
	initialize;
	inputs1(8'b1101_1000,3'b000);
   	inputs1(8'h10,3'b001);
	inputs1(8'd10,3'b010);
   	inputs1(8'd5,3'b101);
	inputs2(/*8'h1010_101*/);
        read(3'b000);
	read(3'b001);
	read(3'b010);
	read(3'b101);
	read(3'b011);
	#1000 $finish;
end


initial $monitor("paddr=%b,pwdata=%b",paddr,pwdata);
endmodule



/*module tb_spi_core();
	
	//parameter for 25mhz pclk
	//	parameter cycle=40;
	
	//declare i/o ports
	reg pclk,presetn;
	reg [2:0]paddr;
	reg pwrite,psel,penable;
	reg [7:0]pw_data;
	reg miso;
	
	wire ss,sclk;
	wire spi_interrupt_request;
	wire mosi;
	wire [7:0]pr_data;
	wire pready,pslv_err;
	
	
	//uut instantiation of spi_core
	spi_core uut(pclk,presetn,paddr,pwrite,psel,penable,pw_data,miso,ss,sclk,spi_interrupt_request,mosi,pr_data,pready,pslv_err);
	
	integer i;

	initial 
	begin
	pclk=1'b0;
	forever #5 pclk=~pclk;
	end
task resets();
	begin
		@(negedge pclk);
		presetn=1'b0;
		@(negedge pclk);
		presetn=1'b1;
	end
endtask
task inputs2(input[7:0]data,input[2:0]addr);
	begin
		@(negedge pclk);
		paddr=addr;
		pw_data=data;
		psel=1'b1;
		penable=1'b0;
		pwrite=1'b1;
		@(negedge pclk);
		penable=1'b1;
		wait(!pready)
		@(negedge pclk);
		psel=1'b0;
		penable=1'b0;
	end
endtask

task inputs3(input [7:0]miso_data);
	begin
		miso=0;
		wait(~ss)
		for(i=0;i<7;i=i+1)
		begin
			@(posedge sclk);
			miso=miso_data[i];
			#20;
		end
	end
endtask

task ab(input[2:0]addr);
	begin
		@(negedge pclk);
		paddr=addr;
		psel=1'b1;
		penable=1'b0;
		pwrite=1'b0;
		@(negedge pclk);
		penable=1'b1;
		wait(!pready)
		@(negedge pclk);
		psel=1'b0;
		penable=1'b0;
	end
endtask
initial 
begin
	resets;
	inputs2(8'hff,3'b000);
   	inputs2(8'h10,3'b001);
	inputs2(8'd1,3'b010);
   	inputs2(8'h0f,3'b101);
#10;
	inputs3(8'd4);
        ab(3'b000);
	ab(3'b001);
	ab(3'b010);
	ab(3'b101);
	ab(3'b011);
	#1000;
end


initial 
	//$monitor("paddr=%b,pwdata=%b",paddr,pw_data);
	#5000 $finish;

endmodule*/			





