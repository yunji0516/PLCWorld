PROGRAM Main
VAR
    edge_start : R_TRIG;
    edge_a_done : R_TRIG;
    edge_b_done : R_TRIG;
    edge_return_ready : R_TRIG;
    
    start_a_cmd : BOOL;
    start_b_cmd : BOOL;
    eject_a_cmd : BOOL;
    eject_b_cmd : BOOL;
    swap_cmd : BOOL;
    take_bin_cmd : BOOL;
    
    edge_start_a : R_TRIG;
    edge_start_b : R_TRIG;
    edge_eject_a : R_TRIG;
    edge_eject_b : R_TRIG;
    edge_swap : R_TRIG;
    edge_take_bin : R_TRIG;
    
    timer_bin_off : TON;
    timer_complete : TON;
    
    state : INT;
    complete_flag : BOOL;
    
END_VAR

edge_start(CLK := X0);
edge_a_done(CLK := X1A);
edge_b_done(CLK := X20);
edge_return_ready(CLK := X13);

edge_start_a(CLK := start_a_cmd);
edge_start_b(CLK := start_b_cmd);
edge_eject_a(CLK := eject_a_cmd);
edge_eject_b(CLK := eject_b_cmd);
edge_swap(CLK := swap_cmd);
edge_take_bin(CLK := take_bin_cmd);

CASE state OF
    0:
        IF edge_start.Q THEN
            state := 1;
        END_IF;
        
    1:
        IF D5 = 0 AND NOT X19 AND D0 + D1 + 3 <= 6 AND X16 AND X10 THEN
            state := 2;
        END_IF;
        
    2:
        IF NOT X18 AND X17 THEN
            state := 3;
        END_IF;
        
    3:
        start_a_cmd := TRUE;
        state := 4;
        
    4:
        IF edge_a_done.Q THEN
            state := 5;
        END_IF;
        
    5:
        IF X1B THEN
            eject_a_cmd := TRUE;
            state := 6;
        END_IF;
        
    6:
        IF D7 = 0 AND NOT X1F AND D0 + D1 + 2 <= 6 AND X1C AND X10 THEN
            state := 7;
        END_IF;
        
    7:
        IF NOT X1E AND X1D THEN
            state := 8;
        END_IF;
        
    8:
        start_b_cmd := TRUE;
        state := 9;
        
    9:
        IF edge_b_done.Q THEN
            state := 10;
        END_IF;
        
    10:
        IF X21 THEN
            eject_b_cmd := TRUE;
            state := 11;
        END_IF;
        
    11:
        IF D0 + D1 + 3 > 6 THEN
            IF D1 = 0 AND D0 > 0 AND X12 AND NOT X14 THEN
                swap_cmd := TRUE;
                state := 12;
            END_IF;
        ELSE
            state := 14;
        END_IF;
        
    12:
        timer_bin_off(IN := NOT X10, PT := T#3s);
        IF timer_bin_off.Q OR X10 THEN
            state := 13;
        END_IF;
        
    13:
        IF X13 THEN
            take_bin_cmd := TRUE;
            state := 14;
        END_IF;
        
    14:
        IF D5 = 0 AND NOT X19 AND D0 + D1 + 3 <= 6 AND X16 AND X10 THEN
            state := 15;
        END_IF;
        
    15:
        IF NOT X18 AND X17 THEN
            state := 16;
        END_IF;
        
    16:
        start_a_cmd := TRUE;
        state := 17;
        
    17:
        IF edge_a_done.Q THEN
            state := 18;
        END_IF;
        
    18:
        IF X1B THEN
            eject_a_cmd := TRUE;
            state := 19;
        END_IF;
        
    19:
        IF X15 AND D1 = 0 THEN
            state := 20;
        END_IF;
        
    20:
        complete_flag := TRUE;
        timer_complete(IN := TRUE, PT := T#500ms);
END_CASE;

IF state = 2 OR state = 15 THEN
    Y13 := TRUE;
ELSE
    Y13 := FALSE;
END_IF;

IF state = 7 THEN
    Y16 := TRUE;
ELSE
    Y16 := FALSE;
END_IF;

IF edge_start_a.Q THEN start_a_cmd := FALSE; END_IF;
IF edge_start_b.Q THEN start_b_cmd := FALSE; END_IF;
IF edge_eject_a.Q THEN eject_a_cmd := FALSE; END_IF;
IF edge_eject_b.Q THEN eject_b_cmd := FALSE; END_IF;
IF edge_swap.Q THEN swap_cmd := FALSE; END_IF;
IF edge_take_bin.Q THEN take_bin_cmd := FALSE; END_IF;

Y14 := edge_start_a.Q;
Y17 := edge_start_b.Q;
Y15 := edge_eject_a.Q;
Y18 := edge_eject_b.Q;
Y10 := edge_swap.Q;
Y11 := edge_take_bin.Q;
Y12 := complete_flag;

END_PROGRAM