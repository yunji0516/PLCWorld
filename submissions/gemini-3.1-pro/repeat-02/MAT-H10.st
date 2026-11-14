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
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;

    ExtSM : INT := 0;
    A_dispatched : INT := 0;
    B_dispatched : INT := 0;
    Target : INT := 0;

    out_lower : BOOL := TRUE;
    out_upper : BOOL := FALSE;
    out_extract : BOOL := FALSE;
    send_pulse : BOOL := FALSE;

    ext_timer : TON;

    swap_cond : BOOL;
    swap_trig : R_TRIG;
    swap_done : BOOL := FALSE;

    take_trig : R_TRIG;

    a_assembled : BOOL := FALSE;
    a_released : BOOL := FALSE;
    assemble_a_cond : BOOL;
    assemble_a_trig : R_TRIG;
    release_a_cond : BOOL;
    release_a_trig : R_TRIG;

    b_assembled : BOOL := FALSE;
    b_released : BOOL := FALSE;
    assemble_b_cond : BOOL;
    assemble_b_trig : R_TRIG;
    release_b_cond : BOOL;
    release_b_trig : R_TRIG;

    comp_cond : BOOL;
END_VAR

ext_timer(IN := (ExtSM = 3), PT := T#200ms);

CASE ExtSM OF
    0:
        IF X0 AND X16 AND X11 AND X10 AND (D1 > 0) AND NOT X19 THEN
            IF A_dispatched < 3 THEN
                Target := 1;
                ExtSM := 1;
            ELSIF B_dispatched < 4 THEN
                Target := 2;
                ExtSM := 1;
            END_IF;
        END_IF;
    1:
        out_upper := TRUE;
        IF X12 THEN
            ExtSM := 2;
        END_IF;
    2:
        out_lower := FALSE;
        IF X15 AND X17 THEN
            ExtSM := 3;
        END_IF;
    3:
        out_extract := TRUE;
        IF ext_timer.Q AND X18 THEN
            ExtSM := 4;
        END_IF;
    4:
        out_extract := FALSE;
        out_lower := TRUE;
        IF X14 THEN
            ExtSM := 5;
        END_IF;
    5:
        out_upper := FALSE;
        IF X13 THEN
            ExtSM := 6;
        END_IF;
    6:
        IF Target = 1 THEN
            IF NOT X1F AND NOT X21 THEN
                D200 := 1;
                D201 := A_dispatched + 1;
                send_pulse := TRUE;
                A_dispatched := A_dispatched + 1;
                ExtSM := 7;
            END_IF;
        ELSIF Target = 2 THEN
            IF NOT X25 AND NOT X27 THEN
                D200 := 2;
                D201 := B_dispatched + 1;
                send_pulse := TRUE;
                B_dispatched := B_dispatched + 1;
                ExtSM := 7;
            END_IF;
        END_IF;
    7:
        send_pulse := FALSE;
        IF NOT X16 THEN
            ExtSM := 0;
        END_IF;
END_CASE;

swap_cond := (D1 = 0) AND X18 AND X14 AND X13 AND X1A AND NOT X1B AND NOT swap_done;
swap_trig(CLK := swap_cond);
IF swap_trig.Q THEN
    swap_done := TRUE;
END_IF;

take_trig(CLK := X1B);

IF NOT X1F THEN
    a_assembled := FALSE;
    a_released := FALSE;
END_IF;
assemble_a_cond := X1F AND X20 AND NOT X21 AND NOT a_assembled;
assemble_a_trig(CLK := assemble_a_cond);
IF assemble_a_trig.Q THEN
    a_assembled := TRUE;
END_IF;
release_a_cond := X22 AND X23 AND NOT X21 AND NOT a_released;
release_a_trig(CLK := release_a_cond);
IF release_a_trig.Q THEN
    a_released := TRUE;
END_IF;

IF NOT X25 THEN
    b_assembled := FALSE;
    b_released := FALSE;
END_IF;
assemble_b_cond := X25 AND X26 AND NOT X27 AND NOT b_assembled;
assemble_b_trig(CLK := assemble_b_cond);
IF assemble_b_trig.Q THEN
    b_assembled := TRUE;
END_IF;
release_b_cond := X28 AND X29 AND NOT X27 AND NOT b_released;
release_b_trig(CLK := release_b_cond);
IF release_b_trig.Q THEN
    b_released := TRUE;
END_IF;

comp_cond := (D3 = 3) AND (D4 = 4) AND (D0 = 202) AND (D1 = 1) AND X16 AND X14 AND X13 AND X1C;
IF comp_cond THEN
    Y1A := TRUE;
END_IF;

Y10 := out_lower;
Y11 := out_upper;
Y12 := out_extract;
Y13 := send_pulse;
Y14 := swap_trig.Q;
Y15 := take_trig.Q;
Y16 := assemble_a_trig.Q;
Y17 := assemble_b_trig.Q;
Y18 := release_a_trig.Q;
Y19 := release_b_trig.Q;

END_PROGRAM