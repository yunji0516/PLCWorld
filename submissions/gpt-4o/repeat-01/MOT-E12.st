PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    Y20 : BOOL := FALSE;
    D20 : DINT := 0;
    Y2 : BOOL := FALSE;
    (* Internal variables *)
    target_position : DINT;
    position_error : REAL;
    speed_error : REAL;
    in_position : BOOL;
    holding_timer : TIME := T#0ms;
    completion_timer : TIME := T#0ms;
    request_valid : BOOL;
    hold_start_trigger : BOOL := FALSE;
    complete : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
request_valid := (D10 >= 10000) AND (D10 <= 15000);

IF X10 AND request_valid THEN
    target_position := D10;
    Y20 := TRUE;
    
    position_error := ABS(REAL(D11) - REAL(target_position));
    speed_error := ABS(REAL(D12));
    
    in_position := (position_error <= 20.0) AND (speed_error <= 100.0);
    
    IF in_position THEN
        IF NOT hold_start_trigger THEN
            holding_timer := T#0ms;
            hold_start_trigger := TRUE;
        ELSE
            holding_timer := holding_timer + T#10ms;
        END_IF;
        
        IF holding_timer >= T#30ms THEN
            Y2 := TRUE;
            IF NOT complete THEN
                completion_timer := T#0ms;
                complete := TRUE;
            ELSE
                completion_timer := completion_timer + T#10ms;
            END_IF;
        END_IF;
    ELSE
        holding_timer := T#0ms;
        completion_timer := T#0ms;
        hold_start_trigger := FALSE;
        complete := FALSE;
    END_IF;
    
    D20 := target_position;
    
    IF complete AND (completion_timer >= T#100ms) THEN
        Y20 := FALSE;
        Y2 := FALSE;
    END_IF;
ELSE
    Y20 := FALSE;
    D20 := 0;
    Y2 := FALSE;
    
    holding_timer := T#0ms;
    completion_timer := T#0ms;
    hold_start_trigger := FALSE;
    complete := FALSE;
END_IF;

END_PROGRAM