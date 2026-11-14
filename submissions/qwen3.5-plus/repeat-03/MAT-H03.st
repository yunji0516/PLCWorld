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

    (* Edge detection triggers *)
    edge_start : R_TRIG;
    edge_source_ready : R_TRIG;
    edge_move_busy : R_TRIG;
    edge_load_busy : R_TRIG;
    edge_unload_busy : R_TRIG;
    edge_inspect_busy : R_TRIG;
    edge_exit_clear : R_TRIG;
    edge_exit_received : R_TRIG;

    (* Inspection timer *)
    inspect_timer : TON;

    (* Completion timer *)
    complete_timer : TON;

    (* Jig state tracking *)
    jig101_state : INT; (* 0=idle/pos4, 1=pos0_wload, 2=loading, 3=loading_done, 4=move1, 5=pos1_inspect, 6=inspecting, 7=done_inspect, 8=move2, 9=pos2_extract, 10=wait_extract, 11=detaching, 12=wait_unload, 13=move3, 14=move4, 15=lowering, 16=returning *)
    jig102_state : INT;

    (* Jig positions for output *)
    current_jig_id : INT;
    current_target : INT;

    (* Product tracking *)
    total_products : INT;
    products_per_jig : ARRAY[0..1] OF INT;

    (* Completion *)
    complete_active : BOOL;

    (* Cycle phase tracking *)
    phase_load : INT; (* which jig should be loaded next: 101 or 102 *)
    cycle_step : INT;
END_VAR

(* Initialize edge triggers *)
edge_start(CLK := X0);
edge_source_ready(CLK := X10);
edge_move_busy(CLK := X11);
edge_load_busy(CLK := X12);
edge_unload_busy(CLK := X13);
edge_inspect_busy(CLK := X14);
edge_exit_clear(CLK := X15);
edge_exit_received(CLK := X16);

(* Initialize completion timer *)
complete_timer(IN := FALSE, PT := T#500ms);

(* Reset outputs *)
Y10 := FALSE; (* admit *)
Y11 := FALSE; (* inspect *)
Y12 := FALSE; (* detach *)
Y13 := FALSE; (* move *)
Y14 := FALSE; (* left_up *)
Y15 := FALSE; (* left_down *)
Y16 := FALSE; (* right_up *)
Y17 := FALSE; (* right_down *)
Y18 := FALSE; (* ack_exit *)
Y19 := FALSE; (* complete *)

(* Default data outputs *)
D200 := 0;
D201 := 0;
D202 := 0;

(* Initialize from first scan *)
IF cycle_step = 0 THEN
    cycle_step := 1;
    jig101_state := 1; (* pos0 waiting for load *)
    jig102_state := 0; (* pos4 lower center - needs to move up first *)
    phase_load := 101;
    total_products := 0;
    products_per_jig[0] := 0;
    products_per_jig[1] := 0;
    complete_active := FALSE;
END_IF;

(* ============================================================ *)
(* Handle exit reception confirmation *)
(* ============================================================ *)
IF X16 = TRUE AND X18 = FALSE THEN
    (* Check if this is a new reception (received changed) *)
    IF edge_exit_received.Q THEN
        Y18 := TRUE; (* ack_exit pulse *)
    END_IF;
END_IF;

(* ============================================================ *)
(* Jig 101 State Machine *)
(* ============================================================ *)
CASE jig101_state OF
    0: (* Idle / at position 4 - lower center *)
        (* Wait for turn to be loaded *)
        IF phase_load = 101 AND X10 = TRUE AND NOT X11 THEN
            jig101_state := 1;
        END_IF;

    1: (* At position 0 - left lift upper, waiting for load *)
        IF X10 = TRUE AND phase_load = 101 THEN
            Y10 := TRUE; (* admit *)
            jig101_state := 2;
        END_IF;

    2: (* Loading in progress - wait for load_busy pulse *)
        Y10 := FALSE;
        IF edge_load_busy.Q OR X12 THEN
            jig101_state := 3;
        END_IF;

    3: (* Load done - ready to move to inspection (position 1) *)
        IF NOT X11 THEN
            current_jig_id := 101;
            current_target := 1;
            D200 := 101;
            D201 := 1;
            Y13 := TRUE; (* move *)
            jig101_state := 4;
        END_IF;

    4: (* Moving to inspection position 1 *)
        Y13 := FALSE;
        IF X11 = FALSE AND X19 = TRUE THEN
            (* Arrived at upper position 1 *)
            jig101_state := 5;
        END_IF;

    5: (* At position 1 - inspection, waiting to inspect *)
        IF D6 <> 0 THEN
            (* Product present at inspection *)
            Y11 := TRUE; (* inspect *)
            D202 := D8; (* current generation *)
            inspect_timer(IN := TRUE, PT := T#7000ms);
            jig101_state := 6;
        END_IF;

    6: (* Inspecting *)
        Y11 := FALSE;
        inspect_timer(IN := TRUE, PT := T#7000ms);
        IF inspect_timer.Q OR X14 = FALSE THEN
            inspect_timer(IN := FALSE, PT := T#7000ms);
            jig101_state := 7;
        END_IF;

    7: (* Inspection done - move to extraction (position 2) *)
        IF NOT X11 THEN
            current_jig_id := 101;
            current_target := 2;
            D200 := 101;
            D201 := 2;
            Y13 := TRUE; (* move *)
            jig101_state := 8;
        END_IF;

    8: (* Moving to extraction position 2 *)
        Y13 := FALSE;
        IF X11 = FALSE AND X19 = TRUE THEN
            jig101_state := 9;
        END_IF;

    9: (* At position 2 - extraction position *)
        (* Wait for exit_clear AND inspection complete *)
        IF X15 = TRUE AND D9 <> 0 THEN
            (* Product inspection result available and exit clear *)
            jig101_state := 10;
        END_IF;

    10: (* Ready to detach - wait for actual pickup contact *)
        Y12 := TRUE; (* detach *)
        jig101_state := 11;

    11: (* Detaching product *)
        Y12 := FALSE;
        IF edge_unload_busy.Q OR X13 THEN
            (* Product pickup engaged *)
            jig101_state := 12;
        END_IF;

    12: (* Waiting for unload_busy to clear (pickup head return) *)
        IF X13 = FALSE THEN
            (* Unload complete - move jig to position 3 (right lift) *)
            IF NOT X11 THEN
                current_jig_id := 101;
                current_target := 3;
                D200 := 101;
                D201 := 3;
                Y13 := TRUE;
                jig101_state := 13;
            END_IF;
        END_IF;

    13: (* Moving to position 3 - right lift *)
        Y13 := FALSE;
        IF X11 = FALSE AND X19 = TRUE AND X1D = TRUE THEN
            jig101_state := 14;
        END_IF;

    14: (* At position 3 - lower the lift *)
        Y17 := TRUE; (* right_down *)
        jig101_state := 15;

    15: (* Lowering - wait for right_lower *)
        Y17 := FALSE;
        IF X1A = TRUE THEN
            jig101_state := 16;
        END_IF;

    16: (* Jig 101 at lower center position 4 - cycle complete for this jig *)
        (* Update product count *)
        IF D9 <> 0 THEN
            products_per_jig[0] := products_per_jig[0] + 1;
            total_products := total_products + 1;
        END_IF;
        (* Switch phase to other jig or repeat *)
        IF products_per_jig[0] < 3 THEN
            phase_load := 101;
        ELSE
            phase_load := 102;
        END_IF;
        jig101_state := 0;

END_CASE;

(* ============================================================ *)
(* Jig 102 State Machine *)
(* ============================================================ *)
CASE jig102_state OF
    0: (* At position 4 - lower center, needs to move up *)
        (* First move jig 102 to position 0 via right lift *)
        IF NOT X11 AND X1A = TRUE THEN
            (* Move to position 3 (right lift) first, then to position 0 *)
            current_jig_id := 102;
            current_target := 3;
            D200 := 102;
            D201 := 3;
            Y13 := TRUE;
            jig102_state := 17;
        END_IF;

    17: (* Moving to position 3 - right lift *)
        Y13 := FALSE;
        IF X11 = FALSE AND X1A = TRUE THEN
            jig102_state := 18;
        END_IF;

    18: (* Raise right lift *)
        Y16 := TRUE; (* right_up *)
        jig102_state := 19;

    19: (* Wait for right_upper *)
        Y16 := FALSE;
        IF X19 = TRUE THEN
            (* Now move to position 0 (left lift) *)
            jig102_state := 20;
        END_IF;

    20: (* Moving to position 0 *)
        IF NOT X11 THEN
            current_jig_id := 102;
            current_target := 0;
            D200 := 102;
            D201 := 0;
            Y13 := TRUE;
            jig102_state := 21;
        END_IF;

    21: (* Arrived at position 0 - left lift *)
        Y13 := FALSE;
        IF X11 = FALSE AND X1F = TRUE THEN
            jig102_state := 22;
        END_IF;

    22: (* At position 0 - waiting for load *)
        IF X10 = TRUE AND phase_load = 102 THEN
            Y10 := TRUE;
            jig102_state := 23;
        END_IF;

    23: (* Loading *)
        Y10 := FALSE;
        IF edge_load_busy.Q OR X12 THEN
            jig102_state := 24;
        END_IF;

    24: (* Load done - move to inspection *)
        IF NOT X11 THEN
            current_jig_id := 102;
            current_target := 1;
            D200 := 102;
            D201 := 1;
            Y13 := TRUE;
            jig102_state := 25;
        END_IF;

    25: (* Moving to inspection *)
        Y13 := FALSE;
        IF X11 = FALSE AND X19 = TRUE THEN
            jig102_state := 26;
        END_IF;

    26: (* At position 1 - inspect *)
        IF D6 <> 0 THEN
            Y11 := TRUE;
            D202 := D8;
            inspect_timer(IN := TRUE, PT := T#7000ms);
            jig102_state := 27;
        END_IF;

    27: (* Inspecting *)
        Y11 := FALSE;
        inspect_timer(IN := TRUE, PT := T#7000ms);
        IF inspect_timer.Q OR X14 = FALSE THEN
            inspect_timer(IN := FALSE, PT := T#7000ms);
            jig102_state := 28;
        END_IF;

    28: (* Move to extraction *)
        IF NOT X11 THEN
            current_jig_id := 102;
            current_target := 2;
            D200 := 102;
            D201 := 2;
            Y13 := TRUE;
            jig102_state := 29;
        END_IF;

    29: (* Moving to extraction *)
        Y13 := FALSE;
        IF X11 = FALSE AND X19 = TRUE THEN
            jig102_state := 30;
        END_IF;

    30: (* At extraction position *)
        IF X15 = TRUE AND D9 <> 0 THEN
            jig102_state := 31;
        END_IF;

    31: (* Detach *)
        Y12 := TRUE;
        jig102_state := 32;

    32: (* Waiting for unload *)
        Y12 := FALSE;
        IF edge_unload_busy.Q OR X13 THEN
            jig102_state := 33;
        END_IF;

    33: (* Wait unload complete, then move to right lift *)
        IF X13 = FALSE THEN
            IF NOT X11 THEN
                current_jig_id := 102;
                current_target := 3;
                D200 := 102;
                D201 := 3;
                Y13 := TRUE;
                jig102_state := 34;
            END_IF;
        END_IF;

    34: (* Moving to right lift *)
        Y13 := FALSE;
        IF X11 = FALSE AND X1A = TRUE THEN
            jig102_state := 35;
        END_IF;

    35: (* Lower right lift *)
        Y17 := TRUE;
        jig102_state := 36;

    36: (* Wait lower complete *)
        Y17 := FALSE;
        IF X1A = TRUE THEN
            jig102_state := 37;
        END_IF;

    37: (* Jig 102 at lower center - cycle complete *)
        IF D9 <> 0 THEN
            products_per_jig[1] := products_per_jig[1] + 1;
            total_products := total_products + 1;
        END_IF;
        IF products_per_jig[1] < 3 THEN
            phase_load := 102;
        ELSE
            phase_load := 101;
        END_IF;
        jig102_state := 0;

END_CASE;

(* ============================================================ *)
(* Position 4 -> Position 0 transition for jigs returning *)
(* ============================================================ *)
(* When a jig is at position 4 (lower center) and needs to go to position 0, *)
(* it first needs to be moved to position 3 (right lift), raised, then transferred *)
(* to position 0, then left lift raised. *)

(* ============================================================ *)
(* Completion check *)
(* ============================================================ *)
IF total_products >= 6 AND jig101_state = 0 AND jig102_state = 0 THEN
    IF NOT complete_active THEN
        complete_timer(IN := TRUE, PT := T#500ms);
        IF complete_timer.Q THEN
            complete_active := TRUE;
        END_IF;
    END_IF;
    IF complete_active THEN
        Y19 := TRUE;
        (* Check all systems stopped *)
        IF X11 = FALSE AND X12 = FALSE AND X13 = FALSE AND X14 = FALSE AND X1B = FALSE AND X1C = FALSE THEN
            (* All done *)
        END_IF;
    END_IF;
ELSE
    complete_timer(IN := FALSE, PT := T#500ms);
    complete_active := FALSE;
END_IF;

(* Safety: Ensure no move while busy *)
IF X11 = TRUE THEN
    Y13 := FALSE;
END_IF;

(* Safety: Lift controls only when fully supported *)
(* left_up/down only when left_fully or no jig *)
(* right_up/down only when right_fully or no jig *)

(* Ack exit pulse management *)
IF NOT X16 THEN
    Y18 := FALSE;
END_IF;

END_PROGRAM