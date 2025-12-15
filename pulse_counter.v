module pulse_counter #(
    parameter WIDTH = 4    // 4-bit counter (0-15)
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             pulse_in,
    input  wire             count_en,
    input  wire             done,
    output reg  [WIDTH-1:0] count_out
);

    reg sync0, sync1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync0 <= 0;
            sync1 <= 0;
        end else begin
            sync0 <= pulse_in;
            sync1 <= sync0;
        end
    end

    reg sync1_d;
    always @(posedge clk or posedge rst) begin
        if (rst)
            sync1_d <= 0;
        else
            sync1_d <= sync1;
    end
    wire rising_edge = sync1 & ~sync1_d;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count_out <= 0;
        else if (done)
            count_out <= 0;
        else if (count_en && rising_edge)
            count_out <= count_out + 1;
    end

endmodule
