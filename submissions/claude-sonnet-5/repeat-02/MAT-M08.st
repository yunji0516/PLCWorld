PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    D20 : INT;

    (* Internal variables *)
    edge_x10   : R_TRIG;
    state      : INT := 0;   (* 0=IDLE,1=MOVE_TO_SLOT,2=CHECK,3=PUSH,4=RETRACT,5=DONE,9=STUCK *)
    slot_index : INT := 0;
    target     : INT := 0;
    diff       : INT := 0;
END_VAR

edge_x10(CLK := X10);

CASE state OF

0: (* IDLE : wait for accepted start, all actuators OFF *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := FALSE;

    IF edge_x10.Q THEN
        (* Accept the request value D10 (single request token) *)
        slot_index := 0;
        target := 0;
        state := 1;
    END_IF

1: (* MOVE_TO_SLOT : drive rack towards target slot coordinate *)
    target := slot_index * 160;
    diff := D20 - target;
    IF diff < 0 THEN
        diff := -diff;
    END_IF;

    (* Safety: never move rack while pusher extended *)
    IF X23 THEN
        Y20 := FALSE;
        Y21 := FALSE;
    ELSIF (diff < 4) AND X25 THEN
        (* aligned at target slot, stop *)
        Y20 := FALSE;
        Y21 := FALSE;
        state := 2;
    ELSIF D20 < target THEN
        Y20 := TRUE;
        Y21 := FALSE;
    ELSIF D20 > target THEN
        Y21 := TRUE;
        Y20 := FALSE;
    ELSE
        Y20 := FALSE;
        Y21 := FALSE;
    END_IF

2: (* CHECK : slot alignment reached, evaluate occupancy *)
    Y20 := FALSE;
    Y21 := FALSE;

    IF X24 THEN
        (* occupied, advance to next slot *)
        slot_index := slot_index + 1;
        IF slot_index > 3 THEN
            state := 9; (* no vacant slot found; should not occur per initial conditions *)
        ELSE
            state := 1;
        END_IF
    ELSE
        (* vacant slot found here *)
        state := 3;
    END_IF

3: (* PUSH : insert new plate into the vacant, aligned slot *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y23 := FALSE;

    IF NOT X23 THEN
        Y22 := TRUE;
    ELSE
        Y22 := FALSE;
    END_IF;

    IF X23 AND X26 THEN
        state := 4;
    END_IF

4: (* RETRACT : withdraw pusher fully *)
    Y22 := FALSE;
    Y20 := FALSE;
    Y21 := FALSE;

    IF NOT X22 THEN
        Y23 := TRUE;
    ELSE
        Y23 := FALSE;
    END_IF;

    IF X22 THEN
        state := 5;
    END_IF

5: (* DONE : hold completion claim, all actuators OFF except Y2 *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
    Y2  := TRUE;

9: (* STUCK : no vacant slot found (should not occur); keep outputs safe *)
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

ELSE
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;

END_CASE;

END_PROGRAM