PROGRAM Main
VAR
    X0 : BOOL;
    X10 : BOOL;
    X11 : BOOL;
    X12 : BOOL;
    X13 : BOOL;
    X14 : BOOL;
    X15 : BOOL;
    X16 : BOOL;
    X17 : BOOL;
    X18 : BOOL;
    X19 : BOOL;
    X20 : BOOL;
    X21 : BOOL;
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
    X26 : BOOL;
    X27 : BOOL;
    X28 : BOOL;
    X29 : BOOL;
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    Y19 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D200 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    (* Add internal variables here. *)
    state : INT := 0;
    pitch_counter : INT := 0;
    recovery_batches : INT := 0;
    timer : TON;
    edge : R_TRIG;
END_VAR

(* Implement the control logic here. *)
timer(IN := (state = 1), PT := T#500ms);

edge(CLK := X10);

CASE state OF
    0: (* Initial state *)
        IF X0 THEN
            state := 1;
        END_IF;

    1: (* Accept the next pitch *)
        IF NOT X11 AND NOT X13 AND X10 THEN
            Y10 := TRUE;
            state := 2;
        END_IF;

    2: (* Feed the web *)
        IF Y10 THEN
            Y11 := TRUE;
            IF X14 THEN
                Y10 := FALSE;
                Y11 := FALSE;
                state := 3;
            END_IF;
        END_IF;

    3: (* Cut the connections *)
        IF NOT X18 AND X12 THEN
            Y13 := TRUE;
            D200 := 15;
            IF X23 THEN
                Y13 := FALSE;
                state := 4;
            END_IF;
        END_IF;

    4: (* Handle residue if full *)
        IF X21 THEN
            Y1C := TRUE;
            timer(IN := TRUE, PT := T#300ms);
            IF timer.Q THEN
                Y1C := FALSE;
                state := 5;
            END_IF;
        ELSE
            state := 6;
        END_IF;

    5: (* Unload reel if full *)
        Y1F := TRUE;
        IF X14 THEN
            Y1F := FALSE;
            state := 6;
        END_IF;

    6: (* Proceed with recovery *)
        IF X19 AND NOT X18 THEN
            Y18 := TRUE;
            IF X1D THEN
                Y18 := FALSE;
                recovery_batches := recovery_batches + 1;
                state := 1;
                pitch_counter := pitch_counter + 1;
            END_IF;
        END_IF;

    7: (* Completion check *)
        IF recovery_batches >= 4 AND pitch_counter >= 6 THEN
            Y1B := TRUE;
        END_IF;
END_CASE;

IF X1F THEN
    Y1B := TRUE;
END_IF;

END_PROGRAM