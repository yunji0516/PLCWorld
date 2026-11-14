PROGRAM Main
VAR
    // Inputs
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
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    // Outputs
    Y10 : BOOL := FALSE;
    Y11 : BOOL := FALSE;
    Y12 : BOOL := FALSE;
    Y13 : BOOL := FALSE;
    Y14 : BOOL := FALSE;
    Y15 : BOOL := FALSE;
    Y16 : BOOL := FALSE;
    Y17 : BOOL := FALSE;
    Y18 : BOOL := FALSE;
    Y19 : BOOL := FALSE;
    Y1A : BOOL := FALSE;
    Y1B : BOOL := FALSE;
    Y1C : BOOL := FALSE;
    Y1D : BOOL := FALSE;
    Y1E : BOOL := FALSE;

    // Data addresses
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT := 0;

    // Internal variables
    processing_stage : INT := 0;
    align_timer : TON;
    complete_timer : TON;
    separator_r_trig : R_TRIG;
    accept_pouch_r_trig : R_TRIG;
    content_select_done : BOOL := FALSE;
    all_packages_received : BOOL := FALSE;
END_VAR

(* Implement the control logic here. *)
separator_r_trig(CLK := X20);
accept_pouch_r_trig(CLK := X11);

CASE processing_stage OF
    0: (* Wait for start signal *)
        IF X0 THEN
            processing_stage := 1;
        END_IF;
        
    1: (* Separate the pouches *)
        IF X20 AND NOT X12 AND NOT X21 AND NOT X23 THEN
            Y1B := TRUE; // Engage separator_hold
            processing_stage := 2;
        END_IF;
        
    2: (* Wait for single sheet detection *)
        IF separator_r_trig.Q AND X23 THEN
            Y1B := FALSE; // Disengage separator_hold
            Y1C := TRUE;  // Trigger separation of double sheet
            processing_stage := 3;
        END_IF;
        
    3: (* Accepting pouch when ready *)
        IF X10 AND NOT X11 AND NOT X12 THEN
            IF accept_pouch_r_trig.Q THEN
                Y10 := TRUE; // Trigger accept_pouch
                processing_stage := 4;
            END_IF;
        END_IF;
        
    4: (* Check insertion and docking position *)
        IF X13 AND X19 AND X1A AND X1B AND D5 > 4 THEN
            Y12 := TRUE; // Activate vacuum_left
            Y13 := TRUE; // Activate vacuum_right
            Y14 := TRUE; // Open
            Y15 := TRUE; // Transfer pouch
            processing_stage := 5;
        END_IF;
        
    5: (* Align content and prepare content selection *)
        IF X24 AND X25 THEN
            Y1D := TRUE; // Align side
            Y1E := TRUE; // Align front
            Y11 := TRUE; // Accept content
            align_timer(IN := TRUE, PT := T#350ms);
            processing_stage := 6;
        END_IF;

    6: (* Insert content when aligned and open *)
        IF align_timer.Q THEN
            IF X13 AND NOT X16 THEN
                IF NOT content_select_done THEN
                    CASE D3 OF
                        1: D200 := 1;
                        2: D200 := 2;
                        3: D200 := 3;
                        4: D200 := 4;
                        ELSE
                            D200 := 0;
                    END_CASE;
                    content_select_done := TRUE;
                END_IF;
                Y16 := TRUE; // Start insert
                processing_stage := 7;
            END_IF;
        END_IF;

    7: (* Retract to origin and release *)
        IF X17 THEN
            Y17 := TRUE; // Retract pusher
            Y18 := TRUE; // Release after content is contained
            IF X19 THEN
                Y19 := TRUE; // Acknowledge exit
                processing_stage := 8;
            END_IF;
        END_IF;
        
    8: (* Check final conditions for completion *)
        IF X1D AND X1E AND X1F THEN
            all_packages_received := TRUE;
            complete_timer(IN := all_packages_received, PT := T#500ms);
            IF complete_timer.Q THEN
                Y1A := TRUE; // Assert complete
            END_IF;
        END_IF;
END_CASE;

END_PROGRAM