PROGRAM Main
VAR
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D18 : DINT;
    D19 : DINT;
    D20 : DINT;
    D21 : DINT;
    D100 : DINT;
    X30 : BOOL;
    X32 : BOOL;
    D104 : DINT;
    D103 : DINT;
    D110 : DINT;
    X31 : BOOL;
    X33 : BOOL;
    D114 : DINT;
    D113 : DINT;
    X51 : BOOL;
    D90 : DINT;
    D91 : DINT;
    D92 : DINT;
    D93 : DINT;
    D94 : DINT;
    D95 : DINT;
    D96 : DINT;
    X52 : BOOL;
    X53 : BOOL;
    X54 : BOOL;
    X55 : BOOL;
    X56 : BOOL;
    X57 : BOOL;
    D150 : DINT;
    D151 : DINT;
    D200 : DINT;
    D201 : DINT;
    Y20 : BOOL;
    D204 : DINT;
    D205 : DINT;
    Y21 : BOOL;
    D208 : DINT;
    D209 : DINT;
    Y22 : BOOL;
    D212 : DINT;
    D213 : DINT;
    Y23 : BOOL;
    D216 : DINT;
    D217 : DINT;
    Y24 : BOOL;
    D220 : DINT;
    D221 : DINT;
    Y25 : BOOL;
    D300 : DINT;
    D301 : DINT;
    D302 : DINT;
    D303 : DINT;
    D80 : DINT;
    D81 : DINT;
    D82 : DINT;
    Y2 : BOOL;
    requestA_in_progress : BOOL := FALSE;
    requestB_in_progress : BOOL := FALSE;
    coupleSeqNum : DINT := 0;
    readyForNextTask: BOOL := FALSE;
END_VAR

(* Control logic for managing hoist requests and shuttle operations. *)

(* A Task Management *)
IF NOT requestA_in_progress AND NOT requestB_in_progress THEN
    IF D104 = 0 THEN
        requestA_in_progress := TRUE;
    ELSIF D114 = 0 THEN
        requestB_in_progress := TRUE;
    END_IF;
END_IF;

(* Handle Request A if it is in progress *)
IF requestA_in_progress THEN
    IF D104 = 0 THEN // Currently on Shuttle
        IF X54 THEN  // Check if Lift A is ready
            a_target := 0; // Move shuttle to lift A position
            a_rate := 1000;
            a_enable := TRUE;
            IF ABS(D10 - 0) <= 20 THEN // Approaching lift A
                b_target := 180; // Extend fork
                b_rate := 1000;
                b_enable := TRUE;
                IF ABS(D12 - 180) <= 20 THEN // Fork extended successfully
                    requestA_in_progress := FALSE;
                    RETURN;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

(* Handle Request B if it is in progress *)
IF requestB_in_progress THEN
    IF D114 = 0 THEN // Currently on Shuttle
        IF X55 THEN  // Check if Lift B is ready
            a_target := 850; // Move shuttle to lift B position
            a_rate := 1000;
            a_enable := TRUE;
            IF ABS(D10 - 850) <= 20 THEN // Approaching lift B
                b_target := 180; // Extend fork
                b_rate := 1000;
                b_enable := TRUE;
                IF ABS(D12 - 180) <= 20 THEN // Fork extended successfully
                    requestB_in_progress := FALSE;
                    RETURN;
                END_IF;
            END_IF;
        END_IF;
    END_IF;
END_IF;

(* Manage Coupling Sequence and Commands *)
IF NOT (requestA_in_progress OR requestB_in_progress) THEN
    IF readyForNextTask THEN
        // If all tasks are done, and no tasks are in progress
        readyForNextTask := FALSE;
        IF X30 OR X31 THEN
            // Check completion of request
            coupleSeqNum := coupleSeqNum + 1;
            D82 := coupleSeqNum;
            IF X30 THEN
                ack0 := D100;
                status0 := 1;
            ELSE
                ack1 := D110;
                status1 := 1;
            END_IF;
            Y2 := TRUE; // Set completion signal
        END_IF;
    END_IF;
END_IF;

END_PROGRAM