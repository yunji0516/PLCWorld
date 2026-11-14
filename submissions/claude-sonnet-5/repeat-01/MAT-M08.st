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

    (* internal *)
    startEdge   : R_TRIG;
    accepted    : BOOL := FALSE;
    state       : DINT := 0;   (* 0=IDLE,1=MOVE,2=CHECK_OCC,3=PUSH_EXT,4=WAIT_RECV,5=RETRACT,6=DONE *)
    slotIndex   : INT := 0;
    target      : INT := 0;
    doneLatched : BOOL := FALSE;
END_VAR

(* ---- Edge detect start request ---- *)
startEdge(CLK := X10);

IF startEdge.Q AND (NOT accepted) AND (NOT doneLatched) THEN
    accepted   := TRUE;
    slotIndex  := 0;
    target     := 0;
    state      := 1;
END_IF;

(* ---- Default outputs OFF each scan, then set per state ---- *)
Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;

IF accepted AND NOT doneLatched THEN

    CASE state OF

        1: (* MOVE_TO_TARGET *)
            IF NOT X22 THEN
                (* Pusher not retracted: retract first, do not move rack while pusher extended *)
                Y23 := TRUE;
                Y22 := FALSE;
            ELSE
                IF X25 THEN
                    (* aligned: stop and go check occupancy *)
                    Y20 := FALSE;
                    Y21 := FALSE;
                    state := 2;
                ELSE
                    IF D20 < target THEN
                        Y20 := TRUE;
                        Y21 := FALSE;
                    ELSE
                        Y21 := TRUE;
                        Y20 := FALSE;
                    END_IF;
                END_IF;
            END_IF;

        2: (* CHECK_OCCUPANCY *)
            IF X25 THEN
                IF X24 THEN
                    (* occupied: go to next slot if available *)
                    IF slotIndex < 3 THEN
                        slotIndex := slotIndex + 1;
                        target := slotIndex * 160;
                        state := 1;
                    ELSE
                        (* no more slots to try; stay (should not occur given at least one vacant) *)
                        state := 2;
                    END_IF;
                ELSE
                    (* vacant slot found *)
                    state := 3;
                END_IF;
            ELSE
                (* lost alignment somehow, go back to move state *)
                state := 1;
            END_IF;

        3: (* PUSH_EXTEND - only if aligned and vacant *)
            IF X25 AND (NOT X24) THEN
                Y22 := TRUE;
                Y23 := FALSE;
                IF X23 THEN
                    state := 4;
                END_IF;
            ELSE
                (* safety: unaligned or occupied, do not push *)
                Y22 := FALSE;
                Y23 := FALSE;
                state := 2;
            END_IF;

        4: (* WAIT_RECEIVED - keep pushed until receipt confirmed *)
            Y22 := TRUE;
            Y23 := FALSE;
            IF X26 THEN
                state := 5;
            END_IF;

        5: (* RETRACT *)
            Y23 := TRUE;
            Y22 := FALSE;
            IF X22 THEN
                Y23 := FALSE;
                Y22 := FALSE;
                state := 6;
            END_IF;

        6: (* DONE *)
            Y20 := FALSE;
            Y21 := FALSE;
            Y22 := FALSE;
            Y23 := FALSE;
            IF X22 AND (NOT X24 OR TRUE) THEN
                (* completion confirmed once pusher retracted and receipt happened *)
                doneLatched := TRUE;
                Y2 := TRUE;
            END_IF;

        ELSE
            (* undefined state guard *)
            state := 1;
    END_CASE;

END_IF;

(* ---- Maintain completion claim and safe actuator state after done ---- *)
IF doneLatched THEN
    Y2  := TRUE;
    Y20 := FALSE;
    Y21 := FALSE;
    Y22 := FALSE;
    Y23 := FALSE;
END_IF;

END_PROGRAM