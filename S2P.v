`timescale 1ns/1ps

module S2P (1xclk,reset,dataSIN,receiveFlag,done,dataOut);

parameter DATA_WIDTH = 16;

input 1xclk; // clock
input reset; // reset
input dataSIN; // data serial input
input receiveFlag; // receive operation begin

output reg done; // receive operation done
output reg [DATA_WIDTH-1:0] dataOut; // data receive

reg [DATA_WIDTH-1:0] shiftData; // sift reg
reg [4:0] counterEN;
wire      countFlag;

// Enabling the count
assign countFlag   = (counterEN == 5'd16) ? 1'b0 : 1'b1;
assign captureFlag = (counterEN == 5'd15) ? 1'b1 : 1'b0;

// Shift reg
always @(posedge 1xclk or negedge reset) 
begin
	if (reset == 1'b0) begin
		shiftData <= 0;
	end
	else begin
		shiftData <= {dataSIN,shiftData[DATA_WIDTH-2:0]};
	end
end

// Enable count
always @(posedge 1xclk or negedge reset) 
begin
	if (reset == 1'b0 || receiveFlag == 1'b1) begin
		counterEN <= 0;
	end
	else begin
		if (countFlag == 1'b1) begin
			counterEN <= counterEN + 5'd1;
		end
	end
end

// Captura reg
always @(posedge 1xclk or negedge reset) 
begin
	if (reset == 1'b0) begin
		dataOut <= 0;
		done <= 0;
	end
	else begin
		if (captureFlag == 1'b1) begin
			dataOut <= shiftData;
			done <= 1;
		end
		else begin
			dataOut <= dataOut;
			done <= 0;
		end
	end
end

endmodule