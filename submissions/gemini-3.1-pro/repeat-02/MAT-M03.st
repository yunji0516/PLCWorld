PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y25 : BOOL;
    Y26 : BOOL;
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
    X30 : BOOL;
    X31 : BOOL;
    X32 : BOOL;
    Y2 : BOOL;

    state : INT := 0;
    start_edge : R_TRIG;
    align_tmr : TON;
END_VAR

start_edge(CLK := X10);
align_tmr(IN := (state = 1), PT := T#500ms);

CASE state OF
    0:
        IF start_edge.Q AND (D10 = 1) THEN
            state := 1;
        END_IF;

    1:
        (* Align the unheld workpiece on the source support *)
        IF align_tmr.Q AND X31 AND X32 AND X30 THEN
            state := 2;
        END_IF;

    2:
        (* Retract alignment fingers and wait for them to be clear before any travel *)
        IF X29 THEN
            state := 3;
        END_IF;

    3:
        (* Lower tool to source *)
        IF X22 THEN
            state := 4;
        END_IF;

    4:
        (* Grip workpiece *)
        IF X24 THEN
            state := 5;
        END_IF;

    5:
        (* Raise tool at source *)
        IF X23 THEN
            state := 6;
        END_IF;

    6:
        (* Advance horizontally to receiver *)
        IF X21 THEN
            state := 7;
        END_IF;

    7:
        (* Lower tool to receiver *)
        IF X22 THEN
            state := 8;
        END_IF;

    8:
        (* Release workpiece *)
        IF X25 THEN
            state := 9;
        END_IF;

    9:
        (* Raise empty tool at receiver *)
        IF X23 THEN
            state := 10;
        END_IF;

    10:
        (* Return empty tool to source *)
        IF X20 AND X23 THEN
            state := 11;
        END_IF;

    11:
        (* Sequence complete; claim successful terminal result *)
        state := 11;

END_CASE;

(* Centralized output assignments based on the active state *)
Y20 := (state = 4) OR (state = 5) OR (state = 6) OR (state = 7);
Y21 := (state = 6) OR (state = 7) OR (state = 8) OR (state = 9);
Y22 := (state = 10);
Y23 := (state = 5) OR (state = 6) OR (state = 9) OR (state = 10);
Y24 := (state = 3) OR (state = 4) OR (state = 7) OR (state = 8);
Y25 := (state = 1);
Y26 := (state = 1);
Y2  := (state = 11);

END_PROGRAM