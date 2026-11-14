PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL; // Completion claim
    Y20 : BOOL; // Pump actuator command
    D20 : INT; // Physical observation of outlet
    D21 : INT; // Physical observation of source

    (* Internal variables *)
    start_triggered : BOOL := FALSE;
    old_material_remaining : INT;
    new_material_reached : BOOL := FALSE;
    extra_new_material : REAL := 0.0;

    new_material_volume_at_outlet : INT := 0;
    previous_source_volume : INT := 0;
    pump_active : BOOL := FALSE;

    edge_detector : R_TRIG;
END_VAR

(* Implement the control logic here. *)
edge_detector(CLK := X10);
IF edge_detector.Q THEN
    start_triggered := TRUE;
    pump_active := TRUE;
    previous_source_volume := D21;
END_IF

IF start_triggered THEN
    IF pump_active THEN
        (* Calculate the old material remaining *)
        IF D21 < previous_source_volume THEN
            old_material_decreased := previous_source_volume - D21;
            old_material_remaining := MAX(old_material_remaining - old_material_decreased, 0);
            previous_source_volume := D21;
        END_IF

        (* Check for new material reaching the outlet *)
        IF D20 = 2 THEN
            new_material_reached := TRUE;
            new_material_volume_at_outlet := new_material_volume_at_outlet + 10;
        END_IF

        (* Calculate extra new material recovered *)
        IF new_material_reached AND D20 = 1 THEN
            extra_new_material := extra_new_material + (REAL(10) / REAL(1)); // 10 mL converted to real
        END_IF

        (* Stop pump when conditions are met *)
        IF (old_material_remaining = 0 AND D20 = 2 AND extra_new_material <= 1.0) THEN
            pump_active := FALSE;
            Y20 := FALSE;
            Y2 := TRUE; // Completion claim
        ELSE
            Y20 := TRUE;
        END_IF
    END_IF
END_IF

END_PROGRAM