module INDEX2ABS_SUB_0#(
    parameter BIAS_LEN = 0
)(
	input wire			clk,
	input wire			rst_n,

	input wire	[127:0]	spike_index,
	input wire			spike_index_valid,

	output reg	[8:0]	absolute_addr,
	output reg			absolute_addr_valid,

	input  wire         generate_next_en

	);

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			absolute_addr <= 0;
			absolute_addr_valid <= 0;
		end
		else if(generate_next_en == 0)begin
			absolute_addr <= absolute_addr;
			absolute_addr_valid <= absolute_addr_valid;
		end
		else if(spike_index_valid)begin
			absolute_addr_valid <= 1;
            case(spike_index)    
                128'h1: absolute_addr <= 0;
                128'h2: absolute_addr <= 1;
                128'h4: absolute_addr <= 2;
                128'h8: absolute_addr <= 3;
                128'h10: absolute_addr <= 4;
                128'h20: absolute_addr <= 5;
                128'h40: absolute_addr <= 6;
                128'h80: absolute_addr <= 7;
                128'h100: absolute_addr <= 8;
                128'h200: absolute_addr <= 9;
                128'h400: absolute_addr <= 10;
                128'h800: absolute_addr <= 11;
                128'h1000: absolute_addr <= 12;
                128'h2000: absolute_addr <= 13;
                128'h4000: absolute_addr <= 14;
                128'h8000: absolute_addr <= 15;
                128'h10000: absolute_addr <= 16;
                128'h20000: absolute_addr <= 17;
                128'h40000: absolute_addr <= 18;
                128'h80000: absolute_addr <= 19;
                128'h100000: absolute_addr <= 20;
                128'h200000: absolute_addr <= 21;
                128'h400000: absolute_addr <= 22;
                128'h800000: absolute_addr <= 23;
                128'h1000000: absolute_addr <= 24;
                128'h2000000: absolute_addr <= 25;
                128'h4000000: absolute_addr <= 26;
                128'h8000000: absolute_addr <= 27;
                128'h10000000: absolute_addr <= 28;
                128'h20000000: absolute_addr <= 29;
                128'h40000000: absolute_addr <= 30;
                128'h80000000: absolute_addr <= 31;
                128'h100000000: absolute_addr <= 32;
                128'h200000000: absolute_addr <= 33;
                128'h400000000: absolute_addr <= 34;
                128'h800000000: absolute_addr <= 35;
                128'h1000000000: absolute_addr <= 36;
                128'h2000000000: absolute_addr <= 37;
                128'h4000000000: absolute_addr <= 38;
                128'h8000000000: absolute_addr <= 39;
                128'h10000000000: absolute_addr <= 40;
                128'h20000000000: absolute_addr <= 41;
                128'h40000000000: absolute_addr <= 42;
                128'h80000000000: absolute_addr <= 43;
                128'h100000000000: absolute_addr <= 44;
                128'h200000000000: absolute_addr <= 45;
                128'h400000000000: absolute_addr <= 46;
                128'h800000000000: absolute_addr <= 47;
                128'h1000000000000: absolute_addr <= 48;
                128'h2000000000000: absolute_addr <= 49;
                128'h4000000000000: absolute_addr <= 50;
                128'h8000000000000: absolute_addr <= 51;
                128'h10000000000000: absolute_addr <= 52;
                128'h20000000000000: absolute_addr <= 53;
                128'h40000000000000: absolute_addr <= 54;
                128'h80000000000000: absolute_addr <= 55;
                128'h100000000000000: absolute_addr <= 56;
                128'h200000000000000: absolute_addr <= 57;
                128'h400000000000000: absolute_addr <= 58;
                128'h800000000000000: absolute_addr <= 59;
                128'h1000000000000000: absolute_addr <= 60;
                128'h2000000000000000: absolute_addr <= 61;
                128'h4000000000000000: absolute_addr <= 62;
                128'h8000000000000000: absolute_addr <= 63;
                128'h10000000000000000: absolute_addr <= 64;
                128'h20000000000000000: absolute_addr <= 65;
                128'h40000000000000000: absolute_addr <= 66;
                128'h80000000000000000: absolute_addr <= 67;
                128'h100000000000000000: absolute_addr <= 68;
                128'h200000000000000000: absolute_addr <= 69;
                128'h400000000000000000: absolute_addr <= 70;
                128'h800000000000000000: absolute_addr <= 71;
                128'h1000000000000000000: absolute_addr <= 72;
                128'h2000000000000000000: absolute_addr <= 73;
                128'h4000000000000000000: absolute_addr <= 74;
                128'h8000000000000000000: absolute_addr <= 75;
                128'h10000000000000000000: absolute_addr <= 76;
                128'h20000000000000000000: absolute_addr <= 77;
                128'h40000000000000000000: absolute_addr <= 78;
                128'h80000000000000000000: absolute_addr <= 79;
                128'h100000000000000000000: absolute_addr <= 80;
                128'h200000000000000000000: absolute_addr <= 81;
                128'h400000000000000000000: absolute_addr <= 82;
                128'h800000000000000000000: absolute_addr <= 83;
                128'h1000000000000000000000: absolute_addr <= 84;
                128'h2000000000000000000000: absolute_addr <= 85;
                128'h4000000000000000000000: absolute_addr <= 86;
                128'h8000000000000000000000: absolute_addr <= 87;
                128'h10000000000000000000000: absolute_addr <= 88;
                128'h20000000000000000000000: absolute_addr <= 89;
                128'h40000000000000000000000: absolute_addr <= 90;
                128'h80000000000000000000000: absolute_addr <= 91;
                128'h100000000000000000000000: absolute_addr <= 92;
                128'h200000000000000000000000: absolute_addr <= 93;
                128'h400000000000000000000000: absolute_addr <= 94;
                128'h800000000000000000000000: absolute_addr <= 95;
                128'h1000000000000000000000000: absolute_addr <= 96;
                128'h2000000000000000000000000: absolute_addr <= 97;
                128'h4000000000000000000000000: absolute_addr <= 98;
                128'h8000000000000000000000000: absolute_addr <= 99;
                128'h10000000000000000000000000: absolute_addr <= 100;
                128'h20000000000000000000000000: absolute_addr <= 101;
                128'h40000000000000000000000000: absolute_addr <= 102;
                128'h80000000000000000000000000: absolute_addr <= 103;
                128'h100000000000000000000000000: absolute_addr <= 104;
                128'h200000000000000000000000000: absolute_addr <= 105;
                128'h400000000000000000000000000: absolute_addr <= 106;
                128'h800000000000000000000000000: absolute_addr <= 107;
                128'h1000000000000000000000000000: absolute_addr <= 108;
                128'h2000000000000000000000000000: absolute_addr <= 109;
                128'h4000000000000000000000000000: absolute_addr <= 110;
                128'h8000000000000000000000000000: absolute_addr <= 111;
                128'h10000000000000000000000000000: absolute_addr <= 112;
                128'h20000000000000000000000000000: absolute_addr <= 113;
                128'h40000000000000000000000000000: absolute_addr <= 114;
                128'h80000000000000000000000000000: absolute_addr <= 115;
                128'h100000000000000000000000000000: absolute_addr <= 116;
                128'h200000000000000000000000000000: absolute_addr <= 117;
                128'h400000000000000000000000000000: absolute_addr <= 118;
                128'h800000000000000000000000000000: absolute_addr <= 119;
                128'h1000000000000000000000000000000: absolute_addr <= 120;
                128'h2000000000000000000000000000000: absolute_addr <= 121;
                128'h4000000000000000000000000000000: absolute_addr <= 122;
                128'h8000000000000000000000000000000: absolute_addr <= 123;
                128'h10000000000000000000000000000000: absolute_addr <= 124;
                128'h20000000000000000000000000000000: absolute_addr <= 125;
                128'h40000000000000000000000000000000: absolute_addr <= 126;
                128'h80000000000000000000000000000000: absolute_addr <= 127;
                default: absolute_addr <= 0;
            endcase
		end
		else begin
			absolute_addr_valid <= 0;
		end
	end
endmodule

module INDEX2ABS_SUB_1#(
    parameter BIAS_LEN = 0
)(
	input wire			clk,
	input wire			rst_n,

	input wire	[127:0]	spike_index,
	input wire			spike_index_valid,

	output reg	[8:0]	absolute_addr,
	output reg			absolute_addr_valid,

	input  wire         generate_next_en

	);

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			absolute_addr <= 0;
			absolute_addr_valid <= 0;
		end
		else if(generate_next_en == 0)begin
			absolute_addr <= absolute_addr;
			absolute_addr_valid <= absolute_addr_valid;
		end
		else if(spike_index_valid)begin
			absolute_addr_valid <= 1;
            case(spike_index)    
                128'h1: absolute_addr <= 128;
                128'h2: absolute_addr <= 129;
                128'h4: absolute_addr <= 130;
                128'h8: absolute_addr <= 131;
                128'h10: absolute_addr <= 132;
                128'h20: absolute_addr <= 133;
                128'h40: absolute_addr <= 134;
                128'h80: absolute_addr <= 135;
                128'h100: absolute_addr <= 136;
                128'h200: absolute_addr <= 137;
                128'h400: absolute_addr <= 138;
                128'h800: absolute_addr <= 139;
                128'h1000: absolute_addr <= 140;
                128'h2000: absolute_addr <= 141;
                128'h4000: absolute_addr <= 142;
                128'h8000: absolute_addr <= 143;
                128'h10000: absolute_addr <= 144;
                128'h20000: absolute_addr <= 145;
                128'h40000: absolute_addr <= 146;
                128'h80000: absolute_addr <= 147;
                128'h100000: absolute_addr <= 148;
                128'h200000: absolute_addr <= 149;
                128'h400000: absolute_addr <= 150;
                128'h800000: absolute_addr <= 151;
                128'h1000000: absolute_addr <= 152;
                128'h2000000: absolute_addr <= 153;
                128'h4000000: absolute_addr <= 154;
                128'h8000000: absolute_addr <= 155;
                128'h10000000: absolute_addr <= 156;
                128'h20000000: absolute_addr <= 157;
                128'h40000000: absolute_addr <= 158;
                128'h80000000: absolute_addr <= 159;
                128'h100000000: absolute_addr <= 160;
                128'h200000000: absolute_addr <= 161;
                128'h400000000: absolute_addr <= 162;
                128'h800000000: absolute_addr <= 163;
                128'h1000000000: absolute_addr <= 164;
                128'h2000000000: absolute_addr <= 165;
                128'h4000000000: absolute_addr <= 166;
                128'h8000000000: absolute_addr <= 167;
                128'h10000000000: absolute_addr <= 168;
                128'h20000000000: absolute_addr <= 169;
                128'h40000000000: absolute_addr <= 170;
                128'h80000000000: absolute_addr <= 171;
                128'h100000000000: absolute_addr <= 172;
                128'h200000000000: absolute_addr <= 173;
                128'h400000000000: absolute_addr <= 174;
                128'h800000000000: absolute_addr <= 175;
                128'h1000000000000: absolute_addr <= 176;
                128'h2000000000000: absolute_addr <= 177;
                128'h4000000000000: absolute_addr <= 178;
                128'h8000000000000: absolute_addr <= 179;
                128'h10000000000000: absolute_addr <= 180;
                128'h20000000000000: absolute_addr <= 181;
                128'h40000000000000: absolute_addr <= 182;
                128'h80000000000000: absolute_addr <= 183;
                128'h100000000000000: absolute_addr <= 184;
                128'h200000000000000: absolute_addr <= 185;
                128'h400000000000000: absolute_addr <= 186;
                128'h800000000000000: absolute_addr <= 187;
                128'h1000000000000000: absolute_addr <= 188;
                128'h2000000000000000: absolute_addr <= 189;
                128'h4000000000000000: absolute_addr <= 190;
                128'h8000000000000000: absolute_addr <= 191;
                128'h10000000000000000: absolute_addr <= 192;
                128'h20000000000000000: absolute_addr <= 193;
                128'h40000000000000000: absolute_addr <= 194;
                128'h80000000000000000: absolute_addr <= 195;
                128'h100000000000000000: absolute_addr <= 196;
                128'h200000000000000000: absolute_addr <= 197;
                128'h400000000000000000: absolute_addr <= 198;
                128'h800000000000000000: absolute_addr <= 199;
                128'h1000000000000000000: absolute_addr <= 200;
                128'h2000000000000000000: absolute_addr <= 201;
                128'h4000000000000000000: absolute_addr <= 202;
                128'h8000000000000000000: absolute_addr <= 203;
                128'h10000000000000000000: absolute_addr <= 204;
                128'h20000000000000000000: absolute_addr <= 205;
                128'h40000000000000000000: absolute_addr <= 206;
                128'h80000000000000000000: absolute_addr <= 207;
                128'h100000000000000000000: absolute_addr <= 208;
                128'h200000000000000000000: absolute_addr <= 209;
                128'h400000000000000000000: absolute_addr <= 210;
                128'h800000000000000000000: absolute_addr <= 211;
                128'h1000000000000000000000: absolute_addr <= 212;
                128'h2000000000000000000000: absolute_addr <= 213;
                128'h4000000000000000000000: absolute_addr <= 214;
                128'h8000000000000000000000: absolute_addr <= 215;
                128'h10000000000000000000000: absolute_addr <= 216;
                128'h20000000000000000000000: absolute_addr <= 217;
                128'h40000000000000000000000: absolute_addr <= 218;
                128'h80000000000000000000000: absolute_addr <= 219;
                128'h100000000000000000000000: absolute_addr <= 220;
                128'h200000000000000000000000: absolute_addr <= 221;
                128'h400000000000000000000000: absolute_addr <= 222;
                128'h800000000000000000000000: absolute_addr <= 223;
                128'h1000000000000000000000000: absolute_addr <= 224;
                128'h2000000000000000000000000: absolute_addr <= 225;
                128'h4000000000000000000000000: absolute_addr <= 226;
                128'h8000000000000000000000000: absolute_addr <= 227;
                128'h10000000000000000000000000: absolute_addr <= 228;
                128'h20000000000000000000000000: absolute_addr <= 229;
                128'h40000000000000000000000000: absolute_addr <= 230;
                128'h80000000000000000000000000: absolute_addr <= 231;
                128'h100000000000000000000000000: absolute_addr <= 232;
                128'h200000000000000000000000000: absolute_addr <= 233;
                128'h400000000000000000000000000: absolute_addr <= 234;
                128'h800000000000000000000000000: absolute_addr <= 235;
                128'h1000000000000000000000000000: absolute_addr <= 236;
                128'h2000000000000000000000000000: absolute_addr <= 237;
                128'h4000000000000000000000000000: absolute_addr <= 238;
                128'h8000000000000000000000000000: absolute_addr <= 239;
                128'h10000000000000000000000000000: absolute_addr <= 240;
                128'h20000000000000000000000000000: absolute_addr <= 241;
                128'h40000000000000000000000000000: absolute_addr <= 242;
                128'h80000000000000000000000000000: absolute_addr <= 243;
                128'h100000000000000000000000000000: absolute_addr <= 244;
                128'h200000000000000000000000000000: absolute_addr <= 245;
                128'h400000000000000000000000000000: absolute_addr <= 246;
                128'h800000000000000000000000000000: absolute_addr <= 247;
                128'h1000000000000000000000000000000: absolute_addr <= 248;
                128'h2000000000000000000000000000000: absolute_addr <= 249;
                128'h4000000000000000000000000000000: absolute_addr <= 250;
                128'h8000000000000000000000000000000: absolute_addr <= 251;
                128'h10000000000000000000000000000000: absolute_addr <= 252;
                128'h20000000000000000000000000000000: absolute_addr <= 253;
                128'h40000000000000000000000000000000: absolute_addr <= 254;
                128'h80000000000000000000000000000000: absolute_addr <= 255;
                default: absolute_addr <= 0;
            endcase
		end
		else begin
			absolute_addr_valid <= 0;
		end
	end
endmodule

module INDEX2ABS_SUB_2#(
    parameter BIAS_LEN = 0
)(
	input wire			clk,
	input wire			rst_n,

	input wire	[127:0]	spike_index,
	input wire			spike_index_valid,

	output reg	[8:0]	absolute_addr,
	output reg			absolute_addr_valid,

	input  wire         generate_next_en

	);

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			absolute_addr <= 0;
			absolute_addr_valid <= 0;
		end
		else if(generate_next_en == 0)begin
			absolute_addr <= absolute_addr;
			absolute_addr_valid <= absolute_addr_valid;
		end
		else if(spike_index_valid)begin
			absolute_addr_valid <= 1;
            case(spike_index)    
                128'h1: absolute_addr <= 256;
                128'h2: absolute_addr <= 257;
                128'h4: absolute_addr <= 258;
                128'h8: absolute_addr <= 259;
                128'h10: absolute_addr <= 260;
                128'h20: absolute_addr <= 261;
                128'h40: absolute_addr <= 262;
                128'h80: absolute_addr <= 263;
                128'h100: absolute_addr <= 264;
                128'h200: absolute_addr <= 265;
                128'h400: absolute_addr <= 266;
                128'h800: absolute_addr <= 267;
                128'h1000: absolute_addr <= 268;
                128'h2000: absolute_addr <= 269;
                128'h4000: absolute_addr <= 270;
                128'h8000: absolute_addr <= 271;
                128'h10000: absolute_addr <= 272;
                128'h20000: absolute_addr <= 273;
                128'h40000: absolute_addr <= 274;
                128'h80000: absolute_addr <= 275;
                128'h100000: absolute_addr <= 276;
                128'h200000: absolute_addr <= 277;
                128'h400000: absolute_addr <= 278;
                128'h800000: absolute_addr <= 279;
                128'h1000000: absolute_addr <= 280;
                128'h2000000: absolute_addr <= 281;
                128'h4000000: absolute_addr <= 282;
                128'h8000000: absolute_addr <= 283;
                128'h10000000: absolute_addr <= 284;
                128'h20000000: absolute_addr <= 285;
                128'h40000000: absolute_addr <= 286;
                128'h80000000: absolute_addr <= 287;
                128'h100000000: absolute_addr <= 288;
                128'h200000000: absolute_addr <= 289;
                128'h400000000: absolute_addr <= 290;
                128'h800000000: absolute_addr <= 291;
                128'h1000000000: absolute_addr <= 292;
                128'h2000000000: absolute_addr <= 293;
                128'h4000000000: absolute_addr <= 294;
                128'h8000000000: absolute_addr <= 295;
                128'h10000000000: absolute_addr <= 296;
                128'h20000000000: absolute_addr <= 297;
                128'h40000000000: absolute_addr <= 298;
                128'h80000000000: absolute_addr <= 299;
                128'h100000000000: absolute_addr <= 300;
                128'h200000000000: absolute_addr <= 301;
                128'h400000000000: absolute_addr <= 302;
                128'h800000000000: absolute_addr <= 303;
                128'h1000000000000: absolute_addr <= 304;
                128'h2000000000000: absolute_addr <= 305;
                128'h4000000000000: absolute_addr <= 306;
                128'h8000000000000: absolute_addr <= 307;
                128'h10000000000000: absolute_addr <= 308;
                128'h20000000000000: absolute_addr <= 309;
                128'h40000000000000: absolute_addr <= 310;
                128'h80000000000000: absolute_addr <= 311;
                128'h100000000000000: absolute_addr <= 312;
                128'h200000000000000: absolute_addr <= 313;
                128'h400000000000000: absolute_addr <= 314;
                128'h800000000000000: absolute_addr <= 315;
                128'h1000000000000000: absolute_addr <= 316;
                128'h2000000000000000: absolute_addr <= 317;
                128'h4000000000000000: absolute_addr <= 318;
                128'h8000000000000000: absolute_addr <= 319;
                128'h10000000000000000: absolute_addr <= 320;
                128'h20000000000000000: absolute_addr <= 321;
                128'h40000000000000000: absolute_addr <= 322;
                128'h80000000000000000: absolute_addr <= 323;
                128'h100000000000000000: absolute_addr <= 324;
                128'h200000000000000000: absolute_addr <= 325;
                128'h400000000000000000: absolute_addr <= 326;
                128'h800000000000000000: absolute_addr <= 327;
                128'h1000000000000000000: absolute_addr <= 328;
                128'h2000000000000000000: absolute_addr <= 329;
                128'h4000000000000000000: absolute_addr <= 330;
                128'h8000000000000000000: absolute_addr <= 331;
                128'h10000000000000000000: absolute_addr <= 332;
                128'h20000000000000000000: absolute_addr <= 333;
                128'h40000000000000000000: absolute_addr <= 334;
                128'h80000000000000000000: absolute_addr <= 335;
                128'h100000000000000000000: absolute_addr <= 336;
                128'h200000000000000000000: absolute_addr <= 337;
                128'h400000000000000000000: absolute_addr <= 338;
                128'h800000000000000000000: absolute_addr <= 339;
                128'h1000000000000000000000: absolute_addr <= 340;
                128'h2000000000000000000000: absolute_addr <= 341;
                128'h4000000000000000000000: absolute_addr <= 342;
                128'h8000000000000000000000: absolute_addr <= 343;
                128'h10000000000000000000000: absolute_addr <= 344;
                128'h20000000000000000000000: absolute_addr <= 345;
                128'h40000000000000000000000: absolute_addr <= 346;
                128'h80000000000000000000000: absolute_addr <= 347;
                128'h100000000000000000000000: absolute_addr <= 348;
                128'h200000000000000000000000: absolute_addr <= 349;
                128'h400000000000000000000000: absolute_addr <= 350;
                128'h800000000000000000000000: absolute_addr <= 351;
                128'h1000000000000000000000000: absolute_addr <= 352;
                128'h2000000000000000000000000: absolute_addr <= 353;
                128'h4000000000000000000000000: absolute_addr <= 354;
                128'h8000000000000000000000000: absolute_addr <= 355;
                128'h10000000000000000000000000: absolute_addr <= 356;
                128'h20000000000000000000000000: absolute_addr <= 357;
                128'h40000000000000000000000000: absolute_addr <= 358;
                128'h80000000000000000000000000: absolute_addr <= 359;
                128'h100000000000000000000000000: absolute_addr <= 360;
                128'h200000000000000000000000000: absolute_addr <= 361;
                128'h400000000000000000000000000: absolute_addr <= 362;
                128'h800000000000000000000000000: absolute_addr <= 363;
                128'h1000000000000000000000000000: absolute_addr <= 364;
                128'h2000000000000000000000000000: absolute_addr <= 365;
                128'h4000000000000000000000000000: absolute_addr <= 366;
                128'h8000000000000000000000000000: absolute_addr <= 367;
                128'h10000000000000000000000000000: absolute_addr <= 368;
                128'h20000000000000000000000000000: absolute_addr <= 369;
                128'h40000000000000000000000000000: absolute_addr <= 370;
                128'h80000000000000000000000000000: absolute_addr <= 371;
                128'h100000000000000000000000000000: absolute_addr <= 372;
                128'h200000000000000000000000000000: absolute_addr <= 373;
                128'h400000000000000000000000000000: absolute_addr <= 374;
                128'h800000000000000000000000000000: absolute_addr <= 375;
                128'h1000000000000000000000000000000: absolute_addr <= 376;
                128'h2000000000000000000000000000000: absolute_addr <= 377;
                128'h4000000000000000000000000000000: absolute_addr <= 378;
                128'h8000000000000000000000000000000: absolute_addr <= 379;
                128'h10000000000000000000000000000000: absolute_addr <= 380;
                128'h20000000000000000000000000000000: absolute_addr <= 381;
                128'h40000000000000000000000000000000: absolute_addr <= 382;
                128'h80000000000000000000000000000000: absolute_addr <= 383;
                default: absolute_addr <= 0;
            endcase
		end
		else begin
			absolute_addr_valid <= 0;
		end
	end
endmodule

module INDEX2ABS_SUB_3#(
    parameter BIAS_LEN = 0
)(
	input wire			clk,
	input wire			rst_n,

	input wire	[127:0]	spike_index,
	input wire			spike_index_valid,

	output reg	[8:0]	absolute_addr,
	output reg			absolute_addr_valid,

	input  wire         generate_next_en

	);

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			absolute_addr <= 0;
			absolute_addr_valid <= 0;
		end
		else if(generate_next_en == 0)begin
			absolute_addr <= absolute_addr;
			absolute_addr_valid <= absolute_addr_valid;
		end
		else if(spike_index_valid)begin
			absolute_addr_valid <= 1;
            case(spike_index)    
                128'h1: absolute_addr <= 384;
                128'h2: absolute_addr <= 385;
                128'h4: absolute_addr <= 386;
                128'h8: absolute_addr <= 387;
                128'h10: absolute_addr <= 388;
                128'h20: absolute_addr <= 389;
                128'h40: absolute_addr <= 390;
                128'h80: absolute_addr <= 391;
                128'h100: absolute_addr <= 392;
                128'h200: absolute_addr <= 393;
                128'h400: absolute_addr <= 394;
                128'h800: absolute_addr <= 395;
                128'h1000: absolute_addr <= 396;
                128'h2000: absolute_addr <= 397;
                128'h4000: absolute_addr <= 398;
                128'h8000: absolute_addr <= 399;
                128'h10000: absolute_addr <= 400;
                128'h20000: absolute_addr <= 401;
                128'h40000: absolute_addr <= 402;
                128'h80000: absolute_addr <= 403;
                128'h100000: absolute_addr <= 404;
                128'h200000: absolute_addr <= 405;
                128'h400000: absolute_addr <= 406;
                128'h800000: absolute_addr <= 407;
                128'h1000000: absolute_addr <= 408;
                128'h2000000: absolute_addr <= 409;
                128'h4000000: absolute_addr <= 410;
                128'h8000000: absolute_addr <= 411;
                128'h10000000: absolute_addr <= 412;
                128'h20000000: absolute_addr <= 413;
                128'h40000000: absolute_addr <= 414;
                128'h80000000: absolute_addr <= 415;
                128'h100000000: absolute_addr <= 416;
                128'h200000000: absolute_addr <= 417;
                128'h400000000: absolute_addr <= 418;
                128'h800000000: absolute_addr <= 419;
                128'h1000000000: absolute_addr <= 420;
                128'h2000000000: absolute_addr <= 421;
                128'h4000000000: absolute_addr <= 422;
                128'h8000000000: absolute_addr <= 423;
                128'h10000000000: absolute_addr <= 424;
                128'h20000000000: absolute_addr <= 425;
                128'h40000000000: absolute_addr <= 426;
                128'h80000000000: absolute_addr <= 427;
                128'h100000000000: absolute_addr <= 428;
                128'h200000000000: absolute_addr <= 429;
                128'h400000000000: absolute_addr <= 430;
                128'h800000000000: absolute_addr <= 431;
                128'h1000000000000: absolute_addr <= 432;
                128'h2000000000000: absolute_addr <= 433;
                128'h4000000000000: absolute_addr <= 434;
                128'h8000000000000: absolute_addr <= 435;
                128'h10000000000000: absolute_addr <= 436;
                128'h20000000000000: absolute_addr <= 437;
                128'h40000000000000: absolute_addr <= 438;
                128'h80000000000000: absolute_addr <= 439;
                128'h100000000000000: absolute_addr <= 440;
                128'h200000000000000: absolute_addr <= 441;
                128'h400000000000000: absolute_addr <= 442;
                128'h800000000000000: absolute_addr <= 443;
                128'h1000000000000000: absolute_addr <= 444;
                128'h2000000000000000: absolute_addr <= 445;
                128'h4000000000000000: absolute_addr <= 446;
                128'h8000000000000000: absolute_addr <= 447;
                128'h10000000000000000: absolute_addr <= 448;
                128'h20000000000000000: absolute_addr <= 449;
                128'h40000000000000000: absolute_addr <= 450;
                128'h80000000000000000: absolute_addr <= 451;
                128'h100000000000000000: absolute_addr <= 452;
                128'h200000000000000000: absolute_addr <= 453;
                128'h400000000000000000: absolute_addr <= 454;
                128'h800000000000000000: absolute_addr <= 455;
                128'h1000000000000000000: absolute_addr <= 456;
                128'h2000000000000000000: absolute_addr <= 457;
                128'h4000000000000000000: absolute_addr <= 458;
                128'h8000000000000000000: absolute_addr <= 459;
                128'h10000000000000000000: absolute_addr <= 460;
                128'h20000000000000000000: absolute_addr <= 461;
                128'h40000000000000000000: absolute_addr <= 462;
                128'h80000000000000000000: absolute_addr <= 463;
                128'h100000000000000000000: absolute_addr <= 464;
                128'h200000000000000000000: absolute_addr <= 465;
                128'h400000000000000000000: absolute_addr <= 466;
                128'h800000000000000000000: absolute_addr <= 467;
                128'h1000000000000000000000: absolute_addr <= 468;
                128'h2000000000000000000000: absolute_addr <= 469;
                128'h4000000000000000000000: absolute_addr <= 470;
                128'h8000000000000000000000: absolute_addr <= 471;
                128'h10000000000000000000000: absolute_addr <= 472;
                128'h20000000000000000000000: absolute_addr <= 473;
                128'h40000000000000000000000: absolute_addr <= 474;
                128'h80000000000000000000000: absolute_addr <= 475;
                128'h100000000000000000000000: absolute_addr <= 476;
                128'h200000000000000000000000: absolute_addr <= 477;
                128'h400000000000000000000000: absolute_addr <= 478;
                128'h800000000000000000000000: absolute_addr <= 479;
                128'h1000000000000000000000000: absolute_addr <= 480;
                128'h2000000000000000000000000: absolute_addr <= 481;
                128'h4000000000000000000000000: absolute_addr <= 482;
                128'h8000000000000000000000000: absolute_addr <= 483;
                128'h10000000000000000000000000: absolute_addr <= 484;
                128'h20000000000000000000000000: absolute_addr <= 485;
                128'h40000000000000000000000000: absolute_addr <= 486;
                128'h80000000000000000000000000: absolute_addr <= 487;
                128'h100000000000000000000000000: absolute_addr <= 488;
                128'h200000000000000000000000000: absolute_addr <= 489;
                128'h400000000000000000000000000: absolute_addr <= 490;
                128'h800000000000000000000000000: absolute_addr <= 491;
                128'h1000000000000000000000000000: absolute_addr <= 492;
                128'h2000000000000000000000000000: absolute_addr <= 493;
                128'h4000000000000000000000000000: absolute_addr <= 494;
                128'h8000000000000000000000000000: absolute_addr <= 495;
                128'h10000000000000000000000000000: absolute_addr <= 496;
                128'h20000000000000000000000000000: absolute_addr <= 497;
                128'h40000000000000000000000000000: absolute_addr <= 498;
                128'h80000000000000000000000000000: absolute_addr <= 499;
                128'h100000000000000000000000000000: absolute_addr <= 500;
                128'h200000000000000000000000000000: absolute_addr <= 501;
                128'h400000000000000000000000000000: absolute_addr <= 502;
                128'h800000000000000000000000000000: absolute_addr <= 503;
                128'h1000000000000000000000000000000: absolute_addr <= 504;
                128'h2000000000000000000000000000000: absolute_addr <= 505;
                128'h4000000000000000000000000000000: absolute_addr <= 506;
                128'h8000000000000000000000000000000: absolute_addr <= 507;
                128'h10000000000000000000000000000000: absolute_addr <= 508;
                128'h20000000000000000000000000000000: absolute_addr <= 509;
                128'h40000000000000000000000000000000: absolute_addr <= 510;
                128'h80000000000000000000000000000000: absolute_addr <= 511;
                default: absolute_addr <= 0;
            endcase
		end
		else begin
			absolute_addr_valid <= 0;
		end
	end
endmodule

module NEW_INDEX2ABS_ADDR(
    input wire			clk,
	input wire			rst_n,

	input wire	[511:0]	spike_index,
	input wire			spike_index_valid,

	output reg	[8:0]	absolute_addr,
	output wire			absolute_addr_valid,

	input  wire         generate_next_en
);
    wire [8:0] a_addr_sub [0:3];
    reg  [3:0] sel_bit;
    wire [3:0] a_vld_sub;

    // INDEX2ABS_SUB_0 U_INDEX2ABS_SUB_0(
    //     .clk                 ( clk                 ),
    //     .rst_n               ( rst_n               ),
    //     .spike_index         ( spike_index[128*0 +: 128]         ),
    //     .spike_index_valid   ( spike_index_valid   ),
    //     .absolute_addr       ( a_addr_sub[0]       ),
    //     .absolute_addr_valid ( a_vld_sub[0] ),
    //     .generate_next_en    ( generate_next_en    )
    // );

    // INDEX2ABS_SUB_1 U_INDEX2ABS_SUB_1(
    //     .clk                 ( clk                 ),
    //     .rst_n               ( rst_n               ),
    //     .spike_index         ( spike_index[128*1 +: 128]         ),
    //     .spike_index_valid   ( spike_index_valid   ),
    //     .absolute_addr       ( a_addr_sub[1]       ),
    //     .absolute_addr_valid ( a_vld_sub[1] ),
    //     .generate_next_en    ( generate_next_en    )
    // );

    // INDEX2ABS_SUB_2 U_INDEX2ABS_SUB_2(
    //     .clk                 ( clk                 ),
    //     .rst_n               ( rst_n               ),
    //     .spike_index         ( spike_index[128*2 +: 128]         ),
    //     .spike_index_valid   ( spike_index_valid   ),
    //     .absolute_addr       ( a_addr_sub[2]       ),
    //     .absolute_addr_valid ( a_vld_sub[2] ),
    //     .generate_next_en    ( generate_next_en    )
    // );

    // INDEX2ABS_SUB_3 U_INDEX2ABS_SUB_3(
    //     .clk                 ( clk                 ),
    //     .rst_n               ( rst_n               ),
    //     .spike_index         ( spike_index[128*3 +: 128]         ),
    //     .spike_index_valid   ( spike_index_valid   ),
    //     .absolute_addr       ( a_addr_sub[3]       ),
    //     .absolute_addr_valid ( a_vld_sub[3] ),
    //     .generate_next_en    ( generate_next_en    )
    // );

    genvar i;
    generate
        for(i=0;i<4;i=i+1)begin
            INDEX2ABS_SUB_0 U_INDEX2ABS_SUB(
                .clk                 ( clk                 ),
                .rst_n               ( rst_n               ),
                .spike_index         ( spike_index[128*i +: 128]         ),
                .spike_index_valid   ( spike_index_valid   ),
                .absolute_addr       ( a_addr_sub[i]       ),
                .absolute_addr_valid ( a_vld_sub[i] ),
                .generate_next_en    ( generate_next_en    )
            );

            always@(posedge clk)begin
                if(generate_next_en == 1'b0)
                    sel_bit[i] <= sel_bit[i];
                else if(spike_index_valid)
                    sel_bit[i] <= |spike_index[128*i +: 128];
            end
        end
    endgenerate

    always@(*)begin
        case(sel_bit)
            4'b0001: absolute_addr = a_addr_sub[0];
            4'b0010: absolute_addr = a_addr_sub[1] + 128;
            4'b0100: absolute_addr = a_addr_sub[2] + 256;
            4'b1000: absolute_addr = a_addr_sub[3] + 384;
            default: absolute_addr = a_addr_sub[0];
        endcase
    end 

    assign absolute_addr_valid = |a_vld_sub;

endmodule 