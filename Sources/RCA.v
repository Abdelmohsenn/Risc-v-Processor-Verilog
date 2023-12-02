
module RCA #(parameter n = 8)(input [n-1:0] a, input [n-1:0] b, output [n:0] sum);

wire [n-1:0] carry;

FullAdder f0(a[0], b[0], 1'b0, sum[0], carry[0]); 

genvar i;
generate 
for(i = 1; i < n; i = i + 1) begin
FullAdder f(a[i], b[i], carry[i-1], sum[i], carry[i]); 
end
assign sum[n] = carry[n-1];

endgenerate

endmodule