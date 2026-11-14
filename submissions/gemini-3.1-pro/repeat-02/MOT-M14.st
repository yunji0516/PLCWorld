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
    Y2 : BOOL;

    state : INT := 0;
    init_done : BOOL := FALSE;
    hold_D10 : DINT := 0;
    hold_D12 : DINT := 0;
    retract_pos : DINT := 0;
    ton_comp : TON;
    slide_cond : BOOL := FALSE;
    terminal_cond : BOOL := FALSE;
END_VAR

IF NOT X10 THEN
    IF state <> 0 OR NOT init_done THEN
        state := 0;
        hold_D10 := D10;
        hold_D12 := D12;
        init_done := TRUE;
    END_IF
    
    Y20 := TRUE;
    Y21 := TRUE;
    D20 := hold_D10;
    D21 := hold_D12;
    Y2 := FALSE;
    ton_comp(IN := FALSE, PT := T#30ms);
ELSE
    Y20 := TRUE;
    Y21 := TRUE;
    
    IF state = 0 THEN
        state := 1;
        hold_D10 := D10;
        
        retract_pos := D12;
        IF 50000 < retract_pos THEN
            retract_pos := 50000;
        END_IF
        IF D16 < retract_pos THEN
            retract_pos := D16;
        END_IF
    END_IF
    
    IF state = 1 THEN
        D21 := retract_pos;
        D20 := hold_D10;
        IF X11 THEN
            state := 2;
        END_IF
    END_IF
    
    IF state = 2 THEN
        D21 := retract_pos;
        D20 := D14;
        IF X12 THEN
            state := 3;
        END_IF
    END_IF
    
    IF state = 3 THEN
        D20 := D14;
        D21 := D15;
        
        slide_cond := (ABS(D12 - D15) <= 20) AND (ABS(D13) <= 100);
        terminal_cond := X12 AND slide_cond;
        
        ton_comp(IN := terminal_cond, PT := T#30ms);
        Y2 := ton_comp.Q;
    ELSE
        ton_comp(IN := FALSE, PT := T#30ms);
        Y2 := FALSE;
    END_IF
END_IF

END_PROGRAM