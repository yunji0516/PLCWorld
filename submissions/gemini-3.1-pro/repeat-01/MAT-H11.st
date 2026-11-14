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
    Y23 : BOOL;
    Y24 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D13 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    X2A : BOOL;
    X2B : BOOL;
    X2C : BOOL;
    X2D : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;
    
    exit_count : INT := 0;
    exit_edge : R_TRIG;
    
    cradle_st : INT := 0;
    head_st : INT := 0;
    b_clamp_st : INT := 0;
    
    req_job : INT := 0;
    req_tool : INT := 0;
    req_tool_internal : INT := 0;
    
    a_transfer_done : BOOL := FALSE;
    a_work_done : BOOL := FALSE;
    b_working_flag : BOOL := FALSE;
    
    cradle_cmd_lock : BOOL := FALSE;
    cradle_cmd_unlock : BOOL := FALSE;
END_VAR

(* Jig Width Adjustments *)
IF D10 = 1 THEN D201 := 160; ELSIF D10 = 2 THEN D201 := 120; ELSE D201 := 160; END_IF;
Y23 := TRUE;

IF D13 = 1 THEN D202 := 160; ELSIF D13 = 2 THEN D202 := 120; ELSE D202 := 160; END_IF;
Y24 := TRUE;

(* A Station Work *)
IF a_transfer_done AND X2C AND NOT X15 AND NOT X16 AND NOT a_work_done THEN
    Y11 := TRUE;
ELSE
    Y11 := FALSE;
END_IF;

IF X15 THEN
    a_work_done := TRUE;
END_IF;
IF NOT X14 THEN
    a_work_done := FALSE;
END_IF;

(* Exit Reception *)
Y1B := X20;
exit_edge(CLK := X20);
IF exit_edge.Q THEN
    exit_count := exit_count + 1;
END_IF;

(* Head Job Scheduling *)
req_job := 0;
req_tool := 0;

IF cradle_st = 40 AND X2D AND b_clamp_st = 0 AND NOT X1C THEN
    req_job := 1;
    IF D13 = 1 THEN req_tool := 1; ELSIF D13 = 2 THEN req_tool := 2; ELSE req_tool := 1; END_IF;
ELSIF a_transfer_done AND X15 AND cradle_st = 0 AND NOT X17 AND NOT X1A THEN
    req_job := 3;
    IF D11 = 1 THEN req_tool := 1; ELSIF D11 = 2 THEN req_tool := 2; ELSE req_tool := 1; END_IF;
ELSIF X10 AND X28 AND NOT X14 AND NOT a_transfer_done THEN
    req_job := 2;
    IF D10 = 1 THEN req_tool := 1; ELSIF D10 = 2 THEN req_tool := 2; ELSE req_tool := 1; END_IF;
END_IF;

(* Head State Machine *)
CASE head_st OF
    0:
        IF exit_count >= 4 AND req_job = 0 THEN
            IF D8 <> 0 THEN
                req_tool_internal := 0;
                head_st := 10;
            ELSIF X2A THEN
                head_st := 900;
            END_IF;
        ELSIF req_job <> 0 THEN
            IF D8 = req_tool THEN
                IF req_job = 1 THEN head_st := 100;
                ELSIF req_job = 2 THEN head_st := 200;
                ELSIF req_job = 3 THEN head_st := 300;
                END_IF;
            ELSE
                req_tool_internal := req_tool;
                head_st := 10;
            END_IF;
        END_IF;

    10:
        IF D8 <> 0 THEN
            D200 := D8;
            head_st := 20;
        ELSE
            D200 := req_tool_internal;
            head_st := 40;
        END_IF;

    20:
        Y1F := TRUE;
        IF X2A THEN
            Y1F := FALSE;
            head_st := 21;
        END_IF;
    21:
        Y20 := TRUE;
        IF NOT X2B THEN
            Y20 := FALSE;
            head_st := 22;
        END_IF;
    22:
        IF req_tool_internal <> 0 THEN
            head_st := 10;
        ELSE
            head_st := 0;
        END_IF;

    40:
        Y1F := TRUE;
        IF X2A THEN
            Y1F := FALSE;
            head_st := 41;
        END_IF;
    41:
        Y21 := TRUE;
        IF X2B AND D8 = req_tool_internal THEN
            Y21 := FALSE;
            head_st := 42;
        END_IF;
    42:
        Y22 := TRUE;
        IF NOT X2A AND NOT X29 THEN
            Y22 := FALSE;
            head_st := 0;
        END_IF;

    100:
        Y16 := TRUE;
        IF X12 THEN
            Y16 := FALSE;
            cradle_cmd_unlock := TRUE;
            head_st := 101;
        END_IF;
    101:
        IF X19 THEN
            cradle_cmd_unlock := FALSE;
            head_st := 102;
        END_IF;
    102:
        Y18 := TRUE;
        IF X1C AND NOT X12 THEN
            Y18 := FALSE;
            head_st := 0;
        END_IF;

    200:
        Y10 := TRUE;
        IF X14 AND NOT X11 THEN
            Y10 := FALSE;
            a_transfer_done := TRUE;
            head_st := 0;
        END_IF;

    300:
        Y12 := TRUE;
        IF X17 THEN
            Y12 := FALSE;
            cradle_cmd_lock := TRUE;
            head_st := 301;
        END_IF;
    301:
        IF X18 THEN
            cradle_cmd_lock := FALSE;
            head_st := 302;
        END_IF;
    302:
        Y14 := TRUE;
        IF NOT X12 THEN
            Y14 := FALSE;
            a_transfer_done := FALSE;
            head_st := 0;
        END_IF;

    900:
        Y10 := TRUE;
        IF NOT X2A THEN
            Y10 := FALSE;
            head_st := 902;
        END_IF;
    902:
        head_st := 0;
END_CASE;

(* Cradle State Machine *)
CASE cradle_st OF
    0:
        IF cradle_cmd_lock THEN
            cradle_st := 10;
        END_IF;
    10:
        Y13 := TRUE;
        IF X18 THEN
            Y13 := FALSE;
            cradle_st := 15;
        END_IF;
    15:
        IF X13 THEN
            cradle_st := 20;
        END_IF;
    20:
        Y15 := TRUE;
        cradle_st := 21;
    21:
        Y15 := FALSE;
        cradle_st := 30;
    30:
        IF X1A THEN
            cradle_st := 40;
        END_IF;
    40:
        IF cradle_cmd_unlock THEN
            cradle_st := 50;
        END_IF;
    50:
        Y17 := TRUE;
        IF X19 THEN
            Y17 := FALSE;
            cradle_st := 55;
        END_IF;
    55:
        IF NOT X17 AND NOT X12 THEN
            IF exit_count < 4 THEN
                cradle_st := 60;
            ELSE
                cradle_st := 80;
            END_IF;
        END_IF;
    60:
        Y15 := TRUE;
        cradle_st := 61;
    61:
        Y15 := FALSE;
        cradle_st := 70;
    70:
        IF NOT X1A THEN
            cradle_st := 0;
        END_IF;
    80:
        (* Terminate *)
END_CASE;

(* B Clamp and Operations State Machine *)
CASE b_clamp_st OF
    0:
        IF X1C AND X27 AND NOT b_working_flag THEN
            b_clamp_st := 10;
        END_IF;
    10:
        Y1D := TRUE;
        Y1E := TRUE;
        IF X23 AND X25 THEN
            b_clamp_st := 20;
        END_IF;
    20:
        b_working_flag := TRUE;
        IF X22 AND NOT X1E THEN
            Y19 := TRUE;
            b_clamp_st := 21;
        END_IF;
    21:
        IF X1D THEN
            Y19 := FALSE;
            b_clamp_st := 30;
        END_IF;
    30:
        Y1D := FALSE;
        IF X24 AND X25 THEN
            b_clamp_st := 40;
        END_IF;
    40:
        Y1A := TRUE;
        IF NOT X1C THEN
            Y1A := FALSE;
            Y1E := FALSE;
            b_working_flag := FALSE;
            b_clamp_st := 0;
        END_IF;
END_CASE;

(* Overall Completion *)
Y1C := (exit_count >= 4) AND (head_st = 0) AND NOT X2A AND NOT X14 AND NOT X17 AND NOT X1C;

END_PROGRAM