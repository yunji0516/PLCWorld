PROGRAM Main
VAR
    X10 : BOOL;
    D10 : DINT;
    D11 : DINT;
    D12 : DINT;
    X11 : BOOL;
    Y20 : BOOL;
    D20 : DINT;
    Y2 : BOOL;

    (* Internal variables *)
    req_accepted   : BOOL := FALSE;
    obstacle_latch : BOOL := FALSE;
    active         : BOOL := FALSE;
    y2_latch       : BOOL := FALSE;
    hold_ms        : DINT := 0;
    target         : DINT := 0;
    pos_diff       : DINT := 0;
    spd_abs        : DINT := 0;
    scan_ms        : DINT := 10;
END_VAR

(* Latch request acceptance once X10 is seen *)
IF X10 THEN
    req_accepted := TRUE;
END_IF;

(* Latch obstacle detection; only meaningful once request accepted *)
IF req_accepted AND X11 THEN
    obstacle_latch := TRUE;
END_IF;

(* Activate the reopening function once an obstacle has been latched
   after request acceptance; never deactivate (no closing again) *)
IF req_accepted AND obstacle_latch THEN
    active := TRUE;
END_IF;

Y20 := active;

(* Compute and clamp the commanded open position *)
IF active THEN
    target := D10;
    IF target > 200000 THEN
        target := 200000;
    ELSIF target < -200000 THEN
        target := -200000;
    END_IF;
    D20 := target;
ELSE
    D20 := 0;
END_IF;

(* Track continuous valid result window *)
IF active THEN
    pos_diff := D11 - D20;
    IF pos_diff < 0 THEN
        pos_diff := -pos_diff;
    END_IF;

    spd_abs := D12;
    IF spd_abs < 0 THEN
        spd_abs := -spd_abs;
    END_IF;

    IF (pos_diff <= 20) AND (spd_abs <= 100) THEN
        hold_ms := hold_ms + scan_ms;
    ELSE
        hold_ms := 0;
    END_IF;
ELSE
    hold_ms := 0;
END_IF;

(* Assert completion once held at least 30 ms continuously; keep latched *)
IF (NOT y2_latch) AND (hold_ms >= 30) THEN
    y2_latch := TRUE;
END_IF;

Y2 := y2_latch;

END_PROGRAM