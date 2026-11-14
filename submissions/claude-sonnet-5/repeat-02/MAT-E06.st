PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    (* Internal variables *)
    state : INT := 0;          (* 0 = idle, 1 = pushing, 2 = retracting, 3 = done *)
    start_edge : R_TRIG;
    scan_count : DINT := 0;
END_VAR

(* Track scan count for reference / bounded loop - not used for time-based logic here *)
scan_count := scan_count + 1;

start_edge(CLK := X10);

CASE state OF

    0: (* IDLE - wait for rising edge of start request *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        IF start_edge.Q THEN
            state := 1;
        END_IF;

    1: (* PUSHING - drive forward until end reached and product received *)
        Y20 := TRUE;
        Y21 := FALSE;
        IF X21 AND X22 THEN
            state := 2;
        END_IF;

    2: (* RETRACTING - drive back until home reached *)
        Y20 := FALSE;
        Y21 := TRUE;
        IF X20 THEN
            state := 3;
        END_IF;

    3: (* DONE - actuators off, claim completion, hold result *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := TRUE;

    ELSE
        (* Safety fallback: ensure outputs off, remain idle *)
        Y20 := FALSE;
        Y21 := FALSE;
        Y2 := FALSE;
        state := 0;

END_CASE;

END_PROGRAM