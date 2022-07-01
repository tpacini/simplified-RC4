module rc4_decryption(
    input            clk,
    input            rst_n,
    input      [7:0] seed [15:0],
    input      [7:0] din, // ciphertext byte
    input            din_valid,
    output reg       dout_ready,
    output reg [7:0] dout, // plaintext byte
    output reg       init_done
);

reg [7:0] S_mem [255:0];
reg [7:0] S_ij;
reg [2:0] state;
reg [7:0] i;
reg [7:0] j;

localparam NULL_CHAR = 8'b0;

always @ (posedge clk or negedge rst_n) 
begin
if(!rst_n)
begin
    dout <= NULL_CHAR;
    dout_ready <= 1'b0;
    init_done <= 1'b0;
    state <= 0;
end
else
begin
    case(state)
    /************************
     *  Initialization of S
     ************************/
    0: 
    begin
        S_mem[0]   <= 0;
        S_mem[1]   <= 1;
        S_mem[2]   <= 2;
        S_mem[3]   <= 3;
        S_mem[4]   <= 4;
        S_mem[5]   <= 5;
        S_mem[6]   <= 6;
        S_mem[7]   <= 7;
        S_mem[8]   <= 8;
        S_mem[9]   <= 9;
        S_mem[10]  <= 10;
        S_mem[11]  <= 11;
        S_mem[12]  <= 12;
        S_mem[13]  <= 13;
        S_mem[14]  <= 14;
        S_mem[15]  <= 15;
        S_mem[16]  <= 16;
        S_mem[17]  <= 17;
        S_mem[18]  <= 18;
        S_mem[19]  <= 19;
        S_mem[20]  <= 20;
        S_mem[21]  <= 21;
        S_mem[22]  <= 22;
        S_mem[23]  <= 23;
        S_mem[24]  <= 24;
        S_mem[25]  <= 25;
        S_mem[26]  <= 26;
        S_mem[27]  <= 27;
        S_mem[28]  <= 28;
        S_mem[29]  <= 29;
        S_mem[30]  <= 30;
        S_mem[31]  <= 31;
        S_mem[32]  <= 32;
        S_mem[33]  <= 33;
        S_mem[34]  <= 34;
        S_mem[35]  <= 35;
        S_mem[36]  <= 36;
        S_mem[37]  <= 37;
        S_mem[38]  <= 38;
        S_mem[39]  <= 39;
        S_mem[40]  <= 40;
        S_mem[41]  <= 41;
        S_mem[42]  <= 42;
        S_mem[43]  <= 43;
        S_mem[44]  <= 44;
        S_mem[45]  <= 45;
        S_mem[46]  <= 46;
        S_mem[47]  <= 47;
        S_mem[48]  <= 48;
        S_mem[49]  <= 49;
        S_mem[50]  <= 50;
        S_mem[51]  <= 51;
        S_mem[52]  <= 52;
        S_mem[53]  <= 53;
        S_mem[54]  <= 54;
        S_mem[55]  <= 55;
        S_mem[56]  <= 56;
        S_mem[57]  <= 57;
        S_mem[58]  <= 58;
        S_mem[59]  <= 59;
        S_mem[60]  <= 60;
        S_mem[61]  <= 61;
        S_mem[62]  <= 62;
        S_mem[63]  <= 63;
        S_mem[64]  <= 64;
        S_mem[65]  <= 65;
        S_mem[66]  <= 66;
        S_mem[67]  <= 67;
        S_mem[68]  <= 68;
        S_mem[69]  <= 69;
        S_mem[70]  <= 70;
        S_mem[71]  <= 71;
        S_mem[72]  <= 72;
        S_mem[73]  <= 73;
        S_mem[74]  <= 74;
        S_mem[75]  <= 75;
        S_mem[76]  <= 76;
        S_mem[77]  <= 77;
        S_mem[78]  <= 78;
        S_mem[79]  <= 79;
        S_mem[80]  <= 80;
        S_mem[81]  <= 81;
        S_mem[82]  <= 82;
        S_mem[83]  <= 83;
        S_mem[84]  <= 84;
        S_mem[85]  <= 85;
        S_mem[86]  <= 86;
        S_mem[87]  <= 87;
        S_mem[88]  <= 88;
        S_mem[89]  <= 89;
        S_mem[90]  <= 90;
        S_mem[91]  <= 91;
        S_mem[92]  <= 92;
        S_mem[93]  <= 93;
        S_mem[94]  <= 94;
        S_mem[95]  <= 95;
        S_mem[96]  <= 96;
        S_mem[97]  <= 97;
        S_mem[98]  <= 98;
        S_mem[99]  <= 99;
        S_mem[100] <= 100;
        S_mem[101] <= 101;
        S_mem[102] <= 102;
        S_mem[103] <= 103;
        S_mem[104] <= 104;
        S_mem[105] <= 105;
        S_mem[106] <= 106;
        S_mem[107] <= 107;
        S_mem[108] <= 108;
        S_mem[109] <= 109;
        S_mem[110] <= 110;
        S_mem[111] <= 111;
        S_mem[112] <= 112;
        S_mem[113] <= 113;
        S_mem[114] <= 114;
        S_mem[115] <= 115;
        S_mem[116] <= 116;
        S_mem[117] <= 117;
        S_mem[118] <= 118;
        S_mem[119] <= 119;
        S_mem[120] <= 120;
        S_mem[121] <= 121;
        S_mem[122] <= 122;
        S_mem[123] <= 123;
        S_mem[124] <= 124;
        S_mem[125] <= 125;
        S_mem[126] <= 126;
        S_mem[127] <= 127;
        S_mem[128] <= 128;
        S_mem[129] <= 129;
        S_mem[130] <= 130;
        S_mem[131] <= 131;
        S_mem[132] <= 132;
        S_mem[133] <= 133;
        S_mem[134] <= 134;
        S_mem[135] <= 135;
        S_mem[136] <= 136;
        S_mem[137] <= 137;
        S_mem[138] <= 138;
        S_mem[139] <= 139;
        S_mem[140] <= 140;
        S_mem[141] <= 141;
        S_mem[142] <= 142;
        S_mem[143] <= 143;
        S_mem[144] <= 144;
        S_mem[145] <= 145;
        S_mem[146] <= 146;
        S_mem[147] <= 147;
        S_mem[148] <= 148;
        S_mem[149] <= 149;
        S_mem[150] <= 150;
        S_mem[151] <= 151;
        S_mem[152] <= 152;
        S_mem[153] <= 153;
        S_mem[154] <= 154;
        S_mem[155] <= 155;
        S_mem[156] <= 156;
        S_mem[157] <= 157;
        S_mem[158] <= 158;
        S_mem[159] <= 159;
        S_mem[160] <= 160;
        S_mem[161] <= 161;
        S_mem[162] <= 162;
        S_mem[163] <= 163;
        S_mem[164] <= 164;
        S_mem[165] <= 165;
        S_mem[166] <= 166;
        S_mem[167] <= 167;
        S_mem[168] <= 168;
        S_mem[169] <= 169;
        S_mem[170] <= 170;
        S_mem[171] <= 171;
        S_mem[172] <= 172;
        S_mem[173] <= 173;
        S_mem[174] <= 174;
        S_mem[175] <= 175;
        S_mem[176] <= 176;
        S_mem[177] <= 177;
        S_mem[178] <= 178;
        S_mem[179] <= 179;
        S_mem[180] <= 180;
        S_mem[181] <= 181;
        S_mem[182] <= 182;
        S_mem[183] <= 183;
        S_mem[184] <= 184;
        S_mem[185] <= 185;
        S_mem[186] <= 186;
        S_mem[187] <= 187;
        S_mem[188] <= 188;
        S_mem[189] <= 189;
        S_mem[190] <= 190;
        S_mem[191] <= 191;
        S_mem[192] <= 192;
        S_mem[193] <= 193;
        S_mem[194] <= 194;
        S_mem[195] <= 195;
        S_mem[196] <= 196;
        S_mem[197] <= 197;
        S_mem[198] <= 198;
        S_mem[199] <= 199;
        S_mem[200] <= 200;
        S_mem[201] <= 201;
        S_mem[202] <= 202;
        S_mem[203] <= 203;
        S_mem[204] <= 204;
        S_mem[205] <= 205;
        S_mem[206] <= 206;
        S_mem[207] <= 207;
        S_mem[208] <= 208;
        S_mem[209] <= 209;
        S_mem[210] <= 210;
        S_mem[211] <= 211;
        S_mem[212] <= 212;
        S_mem[213] <= 213;
        S_mem[214] <= 214;
        S_mem[215] <= 215;
        S_mem[216] <= 216;
        S_mem[217] <= 217;
        S_mem[218] <= 218;
        S_mem[219] <= 219;
        S_mem[220] <= 220;
        S_mem[221] <= 221;
        S_mem[222] <= 222;
        S_mem[223] <= 223;
        S_mem[224] <= 224;
        S_mem[225] <= 225;
        S_mem[226] <= 226;
        S_mem[227] <= 227;
        S_mem[228] <= 228;
        S_mem[229] <= 229;
        S_mem[230] <= 230;
        S_mem[231] <= 231;
        S_mem[232] <= 232;
        S_mem[233] <= 233;
        S_mem[234] <= 234;
        S_mem[235] <= 235;
        S_mem[236] <= 236;
        S_mem[237] <= 237;
        S_mem[238] <= 238;
        S_mem[239] <= 239;
        S_mem[240] <= 240;
        S_mem[241] <= 241;
        S_mem[242] <= 242;
        S_mem[243] <= 243;
        S_mem[244] <= 244;
        S_mem[245] <= 245;
        S_mem[246] <= 246;
        S_mem[247] <= 247;
        S_mem[248] <= 248;
        S_mem[249] <= 249;
        S_mem[250] <= 250;
        S_mem[251] <= 251;
        S_mem[252] <= 252;
        S_mem[253] <= 253;
        S_mem[254] <= 254;
        S_mem[255] <= 255;


        state <= 1;
        i <= 0;
        j <= 0;
    end

    /************************
     *        KSA
     ************************/
    1: // Increment j
    begin
        j <= (j + S_mem[i] + seed[i[3:0]]);
        state <= 2;
    end

    2: // Swap
    begin
        S_mem[i] <= S_mem[j];
        S_mem[j] <= S_mem[i];
        
        if(i == 255) begin
            state <= 3;

            /* Anticipate some values */
            i <= 1'b1;
            j <= 1'b0 + S_mem[1];
        end else begin 
            i <= i + 1'b1;
            state <= 1;
        end
    end

    /************************
     *        PRGA
     ************************/
    3: // Anticipate some values during the init.
    begin 
        // Swap
        S_mem[i] <= S_mem[j];
        S_mem[j] <= S_mem[i];
        
        // S[i] + S[j] % 256
        S_ij <= S_mem[i] + S_mem[j];
        
        // Increment for the next cycle
        i <= i + 1'b1;

        init_done <= 1;
        state <= 4;
    end
    
    4: // Init done, starts decrypting if din_valid is 1
    begin
        if (din_valid == 1) begin
            dout <= S_mem[S_ij] ^ din;
            dout_ready <= 1'b1;
        
            // j = (j + S[i]) % 256
            j <= j + S_mem[i];

            // Swap
            S_mem[i] <= S_mem[j+S_mem[i]];
            S_mem[j+S_mem[i]] <= S_mem[i];
        
            // (S[i] + S[j]) % 256
            S_ij <= S_mem[i] + S_mem[j+S_mem[i]];

            // Incr. for the next cycle
            i <= i + 1'b1;

        end else begin
            dout_ready <= 1'b0;
            dout <= NULL_CHAR;
        end

        state <= 4;
    end

    default:
    begin 
        state <= 0;
    end

    endcase
end

end

endmodule


