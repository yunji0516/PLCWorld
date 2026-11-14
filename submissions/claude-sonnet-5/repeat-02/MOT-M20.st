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
    Y22 : BOOL;
    Y2 : BOOL;

    (* internal state *)
    state        : INT := 0;
    req_edge     : R_TRIG;
    x11_edge     : R_TRIG;
    ratio_cmd    : DINT;
    sync_U_ref   : DINT;
    park_target_abs : DINT;
    curmod       : DINT;
    rawpark      : DINT;
    base_pos     : DINT;
    stable_ok    : BOOL;
    settle_timer : TON;
END_VAR

(* Always update edge detectors every scan *)
req_edge(CLK := X10);
x11_edge(CLK := X11);

(* default outputs each scan, overridden below as needed *)
Y20 := FALSE;
Y21 := FALSE;
D20 := 0;

CASE state OF

    0: // IDLE - wait for a new task request
        IF req_edge.Q THEN
            IF (D15 >= 500) AND (D15 <= 2500) THEN
                ratio_cmd := D15;
                D20 := ratio_cmd;
                state := 1;
            END_IF;
        END_IF;

    1: // Issue GearIn (coupling) rising-edge pulse
        Y20 := TRUE;
        D20 := ratio_cmd;
        state := 2;

    2: // Wait for actual synchronization confirmation (InGear)
        D20 := ratio_cmd;
        IF x11_edge.Q THEN
            sync_U_ref := D10;
            state := 3;
        END_IF;

    3: // Synchronized run - accumulate reference-axis rotation, must reach at least Span
        D20 := ratio_cmd;
        IF (D10 - sync_U_ref) >= D14 THEN
            state := 4;
        END_IF;

    4: // Issue GearOut (separation) rising-edge pulse
        Y21 := TRUE;
        D20 := ratio_cmd;
        state := 5;

    5: // Wait for actual physical separation (coupling feedback off)
        D20 := ratio_cmd;
        IF NOT X12 THEN
            curmod := D11 MOD 36000;
            IF curmod < 0 THEN
                curmod := curmod + 36000;
            END_IF;
            rawpark := D13 MOD 36000;
            IF rawpark < 0 THEN
                rawpark := rawpark + 36000;
            END_IF;
            base_pos := D11 - curmod;
            park_target_abs := base_pos + rawpark;
            IF park_target_abs < D11 THEN
                park_target_abs := park_target_abs + 36000;
            END_IF;
            D20 := 0;
            state := 6;
        END_IF;

    6: // Independent positioning to the Park target, then hold and confirm result
        D20 := 0;
        stable_ok := (ABS(D11 - park_target_abs) <= 20) AND (ABS(D12) <= 100);
        settle_timer(IN := stable_ok, PT := T#100ms);
        IF settle_timer.Q THEN
            Y2 := TRUE;
        END_IF;

    ELSE
        state := 0;

END_CASE;

(* Independent position command is only valid after separation is confirmed,
   and must never be asserted while the gear coupling is active. *)
IF (state >= 6) AND (NOT X12) THEN
    Y22 := TRUE;
    D21 := park_target_abs;
ELSE
    Y22 := FALSE;
    D21 := 0;
END_IF;

IF X12 THEN
    Y22 := FALSE;
END_IF;

END_PROGRAM