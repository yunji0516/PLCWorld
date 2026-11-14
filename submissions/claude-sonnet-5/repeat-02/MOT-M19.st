PROGRAM Main
VAR
    X0 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    D13 : DINT;
    D14 : DINT;
    D15 : DINT;
    D16 : DINT;
    D17 : DINT;
    D101 : DINT;
    D102 : DINT;
    D103 : DINT;
    D20 : DINT;
    D21 : DINT;
    Y20 : BOOL;
    D24 : DINT;
    D25 : DINT;
    Y21 : BOOL;
    D28 : DINT;
    D29 : DINT;
    Y22 : BOOL;
    D32 : DINT;
    D33 : DINT;
    Y23 : BOOL;
    Y2 : BOOL;

    (* Internal state *)
    started      : BOOL := FALSE;
    phase        : INT := 0;   (* 0 = move to first, 1 = move to second, 2 = complete/retract *)
    y2_latch     : BOOL := FALSE;

    pos_tol      : DINT := 20;    (* 0.2 mm * 100 *)
    speed_tol    : DINT := 100;   (* 1 mm/s * 100 *)
    eng_min      : DINT := 6000;  (* 60 mm * 100 *)
    eng_max      : DINT := 7500;  (* 75 mm * 100 *)
    b_target_val : DINT := 7000;  (* 70 mm * 100 *)

    arrived_a_first  : BOOL;
    arrived_a_second : BOOL;
    arrived_b70      : BOOL;
    arrived_c0       : BOOL;
    arrived_d_lane   : BOOL;

    engagement_ok     : BOOL;
    work_position_ok  : BOOL;
    lane_ok           : BOOL;
END_VAR

(* Latch start request; Enable outputs are only ever driven after X0 has been seen *)
IF X0 THEN
    started := TRUE;
END_IF;

Y20 := started;
Y21 := started;
Y22 := started;
Y23 := started;

(* Default rates: run at full commanded rate whenever the axis is enabled *)
D21 := 1000;
D25 := 1000;
D29 := 1000;
D33 := 1000;

(* Arrival evaluation (position + speed tolerance) *)
arrived_a_first  := (ABS(D10 - D101) <= pos_tol) AND (ABS(D11) <= speed_tol);
arrived_a_second := (ABS(D10 - D102) <= pos_tol) AND (ABS(D11) <= speed_tol);
arrived_b70      := (ABS(D12 - b_target_val) <= pos_tol) AND (ABS(D13) <= speed_tol);
arrived_c0       := (ABS(D14) <= pos_tol) AND (ABS(D15) <= speed_tol);
arrived_d_lane   := (ABS(D16 - D103) <= pos_tol) AND (ABS(D17) <= speed_tol);

(* Continuous validity conditions (no speed requirement, pure holding state) *)
engagement_ok    := (D12 >= eng_min) AND (D12 <= eng_max);
work_position_ok := (ABS(D14) <= pos_tol);
lane_ok          := (ABS(D16 - D103) <= pos_tol);

CASE phase OF
    0:
        (* Prepare/base state: bring C to work position, D to requested lane,
           and start the section by stopping A at first / B at 70. *)
        D20 := D101;
        D24 := b_target_val;
        D28 := 0;
        D32 := D103;

        IF arrived_a_first AND arrived_b70 AND arrived_c0 AND arrived_d_lane THEN
            phase := 1;
        END_IF;

    1:
        (* Move A to second while holding B/C/D. Any loss of engagement,
           work position, or lane alignment invalidates progress -> restart at first. *)
        D20 := D102;
        D24 := b_target_val;
        D28 := 0;
        D32 := D103;

        IF (NOT engagement_ok) OR (NOT work_position_ok) OR (NOT lane_ok) THEN
            phase := 0;
        ELSIF arrived_a_second AND engagement_ok AND work_position_ok AND lane_ok THEN
            phase := 2;
            y2_latch := TRUE;
        END_IF;

    2:
        (* Completed: retract B and return C/A/D to standby positions.
           Completion output remains asserted and is never cleared. *)
        D20 := 6000;   (* A = 60 mm *)
        D24 := 0;      (* B retracted *)
        D28 := 8000;   (* C = 80 mm *)
        D32 := 0;      (* D = 0 *)

END_CASE;

Y2 := y2_latch;

END_PROGRAM