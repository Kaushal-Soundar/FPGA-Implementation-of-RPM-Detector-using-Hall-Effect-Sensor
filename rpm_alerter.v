`timescale 1ns / 1ps

module top_basys3_tacho (
    input  wire clk,          
    input  wire rst_n,        
    input  wire pulse_in,     
    output wire led,          
    output wire buzzer,       
    output wire [6:0] seg,    
    output wire [3:0] an ,     
    output wire pulse_led
);
    
    wire rst = rst_n;
    
    wire tick;
    wire count_en, done;
    wire [3:0] count_out;
   
    localparam integer THRESHOLD = 3;

    clock_div #(
        .SYS_CLK_FREQ(100_000_000),
        .TICK_FREQ(1)
    ) u_clkdiv (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    fsm_timer u_fsm (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .count_en(count_en),
        .done(done)
    );

    pulse_counter #(.WIDTH(4)) u_ctr (
        .clk(clk),
        .rst(rst),
        .pulse_in(pulse_in),
        .count_en(count_en),
        .done(done),
        .count_out(count_out)
    );

  
    reg rpm_flag_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            rpm_flag_reg <= 1'b0;
        else if (done)
            rpm_flag_reg <= (count_out > THRESHOLD);
    end
    assign buzzer = rpm_flag_reg;

    assign led = count_en;   
    assign pulse_led = pulse_in;

    sevenseg_driver u_ssd (
        .in(count_out),
        .seg(seg),
        .an(an)
    );
    
endmodule