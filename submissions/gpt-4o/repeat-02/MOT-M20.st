PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;

    (* Internal variables *)
    gear_in_trigger : R_TRIG;
    gear_out_trigger : R_TRIG;
    park_enable_trigger : R_TRIG;
    in_gear_timer : TON;
    sync_origin_U : DINT;
    sync_origin_S : DINT;
    is_synchronized : BOOL := FALSE;
    is_parking : BOOL := FALSE;
    park_position : DINT;
END_VAR

(* Edge detection for GearIn and GearOut *)
gear_in_trigger(CLK := X10);
gear_out_trigger(CLK := NOT X10 AND X12);
park_enable_trigger(CLK := NOT X12 AND NOT is_parking);

(* Synchronization logic *)
IF gear_in_trigger.Q THEN
    (* Rising edge of GearIn *)
    IF D15 >= 500 AND D15 <= 2500 THEN
        Y20 := TRUE;
        D20 := D15;
        
        (* Capture origins *)
        sync_origin_U := D10;
        sync_origin_S := D11;

        is_synchronized := FALSE;
    END_IF;
ELSIF gear_out_trigger.Q THEN
    (* Rising edge of GearOut *)
    Y21 := TRUE;
    D20 := 0;
    park_position := D13 MOD (36000); (* Modulo 360 degrees for parking *)

    is_parking := TRUE;
    Y22 := FALSE; (* Disable independent position during transition *)
END_IF;

(* During synchronized state *)
IF X12 THEN
    (* Confirm synchronization *)
    IF X11 THEN
        in_gear_timer(IN := TRUE, PT := T#30ms);
        IF in_gear_timer.Q THEN
            is_synchronized := TRUE;
        END_IF;
    ELSE
        in_gear_timer(IN := FALSE);
        is_synchronized := FALSE;
    END_IF;

    (* Calculate current target for slave S *)
    IF is_synchronized THEN
        D21 := sync_origin_S + ((D10 - sync_origin_U) * D15) / 1000;
    ELSE
        D21 := D11; (* Hold current position if not synchronized *)
    END_IF;
ELSE
    in_gear_timer(IN := FALSE);
    
    (* Parking logic *)
    IF is_parking THEN
        Y22 := TRUE;
        D21 := park_position; 

        IF (ABS(D21 - D11) <= 20) AND (ABS(D12) <= 100) THEN (* 0.20 deg tolerance *)
            Y2 := TRUE; (* Task completion *)
            is_parking := FALSE;
        ELSE
            Y2 := FALSE;
        END_IF;
    END_IF;
END_IF;

(* Result retention logic *)
IF Y2 THEN
    park_enable_trigger(CLK := FALSE);
END_IF;

(* Reset edges *)
Y20 := FALSE;
Y21 := FALSE;

END_PROGRAM