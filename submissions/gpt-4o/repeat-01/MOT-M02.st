PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    X1 : BOOL;
    X2 : BOOL;
    X3 : BOOL;
    X4 : BOOL;
    X5 : BOOL;
    D90 : DINT;
    D101 : DINT;
    D102 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    Y30 : BOOL;
    Y31 : BOOL;
    Y2 : BOOL;
    (* Internal variables *)
    state : INT := 0;
    latch_timer : TON;
    move_timer : TON;
    park_position : DINT;
    dock_position : DINT;
    x0_triggered : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)

(* Initialize parking and docking positions upon start *)
park_position := D102;
dock_position := D101;

(* Latch engagement delay *)
latch_timer(IN := (state = 2 OR state = 6), PT := T#250ms);
move_timer(IN := (state = 4), PT := T#35s);

CASE state OF
    0: (* Wait for start signal *)
        IF X0 THEN
            x0_triggered := TRUE;
            state := 1;
        END_IF;

    1: (* Align and secure both end beams to the dock *)
        IF X4 AND x0_triggered THEN
            D20 := dock_position * 100; (* Set target position for both axes A and B *)
            D24 := dock_position * 100;
            D21 := 1000; (* Maximum rate *)
            D25 := 1000;
            Y20 := TRUE;
            Y21 := TRUE;
            IF ABS(D10 - D12) <= 12 THEN
                Y30 := TRUE; (* Engage latch *)
                state := 2;
            END_IF;
        END_IF;
    
    2: (* Wait for latch engagement *)
        IF X2 THEN
            Y30 := FALSE;
            state := 3;
        END_IF;
    
    3: (* Transfer cart to the fixed rail and park *)
        Y31 := TRUE;
        IF NOT X1 THEN
            IF ABS(D14 - park_position) > 0.2 THEN
                D28 := park_position * 100; (* Set target for C position *)
                D29 := 1000; (* Maximum rate *)
                Y22 := TRUE;
            ELSE
                Y22 := FALSE;
                state := 4;
            END_IF;
        END_IF;
    
    4: (* Wait for cart to park and stabilize *)
        IF NOT Y22 THEN
            state := 5;
        END_IF;
    
    5: (* Disconnect cart *)
        Y31 := FALSE;
        IF NOT X2 THEN
            state := 6;
        END_IF;
    
    6: (* Return the empty beam to the origin *)
        D20 := 0; (* Set target position for A *)
        D24 := 0; (* Set target position for B *)
        D21 := 1000;
        D25 := 1000;
        Y20 := TRUE;
        Y21 := TRUE;
        IF D10 < 12 AND D12 < 12 THEN
            state := 7;
        END_IF;

    7: (* Completion logic *)
        IF move_timer.Q THEN
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := TRUE; (* Indicate result success *)
            state := 8;
        END_IF;

    8: (* Maintain completion for 100 ms *)
        (* This state ensures the result output is maintained for observation *)
END_CASE;

END_PROGRAM