PROGRAM Main
VAR
    X0 : BOOL; (* Start signal *)
    D10 : DINT; (* A-axis position *)
    D11 : DINT; (* A-axis velocity *)
    D12 : DINT; (* B-axis position *)
    D13 : DINT; (* B-axis velocity *)
    D14 : DINT; (* C-axis position *)
    D15 : DINT; (* C-axis velocity *)
    X1 : BOOL; (* Latch open *)
    X2 : BOOL; (* Latch engaged *)
    X3 : BOOL; (* End stops closed *)
    X4 : BOOL; (* Joint aligned *)
    X5 : BOOL; (* Fully fixed *)
    D90 : DINT; (* Interlock reason *)
    D101 : DINT; (* Request dock location *)
    D102 : DINT; (* Request park location *)
    D20 : DINT; (* A-axis target position *)
    D21 : DINT; (* A-axis rate *)
    Y20 : BOOL; (* A-axis enable signal *)
    D24 : DINT; (* B-axis target position *)
    D25 : DINT; (* B-axis rate *)
    Y21 : BOOL; (* B-axis enable signal *)
    D28 : DINT; (* C-axis target position *)
    D29 : DINT; (* C-axis rate *)
    Y22 : BOOL; (* C-axis enable signal *)
    Y30 : BOOL; (* Latch engage command *)
    Y31 : BOOL; (* Latch release command *)
    Y2 : BOOL; (* Result signal *)

    (* Internal variables *)
    state : INT := 0;
    timer : TON;
    latch_timer : TON;
    start_cycle : BOOL := FALSE;
END_VAR

(* Timer for latch engagement/release *)
latch_timer(IN := (Y30 OR Y31), PT := T#250ms);

(* Main control logic *)
IF NOT start_cycle AND X0 THEN
    start_cycle := TRUE;
    state := 0; (* Initialize state machine *)
END_IF

CASE state OF
    0: (* Initial state - move to dock and engage latch *)
        IF NOT X0 THEN
            start_cycle := FALSE; (* Wait for start signal *)
        ELSE
            D20 := D101; (* Set target for A-axis *)
            D21 := 1000; (* Set rate for A-axis *)
            Y20 := TRUE; 

            D24 := D101; (* Set target for B-axis *)
            D25 := 1000; (* Set rate for B-axis *)
            Y21 := TRUE;
            
            IF (ABS(D10 - D101) <= 20 AND ABS(D12 - D101) <= 20) THEN
                IF X4 THEN (* Check if joint is aligned *)
                    Y30 := TRUE; (* Engage latch *)
                    IF latch_timer.Q THEN
                        Y30 := FALSE;
                        state := 1; (* Move to next state *)
                    END_IF
                ELSE
                    Y20 := FALSE;
                    Y21 := FALSE; (* Stop movement if misaligned *)
                END_IF
            END_IF
        END_IF

    1: (* Transfer cart to park position *)
        D28 := D102; (* Set target for C-axis *)
        D29 := 1000; (* Set rate for C-axis *)
        Y22 := TRUE;

        IF (ABS(D14 - D102) <= 20 AND X5) THEN (* Arrival check *)
            Y22 := FALSE;
            state := 2; (* Move to next state *)
        END_IF

    2: (* Return only the empty beam *)
        Y30 := FALSE; 
        Y31 := TRUE; (* Release latch *)
        
        IF latch_timer.Q THEN
            Y31 := FALSE; (* Stop release command after 250 ms *)
            D20 := 0; (* Return A-axis to origin *)
            D24 := 0; (* Return B-axis to origin *)
            Y20 := TRUE;
            Y21 := TRUE;
            state := 3;
        END_IF

    3: (* Completion check *)
        IF (ABS(D10) <= 20 AND ABS(D12) <= 20 AND NOT Y22) THEN
            Y20 := FALSE;
            Y21 := FALSE;
            Y2 := TRUE; (* Set result flag *)
            state := 4; (* Task completed *)
        END_IF

END_CASE

END_PROGRAM