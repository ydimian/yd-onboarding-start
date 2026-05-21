/*
 * Copyright (c) 2024 Youhanna Dimian
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_youdim_onboarding (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  assign uio_oe = 8'hFF;

  wire [7:0] en_reg_out_7_0;
  wire [7:0] en_reg_out_15_8;
  wire [7:0] en_reg_pwm_7_0;
  wire [7:0] en_reg_pwm_15_8;
  wire [7:0] pwm_duty_cycle;

  assign en_reg_out_7_0   = 8'h00;
  assign en_reg_out_15_8  = 8'h00;
  assign en_reg_pwm_7_0   = 8'h00;
  assign en_reg_pwm_15_8  = 8'h00;
  assign pwm_duty_cycle   = 8'h00;

  pwm_peripheral pwm_peripheral_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en_reg_out_7_0(en_reg_out_7_0),
    .en_reg_out_15_8(en_reg_out_15_8),
    .en_reg_pwm_7_0(en_reg_pwm_7_0),
    .en_reg_pwm_15_8(en_reg_pwm_15_8),
    .pwm_duty_cycle(pwm_duty_cycle),
    .out({uio_out, uo_out})
  );

  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule