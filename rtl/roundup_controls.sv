// SPDX-License-Identifier: GPL-3.0-or-later
// Round-Up's independent menu encoding and MAME-functional Q2 coin lockout.
module roundup_controls(
 input wire [31:0] joystick_0, joystick_1,
 input wire [7:0] options,
 input wire coin_unlocked,
 output wire [7:0] player0, player1, inputs1, dips
);
 wire [7:0] cabinet_inputs;
 thepit_controls common_controls(
  .joystick_0(joystick_0),.joystick_1(joystick_1),.dip_options(8'd0),
  .player0(player0),.player1(player1),.inputs1(cabinet_inputs),.dips());
 // MAME Q2 callback sends !Q2 to coin_lockout_w: Q2=0 locks coin 1.
 // Keep all other cabinet bits unchanged; controller OR remains a MiSTer convenience.
 assign inputs1={cabinet_inputs[7:1],cabinet_inputs[0] && coin_unlocked};
 // Fresh MiSTer status is zero. Translate menu ordinal values into the
 // selected set's DSW byte; all-zero options must read 0x55 at B000.
 wire [1:0] coin=options[1:0]==2'd0 ? 2'b01 :
                 options[1:0]==2'd1 ? 2'b00 : options[1:0];
 wire [1:0] lives=options[3:2]==2'd0 ? 2'b01 :
                  options[3:2]==2'd1 ? 2'b00 : options[3:2];
 assign dips={options[7],~options[6],options[5],~options[4],lives,coin};
endmodule
