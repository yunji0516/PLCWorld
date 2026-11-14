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
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D8 : INT;
    D9 : INT;
    D10 : INT;
    D11 : INT;
    D12 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    
    admit_count : INT := 0;
    received_count : INT := 0;
    
    inspect_state : INT := 0;
    
    admit_req : BOOL := FALSE;
    detach_req : BOOL := FALSE;
    ack_exit_req : BOOL := FALSE;
    
    transfer_state : INT := 0;
    
    ll_state : INT := 0;
    rl_state : INT := 0;
    
    ll_starting : BOOL := FALSE;
    rl_starting : BOOL := FALSE;
    
    ton_ll : TON;
    ton_rl : TON;
    
    any_lift_moving : BOOL := FALSE;
    stopped : BOOL := FALSE;
    products_done : BOOL := FALSE;
END_VAR

ton_ll(IN := ll_starting AND NOT X1B, PT := T#500ms);
IF ton_ll.Q THEN 
    ll_starting := FALSE; 
END_IF;

ton_rl(IN := rl_starting AND NOT X1C, PT := T#500ms);
IF ton_rl.Q THEN 
    rl_starting := FALSE; 
END_IF;

any_lift_moving := X1B OR X1C OR ll_starting OR rl_starting;

Y14 := FALSE;
Y15 := FALSE;
Y16 := FALSE;
Y17 := FALSE;

CASE ll_state OF
    0:
        IF X17 THEN 
            ll_state := 4;
        ELSIF X18 THEN 
            ll_state := 2;
        ELSIF NOT X11 AND transfer_state = 0 THEN 
            Y14 := TRUE; 
            ll_starting := TRUE; 
            ll_state := 3; 
        END_IF;
    1:
        IF D0 = 0 AND NOT X1B AND NOT X11 AND transfer_state = 0 THEN
            Y15 := TRUE; 
            ll_starting := TRUE; 
            ll_state := 2;
        END_IF;
    2:
        IF X18 THEN
            IF D0 > 0 AND X1F AND NOT X11 AND transfer_state = 0 THEN 
                Y14 := TRUE; 
                ll_starting := TRUE; 
                ll_state := 3;
            END_IF;
        END_IF;
    3:
        IF X17 THEN
            ll_state := 4;
        END_IF;
    4:
        IF D0 = 0 THEN
            ll_state := 1;
        END_IF;
END_CASE;

IF X1B THEN 
    ll_starting := FALSE; 
END_IF;


CASE rl_state OF
    0:
        IF X19 THEN 
            rl_state := 2;
        ELSIF X1A THEN 
            rl_state := 4;
        ELSIF NOT X11 AND transfer_state = 0 THEN 
            Y16 := TRUE; 
            rl_starting := TRUE; 
            rl_state := 1; 
        END_IF;
    1:
        IF X19 THEN
            rl_state := 2;
        END_IF;
    2:
        IF X19 THEN
            IF D3 > 0 AND X1E AND NOT X11 AND transfer_state = 0 THEN
                Y17 := TRUE; 
                rl_starting := TRUE; 
                rl_state := 3;
            END_IF;
        END_IF;
    3:
        IF X1A THEN
            rl_state := 4;
        END_IF;
    4:
        IF X1A THEN
            IF D3 = 0 AND NOT X1C AND NOT X11 AND transfer_state = 0 THEN
                Y16 := TRUE; 
                rl_starting := TRUE; 
                rl_state := 1;
            END_IF;
        END_IF;
END_CASE;

IF X1C THEN 
    rl_starting := FALSE; 
END_IF;

IF D0 > 0 AND D5 = 0 AND X17 AND X10 AND NOT X12 AND admit_count < 6 AND NOT admit_req THEN
    admit_req := TRUE;
    admit_count := admit_count + 1;
END_IF;

IF admit_req THEN
    Y10 := TRUE;
    IF X12 THEN
        admit_req := FALSE;
    END_IF;
ELSE
    Y10 := FALSE;
END_IF;

CASE inspect_state OF
    0:
        IF D1 > 0 AND D6 > 0 AND NOT X14 THEN
            D202 := D8;
            inspect_state := 1;
        END_IF;
    1:
        Y11 := TRUE;
        IF X14 THEN
            inspect_state := 2;
        END_IF;
    2:
        Y11 := FALSE;
        IF NOT X14 AND D10 = D202 AND D9 = D6 THEN
            inspect_state := 3;
        END_IF;
    3:
        Y11 := FALSE;
        IF D1 = 0 THEN
            inspect_state := 0;
        END_IF;
END_CASE;

IF D2 > 0 AND D7 > 0 AND X15 AND NOT X13 AND NOT detach_req THEN
    detach_req := TRUE;
END_IF;

IF detach_req THEN
    Y12 := TRUE;
    IF X13 THEN
        detach_req := FALSE;
    END_IF;
ELSE
    Y12 := FALSE;
END_IF;

IF X16 AND NOT ack_exit_req THEN
    ack_exit_req := TRUE;
    received_count := received_count + 1;
END_IF;

IF ack_exit_req THEN
    Y18 := TRUE;
    IF NOT X16 THEN
        ack_exit_req := FALSE;
    END_IF;
ELSE
    Y18 := FALSE;
END_IF;

Y13 := FALSE;

IF transfer_state = 0 AND NOT X11 AND NOT any_lift_moving THEN
    IF D3 > 0 AND D4 = 0 AND X1A THEN
        D200 := D3; 
        D201 := 4; 
        transfer_state := 1;
    ELSIF D2 > 0 AND D7 = 0 AND NOT X13 AND D3 = 0 AND X19 THEN
        D200 := D2; 
        D201 := 3; 
        transfer_state := 1;
    ELSIF D1 > 0 AND inspect_state = 3 AND D2 = 0 THEN
        D200 := D1; 
        D201 := 2; 
        transfer_state := 1;
    ELSIF D0 > 0 AND D5 > 0 AND NOT X12 AND D1 = 0 AND X17 THEN
        D200 := D0; 
        D201 := 1; 
        transfer_state := 1;
    ELSIF D4 > 0 AND D0 = 0 AND X18 THEN
        D200 := D4; 
        D201 := 0; 
        transfer_state := 1;
    END_IF;
END_IF;

IF transfer_state = 1 THEN
    Y13 := TRUE;
    transfer_state := 2;
ELSIF transfer_state = 2 THEN
    IF X11 THEN
        transfer_state := 3;
    END_IF;
ELSIF transfer_state = 3 THEN
    IF NOT X11 THEN
        transfer_state := 0;
    END_IF;
END_IF;

products_done := (received_count = 6);
stopped := NOT X11 AND NOT X12 AND NOT X13 AND NOT X14 AND NOT X1B AND NOT X1C AND (transfer_state = 0) AND (inspect_state = 0);

IF products_done AND D0 > 0 AND D4 > 0 AND stopped THEN
    Y19 := TRUE;
ELSE
    Y19 := FALSE;
END_IF;

END_PROGRAM