clock_div.v is used to create divisions of the clock signal for which counting can take place.
fsm_timer.v sets the mode in which the counter is in (Idle, Count or Done).
pulse_counter.v counts the number of pulses within the counting window(1 sec) created.
rpm_alerter.v is used to set the threshold of the number of pulses per counting window(1 sec).
rpm_alerter_tb.v is the testbench used.
bcd2seg.v is used to configure the seven segment display on the FPGA board to display the RPM value.
