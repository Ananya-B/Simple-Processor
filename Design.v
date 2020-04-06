module processor(DIN, Resetn, clk, Run, Done,bus);
input [15:0] DIN;
input Resetn, clk, Run;
output Done;
output reg Done;
output [15:0] bus;
wire [7:0] Xreg,Yreg;
reg [7:0] Rin;
reg [7:0] mux_in;
reg Ain,Gin,AddSub,IRin;
wire [8:0] IR;
reg DIN_out;
reg G_out;
wire [15:0] R0,R1,R2,R3,R4,R5,R6,R7,G,A;
wire [15:0] g_wire;
reg [1:0] Tstep_D,Tstep_Q;
parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
always@(Tstep_Q,Run,Done)
begin
case(Tstep_Q)
T0:begin
if(!Run)
Tstep_D=T0;
else
Tstep_D=T1;
end
T1:begin
if(Done) Tstep_D=T0;
else Tstep_D=T2;
end
T2:begin
if(Done)
Tstep_D=T0;
else
Tstep_D=T3;
end
T3:begin
if(Done)
Tstep_D=T0;
else
Tstep_D=T0;
end
endcase
end
always@(Tstep_Q or IR or Xreg or Yreg)
begin
Done=1'b0;
DIN_out=1'b0;
Rin=8'b0;
IRin=1'b0;
Ain=1'b0;
Gin=1'b0;
AddSub=1'b0;
G_out=1'b0;
mux_in=8'd0;
case(Tstep_Q)
T0:begin
IRin=1'b1;
end
T1:begin
case(IR[8:6])
3'b000:begin
Rin=Xreg;
Done=1'b1;
mux_in=Yreg;
end
3'b001:begin
Rin=Xreg;
DIN_out=1'b1;
Done=1'b1;
end
3'b010:begin
Ain=1'b1;
mux_in=Xreg;
end
3'b011:begin
Ain=1'b1;
mux_in=Xreg;
end
endcase
end
T2:begin
case(IR[8:6])
3'b010:begin
Gin=1'b1;
mux_in=Yreg;
end
3'b011:begin
Gin=1'b1;
AddSub=1'b1;
mux_in=Yreg;
end
endcase
end
T3:begin
case(IR[8:6])
3'b010:begin
Rin=Xreg;
Done=1'b1;
G_out=1'b1;
end
3'b011:begin
Rin=Xreg;
Done=1'b1;
G_out=1'b1;
end
endcase
end
endcase
end
always@(posedge(clk),negedge(Resetn))
begin
if(!Resetn)
Tstep_Q<=T0;
else
Tstep_Q<=Tstep_D;
end
regn r0(.R(bus),.Rin(Rin[0]),.clk(clk),.Q(R0));
regn r1(.R(bus),.Rin(Rin[1]),.clk(clk),.Q(R1));
regn r2(.R(bus),.Rin(Rin[2]),.clk(clk),.Q(R2));
regn r3(.R(bus),.Rin(Rin[3]),.clk(clk),.Q(R3));
regn r4(.R(bus),.Rin(Rin[4]),.clk(clk),.Q(R4));
regn r5(.R(bus),.Rin(Rin[5]),.clk(clk),.Q(R5));
regn r6(.R(bus),.Rin(Rin[6]),.clk(clk),.Q(R6));
regn r7(.R(bus),.Rin(Rin[7]),.clk(clk),.Q(R7));
regn a1(.R(bus),.Rin(Ain),.clk(clk),.Q(A));
regn g1(.R(g_wire),.Rin(Gin),.clk(clk),.Q(G));
proc_mux m1(.sel0(mux_in[0]),.sel1(mux_in[1]),.sel2(mux_in[2]),.sel3(mux_in[3]),.sel4(mux_in[4]),.sel5(mux_in[5]),.sel6(mux_in[6]),.sel7(mux_in[7]),.R0(R0),.R1(R1),.R2(R2),.R3(R3),.R4(R4),.R5(R5),.R6(R6),.R7(R7),.DIN_out(DIN_out),.G_out(G_out),.bus(bus),.DIN(DIN),.G(G));
Addsub_1 p1(.A(A),.out(g_wire),.IN(bus),.AddSub(AddSub));
dec3to8 decX(.W(IR[5:3]),.En(1'b1),.Y(Xreg));
dec3to8 decY(.W(IR[2:0]),.En(1'b1),.Y(Yreg));
reg_a a2(.R(DIN[15:7]),.Rin(IRin),.clk(clk),.Q(IR));
IReg a3(.DIN(DIN),.clk(clk),.IRin(IRin),.IR(IR));
endmodule



module regn(R,Rin,clk,Q);
input [15:0] R;
input Rin,clk;
output reg [15:0] Q;
always@(posedge clk)
begin
if(Rin)
Q<=R;
else Q<=Q;
end
endmodule



module Addsub_1(A,out,IN,AddSub);
input [15:0] A,IN;
input AddSub;
output reg [15:0] out;
always@(*)
begin
if(AddSub)
out=A-IN;
else
out=A+IN;
end
endmodule


module Addsub_1(A,out,IN,AddSub);
input [15:0] A,IN;
input AddSub;
output reg [15:0] out;
always@(*)
begin
if(AddSub)
out=A-IN;
else
out=A+IN;
end
endmodule


module proc_mux(sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7,R0,R1,R2,R3,R4,R5,R6,R7,DIN_out,G_out,bus,DIN,G);
input [15:0] R0,R1,R2,R3,R4,R5,R6,R7,DIN,G;
input sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7,DIN_out,G_out;
output reg [15:0] bus;
always@(*)
begin
if(DIN_out)
bus=DIN;
else if(G_out)
bus=G;
else if(sel0)
bus=R0;
else if(sel1)
bus=R1;
else if(sel2)
bus=R2;
else if(sel3)
bus=R3;
else if(sel4)
bus=R4;
else if(sel5)
bus=R5;
else if(sel6)
bus=R6;
else if(sel7)
bus=R7;
else
bus=DIN;
end
endmodule



module IReg(DIN,clk,IRin,IR);
input [15:0]DIN;
input clk,IRin;
output reg [15:0]IR;
reg [2:0]I,X,Y;
parameter mov=3'b001, mvi=3'b010,add=3'b011,sub=3'b100;
parameter R0=3'b000, R1=3'b001,R2=3'b010,R3=3'b011,R4=3'b100,R5=3'b101,R6=3'b110,R7=3'b111;
always @(posedge clk)
begin
if (IRin)
IR<=15'b0;
else
begin
{I,X,Y}<=DIN;
case(I)
3'b001: I<=mov;
3'b010: I<=mvi;
3'b011: I<=add;
3'b100: I<=sub;
default I<=1'b0;
endcase
case(X)

3'b000: X<=R0;
3'b001: X<=R1;
3'b010: X<=R2;
3'b011: X<=R3;
3'b100: X<=R4;
3'b101: X<=R5;
3'b110: X<=R6;
3'b111: X<=R7;
endcase

case(Y)
3'b000: Y<=R0;
3'b001: Y<=R1;
3'b010: Y<=R2;
3'b011: Y<=R3;
3'b100: Y<=R4;
3'b101: Y<=R5;
3'b110: Y<=R6;
3'b111: Y<=R7;
endcase
IR<={I,X,Y};
end
end
endmodule


module proc_mux(sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7,R0,R1,R2,R3,R4,R5,R6,R7,DIN_out,G_out,bus,DIN,G);
input [15:0] R0,R1,R2,R3,R4,R5,R6,R7,DIN,G;
input sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7,DIN_out,G_out;
output reg [15:0] bus;
always@(*)
begin
if(DIN_out)
bus=DIN;
else if(G_out)
bus=G;
else if(sel0)
bus=R0;
else if(sel1)
bus=R1;
else if(sel2)
bus=R2;
else if(sel3)
bus=R3;
else if(sel4)
bus=R4;
else if(sel5)
bus=R5;
else if(sel6)
bus=R6;
else if(sel7)
bus=R7;
else
bus=DIN;
end
endmodulev
