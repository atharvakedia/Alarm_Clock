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
