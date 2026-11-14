PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL := FALSE;
    Y20 : BOOL := FALSE;
    Y21 : BOOL := FALSE;
    X20 : BOOL;
    X21 : BOOL;
    D20 : INT;
    D21 : INT;

    start_edge : R_TRIG;
    requested_volume : INT := 0;
    pumping_started : BOOL := FALSE;
    received_start : INT := 0;
    fills_line : BOOL := FALSE;
    pump_off_timer : TON;
    valve_off_timer : TON;
    holding_scans : INT := 0;
END_VAR

start_edge(CLK := X10);

IF start_edge.Q THEN
    (* Store the requested volume and the initial received volume once Start is detected. *)
    requested_volume := D10;
    received_start := D20;
    pumping_started := TRUE;
    Y2 := FALSE;
    holding_scans := 0;
END_IF

IF pumping_started THEN
    (* Ensure valve is opened before starting the pump. *)
    IF NOT fills_line THEN
        Y20 := TRUE;  // Open the valve
        IF X20 THEN
            fills_line := TRUE;
        END_IF
    ELSE
        IF X20 THEN
            Y21 := TRUE;  // Turn on the pump when the valve is confirmed open
        ELSE
            Y21 := FALSE;  // Ensure the pump is off if the valve is not fully open
        END_IF
    END_IF

    (* Evaluate the received volume to determine if the operation can be stopped. *)
    IF D20 >= requested_volume THEN
        Y21 := FALSE;  // Turn off the pump once the request is fulfilled
        IF D20 - requested_volume >= 0 THEN
            (* Begin valve and pump off timing once the pump is commanded off *)
            pump_off_timer(IN := TRUE, PT := T#100ms);
            IF pump_off_timer.Q THEN
                Y20 := FALSE;  // Close the valve after ensuring the pump stopped
                IF X21 THEN
                    valve_off_timer(IN := TRUE, PT := T#100ms);
                    IF valve_off_timer.Q THEN
                        pumping_started := FALSE;  // Stop the process
                    END_IF
                ELSE
                    valve_off_timer(IN := FALSE);
                END_IF
            END_IF
        END_IF
    ELSE
        pump_off_timer(IN := FALSE);
        valve_off_timer(IN := FALSE);
    END_IF

    (* Hold completion claim when the task is done. *)
    IF NOT pumping_started AND X21 THEN
        holding_scans := holding_scans + 1;
        IF holding_scans >= 50 THEN
            Y2 := TRUE;  // Assert completion claim
        END_IF
    END_IF
END_IF

END_PROGRAM