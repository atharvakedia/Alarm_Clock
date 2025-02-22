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
