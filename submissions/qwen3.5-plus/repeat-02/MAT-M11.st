PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D21 : INT;
    D20 : INT;
    start_edge : R_TRIG;
    slide_frac : REAL;
    tool_front_pos : REAL;
    content_front_pos : REAL;
    safety_gap_req : BOOL;
    started : BOOL;
    grip_done : BOOL;
    open_done : BOOL;
    insert_done : BOOL;
    retract_done : BOOL;
    release_done : BOOL;
END_VAR

start_edge(CLK := X10);
slide_frac := REAL#0.001 * DINT(D21);
tool_front_pos := -770.0 + 900.0 * slide_frac;
content_front_pos := -530.0 + 900.0 * slide_frac;

(* Safety: gap >= 150 while unseated content front or tool front strictly beyond entrance (-200) *)
safety_gap_req := FALSE;
IF X25 = FALSE THEN
    (* Unseated: check both content front and tool front *)
    IF content_front_pos > -200.0 THEN
        safety_gap_req := TRUE;
    END_IF;
    IF tool_front_pos > -200.0 THEN
        safety_gap_req := TRUE;
    END_IF;
ELSE
    (* Seated: only tool-front intrusion requires gap *)
    IF tool_front_pos > -200.0 THEN
        safety_gap_req := TRUE;
    END_IF;
END_IF;

(* Start on rising edge of X10 *)
IF start_edge.Q AND NOT started THEN
    started := TRUE;
END_IF;

(* State machine *)
IF NOT started THEN
    (* Idle - all outputs OFF *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    Y2 := FALSE;

ELSIF NOT grip_done THEN
    (* Phase 1: Grip both vacuum sides *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X20 AND X21 THEN
        grip_done := TRUE;
    END_IF;

ELSIF NOT open_done THEN
    (* Phase 2: Open opening axis *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X22 THEN
        open_done := TRUE;
    END_IF;

ELSIF NOT insert_done THEN
    (* Phase 3: Insert content *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := TRUE;
    Y25 := FALSE;
    IF X25 THEN
        insert_done := TRUE;
    END_IF;

ELSIF NOT retract_done THEN
    (* Phase 4: Retract tool *)
    Y20 := TRUE;
    Y21 := TRUE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := TRUE;
    IF X23 THEN
        retract_done := TRUE;
    END_IF;

ELSIF NOT release_done THEN
    (* Phase 5: Release vacuum *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    IF X26 THEN
        release_done := TRUE;
    END_IF;

ELSE
    (* Phase 6: Completion *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := TRUE;
    Y23 := FALSE;
    Y24 := FALSE;
    Y25 := FALSE;
    (* Verify completion conditions *)
    IF X25 AND X23 AND X22 AND X26 THEN
        Y2 := TRUE;
    ELSE
        Y2 := FALSE;
    END_IF;
END_IF;

END_PROGRAM