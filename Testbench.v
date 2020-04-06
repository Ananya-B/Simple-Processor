module processor_tb;
reg clk,Run,Resetn;
reg [15:0] DIN;
wire Done;
wire [15:0] bus;
processor s1(.clk(clk),.Run(Run),.Resetn(Resetn),.DIN(DIN),.Done(Done),.bus(bus));

always
#5 clk=~clk;

initial
begin
$monitor($time, "The values are clk=%b,Run=%b,Resetn=%b,DIN=%b,Done=%b,bus=%b",clk,Run,Resetn,DIN,Done,bus);
clk=1'b0;Resetn=1'b1;
#5 Resetn=1'b0;
#5 Resetn=1'b1;
#5 Run=1'b1;
#5 DIN=15'b0010011000101100;Run=1'b0;
#5 Run=1'b1;
#20 DIN=15'b0011000101101101;Run=1'b0;
#5 Run=1'b1;
#20 DIN=15'b0000011001101101;Run=1'b0;
#5 Run=1'b1;
#25 DIN=15'b0100011000100111;Run=1'b0;
#15 Run=1'b1;
#25 DIN=15'b0110011000100111;Run=1'b0;
#15 Run=1'b1;
#10 Run=1'b0;
#70 $stop;
end
endmodule
