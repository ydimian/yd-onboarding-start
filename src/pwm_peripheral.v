/*
 * Copyright (c) 2024 Damir Gazizullin
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module pwm_peripheral (
    input  wire       clk,      // clock
    input  wire       rst_n,     // reset_n - low to reset
    input  wire [7:0] en_reg_out_7_0,
    input  wire [7:0] en_reg_out_15_8,
    input  wire [7:0] en_reg_pwm_7_0,
    input  wire [7:0] en_reg_pwm_15_8,
    input  wire [7:0] pwm_duty_cycle,
    output reg [15:0] out
);

    localparam clk_div_trig = 12; // Divide by (12+1)*256, yielding 3000 (3004.80769) Hz
    reg [10:0] clk_counter;
    reg [7:0] pwm_counter;
    wire pwm_signal = (pwm_duty_cycle == 8'hFF) ? 1'b1 : (pwm_counter < pwm_duty_cycle); // 253 is 98.82% 254 is 99.21%, 255 is 100%, not 99.61%

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 0;
            pwm_counter <= 0;
            clk_counter <= 0;
        end else begin
            clk_counter <= clk_counter + 1;
            if (clk_counter == clk_div_trig) begin
                pwm_counter <= pwm_counter + 1;
                clk_counter <= 0;
            end
            out[7:0] <= en_reg_out_7_0;
            out[15:8] <= en_reg_out_15_8;
            // Apply PWM to each bit individually if enabled
            // Lower 8 bits
            if (en_reg_pwm_7_0[0]) out[0] <= (pwm_signal) ? en_reg_out_7_0[0] : 1'b0;
            if (en_reg_pwm_7_0[1]) out[1] <= (pwm_signal) ? en_reg_out_7_0[1] : 1'b0;
            if (en_reg_pwm_7_0[2]) out[2] <= (pwm_signal) ? en_reg_out_7_0[2] : 1'b0;
            if (en_reg_pwm_7_0[3]) out[3] <= (pwm_signal) ? en_reg_out_7_0[3] : 1'b0;
            if (en_reg_pwm_7_0[4]) out[4] <= (pwm_signal) ? en_reg_out_7_0[4] : 1'b0;
            if (en_reg_pwm_7_0[5]) out[5] <= (pwm_signal) ? en_reg_out_7_0[5] : 1'b0;
            if (en_reg_pwm_7_0[6]) out[6] <= (pwm_signal) ? en_reg_out_7_0[6] : 1'b0;
            if (en_reg_pwm_7_0[7]) out[7] <= (pwm_signal) ? en_reg_out_7_0[7] : 1'b0;

            // Upper 8 bits
            if (en_reg_pwm_15_8[0]) out[8] <= (pwm_signal) ? en_reg_out_15_8[0] : 1'b0;
            if (en_reg_pwm_15_8[1]) out[9] <= (pwm_signal) ? en_reg_out_15_8[1] : 1'b0;
            if (en_reg_pwm_15_8[2]) out[10] <= (pwm_signal) ? en_reg_out_15_8[2] : 1'b0;
            if (en_reg_pwm_15_8[3]) out[11] <= (pwm_signal) ? en_reg_out_15_8[3] : 1'b0;
            if (en_reg_pwm_15_8[4]) out[12] <= (pwm_signal) ? en_reg_out_15_8[4] : 1'b0;
            if (en_reg_pwm_15_8[5]) out[13] <= (pwm_signal) ? en_reg_out_15_8[5] : 1'b0;
            if (en_reg_pwm_15_8[6]) out[14] <= (pwm_signal) ? en_reg_out_15_8[6] : 1'b0;
            if (en_reg_pwm_15_8[7]) out[15] <= (pwm_signal) ? en_reg_out_15_8[7] : 1'b0;
        end
    end

endmodule