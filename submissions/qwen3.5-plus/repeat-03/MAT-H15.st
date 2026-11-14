```st
PROGRAM Main
VAR
    X0, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19 : BOOL;
    X20, X21, X22, X23, X24, X25, X26, X27, X28, X29 : BOOL;
    Y10, Y11, Y12, Y13, Y14, Y15, Y16, Y17, Y18, Y19 : BOOL;
    D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15 : INT;
    D200, D201, D202, D203, D204 : INT;
    X1A, X1B, X1C, X1D, X1E, X1F : BOOL;
    X2A, X2B, X2C : BOOL;
    Y1A, Y1B, Y1C, Y1D, Y1E, Y1F : BOOL;
    
    current_order : INT := 0;
    sheet_count : INT := 0;
    top_mm : INT := 0;
    state : INT := 0;
    
    prev_r_ready : BOOL := FALSE;
    prev_b_ready : BOOL := FALSE;
    prev_exit_received : BOOL := FALSE;
    prev_pallet_pick : BOOL := FALSE;
    prev_pallet_release : BOOL := FALSE;
    prev_pallet_transfer : BOOL := FALSE;
    prev_pallet_lift : BOOL := FALSE;
    
    kind : INT;
    side : INT;
    bottom : INT;
END_VAR

(* Order sequences: 1=R, 2=B *)
VAR CONSTANT
    A_ORDER : ARRAY[0..2] OF INT := [1, 2, 1];
    B_ORDER : ARRAY[0..3] OF INT := [2, 1, 2, 1];
    
    STATE_INITIAL : INT := 0;
    STATE_ACCEPT_ORDER : INT := 1;
    STATE_PICK : INT := 2;
    STATE_PLACE : INT := 3;
    STATE_PALLET_DELIVER : INT := 4;
    STATE_SUPPORT_LOW : INT := 5;
    STATE_FORK_INSERT : INT := 6;
    STATE_FORK_LIFT : INT := 7;
    STATE_FORK_TRANSFER : INT := 8;
    STATE_FORK_RELEASE : INT := 9;
    STATE_ACK : INT := 10;
    STATE_COMPLETE : INT := 11;
    
    SUPPORT_HOME : INT := 850;
    SUPPORT_LOW : INT := 780;
    BUNDLE_LIFT : INT := 870;
    BUNDLE_RELEASE : INT := 850;
END_CONST

(* Rising edge detection *)
r_ready_edge := (X10 AND NOT prev_r_ready);
b_ready_edge := (X11 AND NOT prev_b_ready);
exit_received_edge := (X19 AND NOT prev_exit_received);
pallet_available_edge := (X27 AND NOT prev_pallet_pick);

prev_r_ready := X10;
prev_b_ready := X11;
prev_exit_received := X19;
prev_pallet_pick := X27;

(* State machine *)
CASE state OF
    0: (* STATE_INITIAL - wait for start *)
        IF X0 THEN
            state := 1;
        END_IF;
    
    1: (* STATE_ACCEPT_ORDER *)
        current_order := 1;
        sheet_count := 0;
        top_mm := 0;
        side := 1;
        kind := A_ORDER[0];
        state := 2;
    
    2: (* STATE_PICK *)
        IF current_order = 1 THEN
            kind := A_ORDER[sheet_count];
        ELSE
            kind := B_ORDER[sheet_count];
        END_IF;
        pick := TRUE;
        state := 3;
    
    3: (* STATE_PLACE *)
        IF NOT X12 THEN
            IF current_order = 1 THEN
                kind := A_ORDER[sheet_count];
            ELSE
                kind := B_ORDER[sheet_count];
            END_IF;
            bottom := top_mm + 30;
            place_mm := bottom;
            place := TRUE;
            state := 4;
        END_IF;
    
    4: (* Wait for placement complete *)
        IF X12 THEN
            place := FALSE;
        END_IF;
        IF NOT X12 AND NOT Y13 THEN
            place_mm := top_mm + 30;
            IF current_order = 1 THEN
                kind := A_ORDER[sheet_count];
            ELSE
                kind := B_ORDER[sheet_count];
            END_IF;
            place := TRUE;
            state := 5;
        END_IF;
    
    5: (* Wait for head free after placement *)
        IF X12 THEN
            pick := FALSE;
            place := FALSE;
            kind := 0;
            state := 6;
        END_IF;
    
    6: (* Update tracking after placement *)
        IF NOT X12 THEN
            IF current_order = 1 THEN
                top_mm := top_mm + 8;
            ELSE
                top_mm := top_mm + 12;
            END_IF;
            sheet_count := sheet_count + 1;
            IF sheet_count >= 3 AND current_order = 1 THEN
                state := 7;
            ELSIF sheet_count >= 4 AND current_order = 2 THEN
                state := 7;
            ELSE
                state := 2;
            END_IF;
        END_IF;
    
    7: (* STATE_PALLET_DELIVER - wait for pallet available *)
        IF pallet_available_edge AND NOT X14 THEN
            state := 8;
        ELSIF pallet_available_edge AND X14 THEN
            state := 8;
        END_IF;
    
    8: (* Initiate pallet pick *)
        IF NOT X14 THEN
            side := current_order;
            pallet_pick := TRUE;
            state := 9;
        ELSE
            state := 8;
        END_IF;
    
    9: (* Wait for empty inserted *)
        pallet_pick := FALSE;
        IF X2A THEN
            pallet_lift := TRUE;
            state := 10;
        END_IF;
    
    10: (* Wait for empty supported *)
        pallet_lift := FALSE;
        IF X2B THEN
            side := current_order;
            pallet_transfer := TRUE;
            state := 11;
        END_IF;
    
    11: (* Wait for empty at station *)
        pallet_transfer := FALSE;
        IF X2C THEN
            pallet_release := TRUE;
            state := 12;
        END_IF;
    
    12: (* Lower pallet and withdraw *)
        pallet_release := FALSE;
        state := 13;
    
    13: (* STATE_SUPPORT_LOW *)
        support_a_mm := SUPPORT_LOW;
        support_b_mm := SUPPORT_LOW;
        state := 14;
    
    14: (* Wait for support low *)
        IF (current_order = 1 AND X23) OR (current_order = 2 AND X24) THEN
            state := 15;
        END_IF;
    
    15: (* STATE_FORK_INSERT *)
        side := current_order;
        fork_insert := TRUE;
        state := 16;
    
    16: (* Wait for fork inserted *)
        fork_insert := FALSE;
        IF X15 THEN
            fork_lift := TRUE;
            state := 17;
        END_IF;
    
    17: (* Wait for fork supporting *)
        fork_lift := FALSE;
        IF X16 THEN
            fork_transfer := TRUE;
            state := 18;
        END_IF;
    
    18: (* Wait for fork at exit *)
        fork_transfer := FALSE;
        IF X17 THEN
            fork_release := TRUE;
            state := 19;
        END_IF;
    
    19: (* Wait for fork home *)
        fork_release := FALSE;
        IF X18 THEN
            state := 20;
        END_IF;
    
    20: (* STATE_ACK - acknowledge receipt *)
        IF exit_received_edge THEN
            ack_exit := TRUE;
            state := 21;
        END_IF;
    
    21: (* Clear ack and check next *)
        ack_exit := FALSE;
        IF current_order = 2 THEN
            state := 22;
        ELSE
            current_order := 2;
            sheet_count := 0;
            top_mm := 0;
            state := 1;
        END_IF;
    
    22: (* STATE_COMPLETE *)
        complete := TRUE;
END_CASE;

(* Set outputs based on state *)
IF state = 1 OR state = 2 OR state = 3 OR state = 4 OR state = 5 OR state = 6 THEN
    accept_a := (current_order = 1);
    accept_b := (current_order = 2);
ELSE
    accept_a := FALSE;
    accept_b := FALSE;
END_IF;

IF state = 1 THEN
    Y10 := (current_order = 1);
    Y11 := (current_order = 2);
ELSIF state = 2 THEN
    kind := A_ORDER[sheet_count];
    pick := TRUE;
ELSIF state = 3 OR state = 4 THEN
    bottom := top_mm + 30;
    place_mm := bottom;
    kind := (IF current_order = 1 THEN A_ORDER[sheet_count] ELSE B_ORDER[sheet_count] END_IF);
ELSIF state = 7 THEN
    support_a_mm := SUPPORT_HOME;
    support_b_mm := SUPPORT_HOME;
ELSIF state = 13 THEN
    support_a_mm := SUPPORT_LOW;
    support_b_mm := SUPPORT_LOW;
ELSIF state = 14 THEN
    support_a_mm := SUPPORT_LOW;
    support_b_mm := SUPPORT_LOW;
END_IF;

D200 := kind;
D201 := side;
D202 := place_mm;
D203 := support_a_mm;
D204 := support_b_mm;

END_PROGRAM
```