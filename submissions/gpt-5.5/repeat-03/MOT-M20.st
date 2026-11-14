PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    X11 : BOOL;
    X12 : BOOL;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    Y21 : BOOL;
    Y22 : BOOL;
    Y2 : BOOL;
    state : INT;
    ratio_cmd : DINT;
    span_cmd : DINT;
    park_cmd : DINT;
    sync_u : DINT;
    ref_progress : DINT;
    park_norm : DINT;
    target_cmd : DINT;
    target_threshold : DINT;
    i : INT;
    done_latch : BOOL;
    result_ok : BOOL;
    resultTimer : TON;
    park_margin : DINT := 5000;
END_VAR

Y20 := FALSE;
Y21 := FALSE;
Y22 := FALSE;
D21 := target_cmd;

CASE state OF
    0:
        D20 := 0;
        Y2 := FALSE;
        IF X10 THEN
            ratio_cmd := D15;
            span_cmd := D14;
            park_cmd := D13;
            target_cmd := D11;
            D21 := target_cmd;
            done_latch := FALSE;
            state := 10;
        END_IF;

    10:
        D20 := ratio_cmd;
        Y20 := TRUE;
        state := 20;

    20:
        D20 := ratio_cmd;
        IF X11 AND X12 THEN
            sync_u := D10;
            state := 30;
        END_IF;

    30:
        D20 := ratio_cmd;
        ref_progress := D10 - sync_u;
        IF X12 AND (ref_progress >= span_cmd) THEN
            state := 40;
        END_IF;

    40:
        D20 := ratio_cmd;
        Y21 := TRUE;
        state := 50;

    50:
        D20 := ratio_cmd;
        IF NOT X12 THEN
            park_norm := park_cmd;

            FOR i := 0 TO 20 DO
                IF park_norm < 0 THEN
                    park_norm := park_norm + 36000;
                END_IF;
            END_FOR;

            FOR i := 0 TO 20 DO
                IF park_norm >= 36000 THEN
                    park_norm := park_norm - 36000;
                END_IF;
            END_FOR;

            target_cmd := park_norm;
            target_threshold := D11 + park_margin;

            FOR i := 0 TO 30 DO
                IF target_cmd < target_threshold THEN
                    target_cmd := target_cmd + 36000;
                END_IF;
            END_FOR;

            D21 := target_cmd;
            D20 := 0;
            Y22 := TRUE;
            state := 60;
        END_IF;

    60:
        D20 := 0;
        D21 := target_cmd;
        IF NOT X12 THEN
            Y22 := TRUE;
        END_IF;

    70:
        D20 := 0;
        D21 := target_cmd;
        IF NOT X12 THEN
            Y22 := TRUE;
        END_IF;

ELSE
    D20 := 0;
    state := 0;
END_CASE;

result_ok := (state >= 60) AND (NOT X12) AND Y22 AND (ABS(D11 - target_cmd) <= 20) AND (ABS(D12) <= 100);
resultTimer(IN := result_ok, PT := T#30ms);

IF resultTimer.Q THEN
    done_latch := TRUE;
    state := 70;
END_IF;

IF done_latch THEN
    Y2 := TRUE;
ELSE
    Y2 := FALSE;
END_IF;

END_PROGRAM