```iec
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
    Y10 : BOOL;
    Y11 : BOOL;
    Y12 : BOOL;
    Y13 : BOOL;
    Y14 : BOOL;
    Y15 : BOOL;
    Y16 : BOOL;
    Y17 : BOOL;
    Y18 : BOOL;
    D0 : INT;
    D1 : INT;
    D2 : INT;
    D3 : INT;
    D4 : INT;
    D5 : INT;
    D6 : INT;
    D7 : INT;
    D200 : INT;
    D201 : INT;
    D202 : INT;
    D203 : INT;
    D204 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;

    pre_measured : BOOL := FALSE;
    post_measured : BOOL := FALSE;
    pre_mass_value : INT := 0;
    post_mass_value : INT := 0;
    pre_seq_value : INT := -1;
    post_seq_value : INT := -1;
    net_mass : INT := 0;
    measure_ready : BOOL := FALSE;
    dispatch_ready : BOOL := FALSE;
    complete_flag : BOOL := FALSE;
    current_route : INT := 0;
END_VAR

(* Control Logic *)

(* Starting logic and initial conditions *)
IF X0 THEN
    Y10 := NOT X11 AND NOT Y11 AND NOT Y12 AND X10; (* Feed logic *)
    Y17 := X11 AND NOT X12 AND NOT X1E; (* Pre-lift condition when tray is present and not occupied *)

    (* Pre-measuring logic *)
    IF X11 AND NOT X12 AND NOT X15 AND X1F AND NOT pre_measured THEN
        Y11 := TRUE; (* Activate measure_pre *)
        D202 := D4 + 1; (* Update pre_seq *)
        measure_ready := TRUE;
    ELSE
        Y11 := FALSE;
    END_IF

    (* Handle measurement response for pre_mass *)
    IF not X12 AND D4 = pre_seq_value THEN
        pre_mass_value := D2; (* Store the measured pre_mass *)
        pre_measured := TRUE;
    END_IF

    (* Transfer trays to lane *)
    IF pre_measured AND NOT Y12 THEN
        IF X17 THEN
            D200 := 1;
            Y12 := TRUE;
        ELSIF X19 THEN
            D200 := 2;
            Y12 := TRUE;
        ELSE
            Y12 := FALSE;
        END_IF
    ELSE
        Y12 := FALSE;
    END_IF

    (* Post-lift Logic for completed tray to post scale *)
    IF X20 AND NOT X14 AND NOT X16 THEN
        Y18 := TRUE;
        measure_ready := TRUE;
    ELSE
        Y18 := FALSE;
    END_IF

    (* Request for post measurement if a tray is on post scale *)
    IF X13 AND NOT X16 AND measure_ready AND NOT post_measured THEN
        Y14 := TRUE;
        D203 := D5 + 1;
        measure_ready := FALSE;
    ELSE
        Y14 := FALSE;
    END_IF

    (* Handle measurement response for post_mass *)
    IF not X14 AND D5 = post_seq_value THEN
        post_mass_value := D3;
        post_measured := TRUE;
    END_IF

    (* Calculate net mass and determine route decision *)
    IF pre_measured AND post_measured THEN
        net_mass := post_mass_value - pre_mass_value;
        IF net_mass >= 95 AND net_mass <= 105 THEN
            current_route := 1;
        ELSE
            current_route := 2;
        END_IF

        (* Dispatch logic based on current_route and exits availability *)
        IF current_route = 1 THEN
            IF X1B THEN
                Y15 := TRUE;
                D204 := 1;
                dispatch_ready := TRUE;
            ELSE
                Y15 := FALSE;
            END_IF
        ELSE
            IF X1C THEN
                Y15 := TRUE;
                D204 := 2;
                dispatch_ready := TRUE;
            ELSE
                Y15 := FALSE;
            END_IF
        END_IF

        (* Reset after dispatch *)
        IF dispatch_ready THEN
            pre_measured := FALSE;
            post_measured := FALSE;
            dispatch_ready := FALSE;
        END_IF
    END_IF

    (* Completion flag logic *)
    complete_flag := X1D AND NOT X12 AND NOT X14 AND NOT X18 AND NOT X1A AND X1F;
    Y16 := complete_flag;

END_IF

END_PROGRAM
```