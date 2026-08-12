module tb_baud_rate_generator();
				reg pclk;
				reg preset_n;
				reg [1:0] spi_mode_i;
				reg spiswai_i;
				reg [2:0] sppr_i;
				reg [2:0] spr_i;
				reg cpol_i;
				reg cpha_i;
				reg ss_i;
				wire sclk_o;
				wire miso_recive_sclk_o;
			 	wire miso_recive_sclk0_o;
				wire mosi_send_sclk_o;
				wire mosi_send_sclk0_o;
				wire [11:0]baudratedivisor_o;
				
							
				
			//clk generation
			always 
				forever #5 pclk = ~pclk;
			
			
			// instantiation 
			baud_rate_generator DUT (pclk,preset_n,spi_mode_i,spiswai_i,sppr_i,spp_i,cpol_i,cpha_i,ss_i,sclk_o,miso_recive_sclk_o,miso_recive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,baudratedivisor_o );
			// task initiaise
			task initialise();
				begin
					{pclk,spi_mode_i,spiswai_i,sppr_i,spr_i,cpol_i,cpha_i} = 0;
					{preset_n,ss_i} = 1;
				end
			endtask
			//task preset_n
			task preset_n_dut();
				begin
					@(negedge pclk);
					preset_n = 1'b1;
					@(negedge pclk);
					preset_n = 1'b0;
				end
						
					@(negedge pclk);
					preset_n = 1'b0;
					@(negedge pclk);
					preset_n = 1'b1;
				end
			endtask
			//task cpol_cpha_stimulus
			task cl_cp_stimulus(input cpol,input cpha);
				begin	@(negedge pclk);
					cpol_i = cpol;
					cpha_i = cpha;
				end
			endtask
			// task ,spi_mode_i,spiswai_i
			task spi_mode_i_spiswai_i_dut(input [1:0]spimode,input spiswaimode);
				begin
					@(negedge pclk);
					spi_mode_i = spimode;
					spiswai_i = spiswaimode;
				end 
			
			//task sppr_i,spr_i
			task baud_rate(input [2:0]sppr,input[2:0]spr);
				begin
					@(negedge pclk)
					 sppr_i = sppr;
					 spr_i = spr;
				end
			endtask
			// slave select
			task slave_select();
				begin
					@(negedge pclk);
					ss_i = 1'b0;
					@(negedge pclk);
					ss_i = 1'b1;
				end
			endtask
			// initial procedure
			initial
				begin
					initialise();
					preset_n_dut();
					slave_select();
					cl_cp_stimulus(0,0);
					spi_mode_i_spiswai_i_dut(0,00);
					baud_rate(1,1);
					
			
				


					

					
			
					#1000
					$finish;
				
				end
			// monitor
			initial 
				$monitor ("pclk= %b,preset_n = %b,spi_mode_i = %b,spiswai_i= %b,sppr_i= %b,spp_i= %b,cpol_i= %b,cpha_i= %b,ss_i= %b,sclk_o= %b,miso_recive_sclk_o=%b,miso_recive_sclk0_o=%b,mosi_send_sclk_o=%b,mosi_send_sclk0_o=%b,baudratedivisor_o=%b",pclk,preset_n,spi_mode_i,spiswai_i,sppr_i,spp_i,cpol_i,cpha_i,ss_i,sclk_o,miso_recive_sclk_o,miso_recive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,baudratedivisor_o);		
		
endmodule
			
			
			
			
			
			
			
			
			
