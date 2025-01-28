module DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;

    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end

    assign out = count;
    assign ovf = en? &count : 1'b0;

    initial begin
        count = 'h0;
    end
endmodule


module BabylonianClock (
  input CLK,
  input CLR,
  input SETUP,
  input MIN_ADV,
  input HR_ADV,
  output [5:0] SECONDS,
  output [5:0] MINUTES,
  output [4:0] HOURS
);
  wire s0;
  wire s1;
  wire [5:0] SECONDS_temp;
  wire s2;
  wire s3;
  wire s4;
  wire [5:0] MINUTES_temp;
  wire s5;
  wire s6;
  wire s7;
  wire [4:0] HOURS_temp;
  wire s8;
  assign s8 = (~ SETUP & CLK);
  assign s0 = (s8 | CLR);
  // SECONDS_COUNTER
  DIG_Counter_Nbit #(
    .Bits(6)
  )
  DIG_Counter_Nbit_i0 (
    .en( 1'b1 ),
    .C( s0 ),
    .clr( s1 ),
    .out( SECONDS_temp )
  );
  assign s1 = (CLR | s2);
  assign s4 = (CLR | s5);
  assign s7 = (CLR | (HOURS_temp[0] & HOURS_temp[1] & HOURS_temp[2] & HOURS_temp[4]));
  assign s3 = ((MIN_ADV & SETUP) | (~ s8 & s2) | CLR);
  assign s6 = ((HR_ADV & SETUP) | (~ s3 & s5) | CLR);
  assign s2 = (SECONDS_temp[0] & SECONDS_temp[1] & SECONDS_temp[3] & SECONDS_temp[4] & SECONDS_temp[5]);
  // MINUTES_COUNTER
  DIG_Counter_Nbit #(
    .Bits(6)
  )
  DIG_Counter_Nbit_i1 (
    .en( 1'b1 ),
    .C( s3 ),
    .clr( s4 ),
    .out( MINUTES_temp )
  );
  // HOURS_COUNTER
  DIG_Counter_Nbit #(
    .Bits(5)
  )
  DIG_Counter_Nbit_i2 (
    .en( 1'b1 ),
    .C( s6 ),
    .clr( s7 ),
    .out( HOURS_temp )
  );
  assign s5 = (MINUTES_temp[0] & MINUTES_temp[1] & MINUTES_temp[3] & MINUTES_temp[4] & MINUTES_temp[5]);
  assign SECONDS = SECONDS_temp;
  assign MINUTES = MINUTES_temp;
  assign HOURS = HOURS_temp;
endmodule

module BabylonianAlarm (
  input CLR,
  input SETUP,
  input MIN_ADV,
  input HR_ADV,
  output [5:0] MINUTES,
  output [4:0] HOURS
);
  wire s0;
  wire s1;
  wire [5:0] MINUTES_temp;
  wire s2;
  wire s3;
  wire [4:0] HOURS_temp;
  assign s0 = ((MIN_ADV & SETUP) | CLR);
  assign s2 = ((HR_ADV & SETUP) | CLR);
  // MINUTES_COUNTER
  DIG_Counter_Nbit #(
    .Bits(6)
  )
  DIG_Counter_Nbit_i0 (
    .en( 1'b1 ),
    .C( s0 ),
    .clr( s1 ),
    .out( MINUTES_temp )
  );
  assign s1 = (CLR | (MINUTES_temp[0] & MINUTES_temp[1] & MINUTES_temp[3] & MINUTES_temp[4] & MINUTES_temp[5]));
  // HOURS_COUNTER
  DIG_Counter_Nbit #(
    .Bits(5)
  )
  DIG_Counter_Nbit_i1 (
    .en( 1'b1 ),
    .C( s2 ),
    .clr( s3 ),
    .out( HOURS_temp )
  );
  assign s3 = (CLR | (HOURS_temp[0] & HOURS_temp[1] & HOURS_temp[2] & HOURS_temp[4]));
  assign MINUTES = MINUTES_temp;
  assign HOURS = HOURS_temp;
endmodule

module Mux_2x1_NBits #(
    parameter Bits = 2
)
(
    input [0:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule

module LUT_SEG_DECODER (
    input \0 ,
    input \1 ,
    input \2 ,
    input \3 ,
    input \4 ,
    input \5 ,
    input \6 ,
    output reg  [13:0]  out
);
    reg [13:0] my_lut [0:127];
    wire [6:0] temp;
    assign temp = {\6 , \5 , \4 , \3 , \2 , \1 , \0 };

    always @ (*) begin
       out = my_lut[temp];
    end

    initial begin
        my_lut[0] = 14'h1fbf;
        my_lut[1] = 14'h1f86;
        my_lut[2] = 14'h1fdb;
        my_lut[3] = 14'h1fcf;
        my_lut[4] = 14'h1fe6;
        my_lut[5] = 14'h1fed;
        my_lut[6] = 14'h1ffd;
        my_lut[7] = 14'h1f87;
        my_lut[8] = 14'h1fff;
        my_lut[9] = 14'h1fe7;
        my_lut[10] = 14'h33f;
        my_lut[11] = 14'h306;
        my_lut[12] = 14'h35b;
        my_lut[13] = 14'h34f;
        my_lut[14] = 14'h366;
        my_lut[15] = 14'h36d;
        my_lut[16] = 14'h37d;
        my_lut[17] = 14'h307;
        my_lut[18] = 14'h37f;
        my_lut[19] = 14'h367;
        my_lut[20] = 14'h2dbf;
        my_lut[21] = 14'h2d86;
        my_lut[22] = 14'h2ddb;
        my_lut[23] = 14'h2dcf;
        my_lut[24] = 14'h2de6;
        my_lut[25] = 14'h2ded;
        my_lut[26] = 14'h2dfd;
        my_lut[27] = 14'h2d87;
        my_lut[28] = 14'h2dff;
        my_lut[29] = 14'h2de7;
        my_lut[30] = 14'h27bf;
        my_lut[31] = 14'h2786;
        my_lut[32] = 14'h27db;
        my_lut[33] = 14'h27cf;
        my_lut[34] = 14'h27e6;
        my_lut[35] = 14'h27ed;
        my_lut[36] = 14'h27fd;
        my_lut[37] = 14'h2787;
        my_lut[38] = 14'h27ff;
        my_lut[39] = 14'h27e7;
        my_lut[40] = 14'h333f;
        my_lut[41] = 14'h3306;
        my_lut[42] = 14'h335b;
        my_lut[43] = 14'h334f;
        my_lut[44] = 14'h3366;
        my_lut[45] = 14'h336d;
        my_lut[46] = 14'h337d;
        my_lut[47] = 14'h3307;
        my_lut[48] = 14'h337f;
        my_lut[49] = 14'h3367;
        my_lut[50] = 14'h36bf;
        my_lut[51] = 14'h3686;
        my_lut[52] = 14'h36db;
        my_lut[53] = 14'h36cf;
        my_lut[54] = 14'h36e6;
        my_lut[55] = 14'h36ed;
        my_lut[56] = 14'h36fd;
        my_lut[57] = 14'h3687;
        my_lut[58] = 14'h36ff;
        my_lut[59] = 14'h36e7;
        my_lut[60] = 14'h3ebf;
        my_lut[61] = 14'h3e86;
        my_lut[62] = 14'h3edb;
        my_lut[63] = 14'h3ecf;
        my_lut[64] = 14'h3ee6;
        my_lut[65] = 14'h3eed;
        my_lut[66] = 14'h3efd;
        my_lut[67] = 14'h3e87;
        my_lut[68] = 14'h3eff;
        my_lut[69] = 14'h3ee7;
        my_lut[70] = 14'h3bf;
        my_lut[71] = 14'h386;
        my_lut[72] = 14'h3db;
        my_lut[73] = 14'h3cf;
        my_lut[74] = 14'h3e6;
        my_lut[75] = 14'h3ed;
        my_lut[76] = 14'h3fd;
        my_lut[77] = 14'h387;
        my_lut[78] = 14'h3ff;
        my_lut[79] = 14'h3e7;
        my_lut[80] = 14'h3fbf;
        my_lut[81] = 14'h3f86;
        my_lut[82] = 14'h3fdb;
        my_lut[83] = 14'h3fcf;
        my_lut[84] = 14'h3fe6;
        my_lut[85] = 14'h3fed;
        my_lut[86] = 14'h3ffd;
        my_lut[87] = 14'h3f87;
        my_lut[88] = 14'h3fff;
        my_lut[89] = 14'h3fe7;
        my_lut[90] = 14'h33bf;
        my_lut[91] = 14'h3386;
        my_lut[92] = 14'h33db;
        my_lut[93] = 14'h33cf;
        my_lut[94] = 14'h33e6;
        my_lut[95] = 14'h33ed;
        my_lut[96] = 14'h33fd;
        my_lut[97] = 14'h3387;
        my_lut[98] = 14'h33ff;
        my_lut[99] = 14'h33e7;
        my_lut[100] = 14'h0;
        my_lut[101] = 14'h0;
        my_lut[102] = 14'h0;
        my_lut[103] = 14'h0;
        my_lut[104] = 14'h0;
        my_lut[105] = 14'h0;
        my_lut[106] = 14'h0;
        my_lut[107] = 14'h0;
        my_lut[108] = 14'h0;
        my_lut[109] = 14'h0;
        my_lut[110] = 14'h0;
        my_lut[111] = 14'h0;
        my_lut[112] = 14'h0;
        my_lut[113] = 14'h0;
        my_lut[114] = 14'h0;
        my_lut[115] = 14'h0;
        my_lut[116] = 14'h0;
        my_lut[117] = 14'h0;
        my_lut[118] = 14'h0;
        my_lut[119] = 14'h0;
        my_lut[120] = 14'h0;
        my_lut[121] = 14'h0;
        my_lut[122] = 14'h0;
        my_lut[123] = 14'h0;
        my_lut[124] = 14'h0;
        my_lut[125] = 14'h0;
        my_lut[126] = 14'h0;
        my_lut[127] = 14'h0;
    end
endmodule


module SevenSegmentDecoder (
  input [6:0] DATA_IN,
  output [13:0] DATA_OUT
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  assign s0 = DATA_IN[0];
  assign s1 = DATA_IN[1];
  assign s2 = DATA_IN[2];
  assign s3 = DATA_IN[3];
  assign s4 = DATA_IN[4];
  assign s5 = DATA_IN[5];
  assign s6 = DATA_IN[6];
  // SEG_DECODER
  LUT_SEG_DECODER LUT_SEG_DECODER_i0 (
    .\0 ( s0 ),
    .\1 ( s1 ),
    .\2 ( s2 ),
    .\3 ( s3 ),
    .\4 ( s4 ),
    .\5 ( s5 ),
    .\6 ( s6 ),
    .out( DATA_OUT )
  );
endmodule

module ConventionalAlarmClock (
  input SETUP_TIME,
  input SETUP_ALARM,
  input CLK,
  input CLR,
  input MIN_ADV,
  input HR_ADV,
  input ALARM_EN,
  output [5:0] SECONDS,
  output [5:0] MINUTES,
  output BUZZ,
  output [5:0] ALARM_MINUTES,
  output [4:0] ALARM_HOURS,
  output [13:0] SEG_SECONDS,
  output [13:0] SEG_MINUTES,
  output [13:0] SEG_HOURS,
  output [4:0] HOURS
);
  wire s0;
  wire s1;
  wire [5:0] SECONDS_temp;
  wire [5:0] MINUTES_temp;
  wire [4:0] HOURS_temp;
  wire s2;
  wire [5:0] ALARM_MINUTES_temp;
  wire [4:0] ALARM_HOURS_temp;
  wire s3;
  wire [5:0] s4;
  wire [5:0] s5;
  wire [5:0] s6;
  wire [4:0] s7;
  wire [5:0] s8;
  wire [5:0] s9;
  wire [6:0] s10;
  wire [6:0] s11;
  wire [6:0] s12;
  assign s0 = (CLK & ~ (SETUP_ALARM ^ SETUP_TIME) & CLK);
  assign s1 = (SETUP_TIME & ~ SETUP_ALARM);
  assign s2 = (~ SETUP_TIME & SETUP_ALARM);
  assign s3 = (SETUP_ALARM & ~ SETUP_TIME);
  assign s8[0] = 1'b0;
  assign s8[1] = 1'b0;
  assign s8[2] = 1'b0;
  assign s8[3] = 1'b0;
  assign s8[4] = 1'b0;
  assign s8[5] = 1'b0;
  BabylonianClock BabylonianClock_i0 (
    .CLK( s0 ),
    .CLR( CLR ),
    .SETUP( s1 ),
    .MIN_ADV( MIN_ADV ),
    .HR_ADV( HR_ADV ),
    .SECONDS( SECONDS_temp ),
    .MINUTES( MINUTES_temp ),
    .HOURS( HOURS_temp )
  );
  BabylonianAlarm BabylonianAlarm_i1 (
    .CLR( CLR ),
    .SETUP( s2 ),
    .MIN_ADV( MIN_ADV ),
    .HR_ADV( HR_ADV ),
    .MINUTES( ALARM_MINUTES_temp ),
    .HOURS( ALARM_HOURS_temp )
  );
  Mux_2x1_NBits #(
    .Bits(6)
  )
  Mux_2x1_NBits_i2 (
    .sel( s3 ),
    .in_0( MINUTES_temp ),
    .in_1( ALARM_MINUTES_temp ),
    .out( s6 )
  );
  Mux_2x1_NBits #(
    .Bits(5)
  )
  Mux_2x1_NBits_i3 (
    .sel( s3 ),
    .in_0( HOURS_temp ),
    .in_1( ALARM_HOURS_temp ),
    .out( s7 )
  );
  Mux_2x1_NBits #(
    .Bits(6)
  )
  Mux_2x1_NBits_i4 (
    .sel( s3 ),
    .in_0( SECONDS_temp ),
    .in_1( s8 ),
    .out( s9 )
  );
  assign s4[4:0] = ~ (HOURS_temp ^ ALARM_HOURS_temp);
  assign s4[5] = 1'b0;
  assign s5 = (~ (MINUTES_temp ^ ALARM_MINUTES_temp) & s4);
  assign s10[5:0] = s9;
  assign s10[6] = 1'b0;
  assign s11[5:0] = s6;
  assign s11[6] = 1'b0;
  assign s12[4:0] = s7;
  assign s12[5] = 1'b0;
  assign s12[6] = 1'b0;
  assign BUZZ = (s5[0] & ~ ALARM_EN);
  SevenSegmentDecoder SevenSegmentDecoder_i5 (
    .DATA_IN( s10 ),
    .DATA_OUT( SEG_SECONDS )
  );
  SevenSegmentDecoder SevenSegmentDecoder_i6 (
    .DATA_IN( s11 ),
    .DATA_OUT( SEG_MINUTES )
  );
  SevenSegmentDecoder SevenSegmentDecoder_i7 (
    .DATA_IN( s12 ),
    .DATA_OUT( SEG_HOURS )
  );
  assign SECONDS = SECONDS_temp;
  assign MINUTES = MINUTES_temp;
  assign ALARM_MINUTES = ALARM_MINUTES_temp;
  assign ALARM_HOURS = ALARM_HOURS_temp;
  assign HOURS = HOURS_temp;
endmodule
