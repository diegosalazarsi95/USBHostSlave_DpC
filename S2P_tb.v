`include S2P.v

module S2P_TB();

parameter DATA_WIDTH = 16;

reg 1xclk; // clock
reg reset; // reset
reg dataSIN; // data serial input
reg receiveFlag; // receive operation begin

wire done; // receive operation done
wire [DATA_WIDTH-1:0] dataOut; // data receive

initial begin
	1xclk = 0;
	reset = 0;
	receiveFlag = 0;
	dataSIN = 0;
	#20
	reset = 1;
	#20
	reset = 0;
	#20
	for (i = 0; i < 17; i = i + 1) begin
		dataSIN = ~dataSIN;
		#10
	end
	#20
end

always begin
	1xclk = ~1xclk;
	#5
end

S2P DUT (
.1xclk(1xclk), // clock
.reset(reset), // reset
.dataSIN(dataSIN), // data serial input
.receiveFlag(receiveFlag), // receive operation begin
.done(done), // receive operation done
.dataOut(dataOut) );



endmodule 