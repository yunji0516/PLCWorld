PROGRAM Main
VAR
    X0 : BOOL; (* start *)
    X10 : BOOL; (* feed_home *)
    X11 : BOOL; (* feed_stopped *)
    X12 : BOOL; (* gripped *)
    X13 : BOOL; (* grip_open *)
    X14 : BOOL; (* stock_clamped *)
    X15 : BOOL; (* blade_up *)
    X16 : BOOL; (* blade_down *)
    X17 : BOOL; (* cut_complete *)
    X18 : BOOL; (* pad_up *)
    X19 : BOOL; (* pad_down *)
    X1A : BOOL; (* pad_source *)
    X1B : BOOL; (* pad_receiver *)
    X1C : BOOL; (* pad_held *)
    X1D : BOOL; (* receiver_present *)
    Y10 : BOOL; (* feed_grip *)
    Y11 : BOOL; (* stock_clamp *)
    Y12 : BOOL; (* feed_move *)
    Y13 : BOOL; (* blade_down *)
    Y14 : BOOL; (* pad_down *)
    Y15 : BOOL; (* pad_out *)
    Y16 : BOOL; (* vacuum *)
    Y17 : BOOL; (* complete *)
    D0 : INT; (* requested_mm *)
    D1 : INT; (* feed_mm *)
    D2 : INT; (* stock_edge_mm *)
    D3 : INT; (* received_mm *)
    D200 : INT; (* feed_target *)
    
    state : INT := 0;
    edge_start : R_TRIG;
    edge_cut_complete : R_TRIG;
    cutting_timer : TON;
    pad_timer : TON;
END_VAR

edge_start(CLK := X0);
edge_cut_complete(CLK := X17);

CASE state OF
    0: (* Waiting for start signal *)
        IF edge_start.Q THEN
            Y11 := TRUE; (* Close stock clamp *)
            D200 := D0 + 100; (* Set feed target *)
            state := 1;
        END_IF
    
    1: (* Material clamping and feeding *)
        IF X14 THEN (* Stock clamped *)
            Y10 := TRUE; (* Close feed grip *)
            state := 2;
        END_IF
        
    2:
        IF X12 THEN (* Feed grip closed *)
            Y12 := TRUE; (* Move feed carriage *)
            state := 3;
        END_IF

    3: (* Moving feed carriage *)
        IF X11 AND (D1 = D200) THEN (* Feed stopped at target position *)
            Y12 := FALSE; (* Stop feed carriage *)
            Y11 := FALSE; (* Open stock clamp *)
            state := 4;
        END_IF

    4: (* Cutting operation *)
        Y13 := TRUE; (* Lower blade to cut *)
        cutting_timer(IN := NOT X17, PT := T#650ms);
        IF cutting_timer.Q THEN
            Y13 := FALSE; (* Return blade to top *)
            state := 5;
        END_IF
        
    5: (* Wait for cut complete *)
        IF X15 AND edge_cut_complete.Q THEN
            state := 6;
        END_IF

    6: (* Prepare pad for receiving *)
        IF X15 THEN (* Ensure blade is up *)
            Y14 := TRUE; (* Lower pad *)
            Y15 := TRUE; (* Move pad out *)
            pad_timer(IN := X19, PT := T#500ms);
            IF X1B THEN (* Pad at receiver position *)
                Y16 := TRUE; (* Activate vacuum *)
                state := 7;
            END_IF
        END_IF

    7: (* Transfer completed and return *)
        IF pad_timer.Q AND X1C THEN (* Pad held and vacuum formed *)
            Y16 := FALSE; (* Vacuum off *)
            Y10 := FALSE; (* Open feed grip *)
            IF NOT X1C THEN
                Y14 := FALSE; (* Raise pad *)
                Y15 := FALSE; (* Move pad in *)
                state := 8;
            END_IF
        END_IF

    8: (* Reset to initial condition *)
        IF X18 AND X10 THEN (* Pad up and feed home *)
            Y17 := TRUE; (* Task complete *)
            IF X0 = FALSE THEN
                Y17 := FALSE; (* Disable complete on next start signal *)
                state := 0;
            END_IF
        END_IF
END_CASE

END_PROGRAM