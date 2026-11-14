PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    D20 : INT;
    D21 : INT;

    start_trig : R_TRIG;
    step : INT;
    armed : BOOL;
    received_latched : BOOL;
    end_timer : INT;
END_VAR

start_trig(CLK := X10);

IF X22 THEN
    received_latched := TRUE;
END_IF;

CASE step OF
    0: (* Idle: wait for start request *)
        IF start_trig.Q AND (D10 = 1) AND X20 AND X24 THEN
            step := 1;
        END_IF;

    1: (* Supply: advance product into launch nest *)
        IF X23 THEN
            step := 2;
        END_IF;

    2: (* Supply: retract empty supply finger *)
        IF X24 THEN
            step := 3;
        END_IF;

    3: (* Synchronize launch with receiving pocket *)
        IF NOT armed THEN
            IF D20 > D21 THEN
                armed := TRUE;
            END_IF;
        ELSIF D20 <= D21 THEN
            step := 4;
        END_IF;

    4: (* Fire: extend launch pusher *)
        IF X21 THEN
            end_timer := end_timer + 1;
            IF received_latched OR (end_timer >= 20) THEN
                step := 5;
            END_IF;
        END_IF;

    5: (* Retract: return launch pusher home *)
        IF X20 THEN
            step := 6;
        END_IF;

    6: (* Done: hold completion claim *)
        (* Maintain state and outputs *)
END_CASE;

(* Actuator outputs and safety interlocks *)
Y22 := (step = 1) AND X20;
Y20 := (step = 4) AND X23 AND X24 AND (NOT (step = 5));
Y21 := (step = 5) AND (NOT Y20);
Y2 := (step = 6);

END_PROGRAM