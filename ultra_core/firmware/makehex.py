
#!/usr/bin/env python3
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

from sys import argv

binfile = argv[1]
nwords = int(argv[2])

with open(binfile, "rb") as f:
    bindata = f.read()

#print("len = " + str(len(bindata)))

assert len(bindata) < 4*nwords
#assert len(bindata) % 4 == 0

#header
header = "module rom\n\
(\n\
input wire 	      clk,\n\
input wire [9:0]  addr,\n\
output reg [31:0] dout\n\
);\n\
\n\
always @(posedge clk) begin\n\
case(addr[9:2])\
"

tail = "endcase\n\
end\n\
endmodule\
"

print(header)

for i in range(nwords):
    if i < len(bindata) // 4:
        w = bindata[4*i : 4*i+4]
        print("8'd%d : dout <= 32'h%02x%02x%02x%02x;" % (i,w[3], w[2], w[1], w[0]))
    else:
        print("8'd%d : dout <= 32'h0;" % (i))


print(tail)
