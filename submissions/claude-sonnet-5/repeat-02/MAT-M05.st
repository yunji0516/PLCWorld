PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D14 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y23 : BOOL;
    Y24 : BOOL;
    Y26 : BOOL;
    Y27 : BOOL;
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
    D20 : INT;
    D22 : INT;

    (* internal variables *)
    edge_trig : R_TRIG;
    state : INT := 0;
    layer_idx : INT := 1;
    layer_kind : ARRAY[1..4] OF INT;
    tgt : INT;
    arrived : BOOL;
END_VAR

edge_trig(CLK := X10);

// Default: reset all bidirectional stroke/direction commands each scan.
// (Grip Y20 and completion Y2 are level outputs handled explicitly below.)
Y21 := FALSE;
Y22 := FALSE;
Y23 := FALSE;
Y24 := FALSE;
Y26 := FALSE;
Y27 := FALSE;

CASE state OF

0: // IDLE - wait for accepted start request
    IF edge_trig.Q THEN
        layer_kind[1] := D11;
        layer_kind[2] := D12;
        layer_kind[3] := D13;
        layer_kind[4] := D14;
        layer_idx := 1;
        state := 2;
    END_IF;

2: // ensure fully lifted (>=250mm) before any horizontal move
    IF X23 THEN
        state := 3;
    ELSE
        Y23 := TRUE;
    END_IF;

3: // move horizontally to the required source (A or B)
    IF layer_kind[layer_idx] = 0 THEN
        tgt := -700;
    ELSE
        tgt := 700;
    END_IF;
    arrived := (tgt = -700 AND X20) OR (tgt = 700 AND X21);
    IF arrived THEN
        state := 4;
    ELSE
        IF D20 > tgt + 2 THEN
            Y21 := TRUE;
        ELSIF D20 < tgt - 2 THEN
            Y22 := TRUE;
        END_IF;
    END_IF;

4: // descend to pick position
    IF X24 THEN
        state := 5;
    ELSE
        Y24 := TRUE;
    END_IF;

5: // grip the source plate, wait for holding confirmation
    IF X27 THEN
        Y20 := TRUE;
        IF X25 THEN
            state := 6;
        END_IF;
    END_IF;

6: // lift after pick, before horizontal travel
    IF X23 THEN
        state := 7;
    ELSE
        Y23 := TRUE;
    END_IF;

7: // move horizontally to stack
    tgt := 0;
    arrived := X22;
    IF arrived THEN
        state := 8;
    ELSE
        IF D20 > tgt + 2 THEN
            Y21 := TRUE;
        ELSIF D20 < tgt - 2 THEN
            Y22 := TRUE;
        END_IF;
    END_IF;

8: // adjust deck so actual stack top matches the fixed receiving height
    IF D22 > 701 THEN
        Y26 := TRUE;
    ELSIF D22 < 699 THEN
        Y27 := TRUE;
    ELSE
        state := 9;
    END_IF;

9: // descend to place the plate on the stack
    IF X24 THEN
        state := 10;
    ELSE
        Y24 := TRUE;
    END_IF;

10: // release grip; wait for released & actual receipt confirmation
    Y20 := FALSE;
    IF X26 AND X28 THEN
        state := 11;
    END_IF;

11: // lift after placement
    IF X23 THEN
        state := 12;
    ELSE
        Y23 := TRUE;
    END_IF;

12: // advance to next layer or finish
    layer_idx := layer_idx + 1;
    IF layer_idx > 4 THEN
        state := 13;
    ELSE
        state := 2;
    END_IF;

13: // return to A (upper) position
    tgt := -700;
    arrived := X20;
    IF arrived THEN
        state := 14;
    ELSE
        IF D20 > tgt + 2 THEN
            Y21 := TRUE;
        ELSIF D20 < tgt - 2 THEN
            Y22 := TRUE;
        END_IF;
    END_IF;

14: // done - hold completion, keep tool idle with all actuators off
    Y20 := FALSE;
    Y2 := TRUE;

ELSE
    ;

END_CASE;

END_PROGRAM