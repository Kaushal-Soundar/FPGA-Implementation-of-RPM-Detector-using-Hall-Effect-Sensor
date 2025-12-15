module fsm_timer (
    input  wire clk,
    input  wire rst,
    input  wire tick,
    output reg  count_en,
    output reg  done
);

    parameter IDLE  = 2'b00;
    parameter COUNT = 2'b01;
    parameter DONE  = 2'b10;

    reg [1:0] current_state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (current_state)
            IDLE:
                if (tick)
                    next_state = COUNT;
                else
                    next_state = IDLE;

            COUNT:
                if (tick)
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_en <= 0;
            done     <= 0;
        end else begin
            case (next_state)
                IDLE: begin
                    count_en <= 0;
                    done     <= 0;
                end
                COUNT: begin
                    count_en <= 1;
                    done     <= 0;
                end
                DONE: begin
                    count_en <= 0;
                    done     <= 1;
                end
                default: begin
                    count_en <= 0;
                    done     <= 0;
                end
            endcase
        end
    end

endmodule

