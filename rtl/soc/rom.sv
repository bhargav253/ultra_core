module rom
  (
   input wire 	     clk,
   input wire [9:0]  addr,
   output reg [31:0] dout
   );

   always @(posedge clk) begin
      case(addr[9:2])
	8'd0 : dout <= 32'h00000093;
	8'd1 : dout <= 32'h00000113;
	8'd2 : dout <= 32'h00000193;
	8'd3 : dout <= 32'h00000213;
	8'd4 : dout <= 32'h00000293;
	8'd5 : dout <= 32'h00000313;
	8'd6 : dout <= 32'h00000393;
	8'd7 : dout <= 32'h00000413;
	8'd8 : dout <= 32'h00000493;
	8'd9 : dout <= 32'h00000513;
	8'd10 : dout <= 32'h00000593;
	8'd11 : dout <= 32'h00000613;
	8'd12 : dout <= 32'h00000693;
	8'd13 : dout <= 32'h00000713;
	8'd14 : dout <= 32'h00000793;
	8'd15 : dout <= 32'h00000813;
	8'd16 : dout <= 32'h00000893;
	8'd17 : dout <= 32'h00000913;
	8'd18 : dout <= 32'h00000993;
	8'd19 : dout <= 32'h00000a13;
	8'd20 : dout <= 32'h00000a93;
	8'd21 : dout <= 32'h00000b13;
	8'd22 : dout <= 32'h00000b93;
	8'd23 : dout <= 32'h00000c13;
	8'd24 : dout <= 32'h00000c93;
	8'd25 : dout <= 32'h00000d13;
	8'd26 : dout <= 32'h00000d93;
	8'd27 : dout <= 32'h00000e13;
	8'd28 : dout <= 32'h00000e93;
	8'd29 : dout <= 32'h00000f13;
	8'd30 : dout <= 32'h00000f93;
	8'd31 : dout <= 32'h00001137;
	8'd32 : dout <= 32'hdeadc1b7;
	8'd33 : dout <= 32'heef18193;
	8'd34 : dout <= 32'h00018213;
	8'd35 : dout <= 32'h00001537;
	8'd36 : dout <= 32'h80050513;
	8'd37 : dout <= 32'h04400593;
	8'd38 : dout <= 32'h04f00613;
	8'd39 : dout <= 32'h04e00693;
	8'd40 : dout <= 32'h04500713;
	8'd41 : dout <= 32'h00a00793;
	8'd42 : dout <= 32'h00b52023;
	8'd43 : dout <= 32'h00c52023;
	8'd44 : dout <= 32'h00d52023;
	8'd45 : dout <= 32'h00e52023;
	8'd46 : dout <= 32'h00f52023;
	8'd47 : dout <= 32'h00001537;
	8'd48 : dout <= 32'h80050513;
	8'd49 : dout <= 32'h075bd5b7;
	8'd50 : dout <= 32'hd1558593;
	8'd51 : dout <= 32'h00b52023;
	8'd52 : dout <= 32'h00000097;
	8'd53 : dout <= 32'h08c08093;
	8'd54 : dout <= 32'h0000a183;
	8'd55 : dout <= 32'h00ff0eb7;
	8'd56 : dout <= 32'h0ffe8e93;
	8'd57 : dout <= 32'h05d19263;
	8'd58 : dout <= 32'h01c0006f;
	8'd59 : dout <= 32'h10000537;
	8'd60 : dout <= 32'h00450513;
	8'd61 : dout <= 32'h00f00593;
	8'd62 : dout <= 32'h00b52023;
	8'd63 : dout <= 32'h0f4000ef;
	8'd64 : dout <= 32'h00100073;
	8'd65 : dout <= 32'h00001537;
	8'd66 : dout <= 32'h80050513;
	8'd67 : dout <= 32'h04f00593;
	8'd68 : dout <= 32'h04b00613;
	8'd69 : dout <= 32'h00a00693;
	8'd70 : dout <= 32'h00b52023;
	8'd71 : dout <= 32'h00c52023;
	8'd72 : dout <= 32'h00d52023;
	8'd73 : dout <= 32'hfc9ff06f;
	8'd74 : dout <= 32'h00001537;
	8'd75 : dout <= 32'h80050513;
	8'd76 : dout <= 32'h04500593;
	8'd77 : dout <= 32'h05200613;
	8'd78 : dout <= 32'h04f00693;
	8'd79 : dout <= 32'h00a00713;
	8'd80 : dout <= 32'h00b52023;
	8'd81 : dout <= 32'h00c52023;
	8'd82 : dout <= 32'h00c52023;
	8'd83 : dout <= 32'h00d52023;
	8'd84 : dout <= 32'h00c52023;
	8'd85 : dout <= 32'h00e52023;
	8'd86 : dout <= 32'hf95ff06f;
	8'd87 : dout <= 32'h00ff00ff;
	8'd88 : dout <= 32'hff00ff00;
	8'd89 : dout <= 32'h0ff00ff0;
	8'd90 : dout <= 32'hf00ff00f;
	8'd91 : dout <= 32'hfe010113;
	8'd92 : dout <= 32'h00812e23;
	8'd93 : dout <= 32'h02010413;
	8'd94 : dout <= 32'h00050793;
	8'd95 : dout <= 32'hfef407a3;
	8'd96 : dout <= 32'h100007b7;
	8'd97 : dout <= 32'hfef44703;
	8'd98 : dout <= 32'h00e7a023;
	8'd99 : dout <= 32'h00000013;
	8'd100 : dout <= 32'h01c12403;
	8'd101 : dout <= 32'h02010113;
	8'd102 : dout <= 32'h00008067;
	8'd103 : dout <= 32'hfe010113;
	8'd104 : dout <= 32'h00812e23;
	8'd105 : dout <= 32'h02010413;
	8'd106 : dout <= 32'hfea42623;
	8'd107 : dout <= 32'h01c0006f;
	8'd108 : dout <= 32'hfec42783;
	8'd109 : dout <= 32'h00178713;
	8'd110 : dout <= 32'hfee42623;
	8'd111 : dout <= 32'h0007c703;
	8'd112 : dout <= 32'h100007b7;
	8'd113 : dout <= 32'h00e7a023;
	8'd114 : dout <= 32'hfec42783;
	8'd115 : dout <= 32'h0007c783;
	8'd116 : dout <= 32'hfe0790e3;
	8'd117 : dout <= 32'h100007b7;
	8'd118 : dout <= 32'h00c00713;
	8'd119 : dout <= 32'h00e7a023;
	8'd120 : dout <= 32'h00000013;
	8'd121 : dout <= 32'h01c12403;
	8'd122 : dout <= 32'h02010113;
	8'd123 : dout <= 32'h00008067;
	8'd124 : dout <= 32'hff010113;
	8'd125 : dout <= 32'h00112623;
	8'd126 : dout <= 32'h00812423;
	8'd127 : dout <= 32'h01010413;
	8'd128 : dout <= 32'h21c00513;
	8'd129 : dout <= 32'hf99ff0ef;
	8'd130 : dout <= 32'h00000013;
	8'd131 : dout <= 32'h00c12083;
	8'd132 : dout <= 32'h00812403;
	8'd133 : dout <= 32'h01010113;
	8'd134 : dout <= 32'h00008067;
	8'd135 : dout <= 32'h6c6c6568;
	8'd136 : dout <= 32'h6f77206f;
	8'd137 : dout <= 32'h0d646c72;
	8'd138 : dout <= 32'h0;
	8'd139 : dout <= 32'h0;
	8'd140 : dout <= 32'h0;
	8'd141 : dout <= 32'h0;
	8'd142 : dout <= 32'h0;
	8'd143 : dout <= 32'h0;
	8'd144 : dout <= 32'h0;
	8'd145 : dout <= 32'h0;
	8'd146 : dout <= 32'h0;
	8'd147 : dout <= 32'h0;
	8'd148 : dout <= 32'h0;
	8'd149 : dout <= 32'h0;
	8'd150 : dout <= 32'h0;
	8'd151 : dout <= 32'h0;
	8'd152 : dout <= 32'h0;
	8'd153 : dout <= 32'h0;
	8'd154 : dout <= 32'h0;
	8'd155 : dout <= 32'h0;
	8'd156 : dout <= 32'h0;
	8'd157 : dout <= 32'h0;
	8'd158 : dout <= 32'h0;
	8'd159 : dout <= 32'h0;
	8'd160 : dout <= 32'h0;
	8'd161 : dout <= 32'h0;
	8'd162 : dout <= 32'h0;
	8'd163 : dout <= 32'h0;
	8'd164 : dout <= 32'h0;
	8'd165 : dout <= 32'h0;
	8'd166 : dout <= 32'h0;
	8'd167 : dout <= 32'h0;
	8'd168 : dout <= 32'h0;
	8'd169 : dout <= 32'h0;
	8'd170 : dout <= 32'h0;
	8'd171 : dout <= 32'h0;
	8'd172 : dout <= 32'h0;
	8'd173 : dout <= 32'h0;
	8'd174 : dout <= 32'h0;
	8'd175 : dout <= 32'h0;
	8'd176 : dout <= 32'h0;
	8'd177 : dout <= 32'h0;
	8'd178 : dout <= 32'h0;
	8'd179 : dout <= 32'h0;
	8'd180 : dout <= 32'h0;
	8'd181 : dout <= 32'h0;
	8'd182 : dout <= 32'h0;
	8'd183 : dout <= 32'h0;
	8'd184 : dout <= 32'h0;
	8'd185 : dout <= 32'h0;
	8'd186 : dout <= 32'h0;
	8'd187 : dout <= 32'h0;
	8'd188 : dout <= 32'h0;
	8'd189 : dout <= 32'h0;
	8'd190 : dout <= 32'h0;
	8'd191 : dout <= 32'h0;
	8'd192 : dout <= 32'h0;
	8'd193 : dout <= 32'h0;
	8'd194 : dout <= 32'h0;
	8'd195 : dout <= 32'h0;
	8'd196 : dout <= 32'h0;
	8'd197 : dout <= 32'h0;
	8'd198 : dout <= 32'h0;
	8'd199 : dout <= 32'h0;
	8'd200 : dout <= 32'h0;
	8'd201 : dout <= 32'h0;
	8'd202 : dout <= 32'h0;
	8'd203 : dout <= 32'h0;
	8'd204 : dout <= 32'h0;
	8'd205 : dout <= 32'h0;
	8'd206 : dout <= 32'h0;
	8'd207 : dout <= 32'h0;
	8'd208 : dout <= 32'h0;
	8'd209 : dout <= 32'h0;
	8'd210 : dout <= 32'h0;
	8'd211 : dout <= 32'h0;
	8'd212 : dout <= 32'h0;
	8'd213 : dout <= 32'h0;
	8'd214 : dout <= 32'h0;
	8'd215 : dout <= 32'h0;
	8'd216 : dout <= 32'h0;
	8'd217 : dout <= 32'h0;
	8'd218 : dout <= 32'h0;
	8'd219 : dout <= 32'h0;
	8'd220 : dout <= 32'h0;
	8'd221 : dout <= 32'h0;
	8'd222 : dout <= 32'h0;
	8'd223 : dout <= 32'h0;
	8'd224 : dout <= 32'h0;
	8'd225 : dout <= 32'h0;
	8'd226 : dout <= 32'h0;
	8'd227 : dout <= 32'h0;
	8'd228 : dout <= 32'h0;
	8'd229 : dout <= 32'h0;
	8'd230 : dout <= 32'h0;
	8'd231 : dout <= 32'h0;
	8'd232 : dout <= 32'h0;
	8'd233 : dout <= 32'h0;
	8'd234 : dout <= 32'h0;
	8'd235 : dout <= 32'h0;
	8'd236 : dout <= 32'h0;
	8'd237 : dout <= 32'h0;
	8'd238 : dout <= 32'h0;
	8'd239 : dout <= 32'h0;
	8'd240 : dout <= 32'h0;
	8'd241 : dout <= 32'h0;
	8'd242 : dout <= 32'h0;
	8'd243 : dout <= 32'h0;
	8'd244 : dout <= 32'h0;
	8'd245 : dout <= 32'h0;
	8'd246 : dout <= 32'h0;
	8'd247 : dout <= 32'h0;
	8'd248 : dout <= 32'h0;
	8'd249 : dout <= 32'h0;
	8'd250 : dout <= 32'h0;
	8'd251 : dout <= 32'h0;
	8'd252 : dout <= 32'h0;
	8'd253 : dout <= 32'h0;
	8'd254 : dout <= 32'h0;
	8'd255 : dout <= 32'h0;
      endcase
   end
endmodule
