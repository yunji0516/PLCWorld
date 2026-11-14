PROGRAM Main
VAR
    X10 : BOOL;
    D10 : INT;
    Y2 : BOOL;
    Y20 : BOOL;
    X20 : BOOL;

    started : BOOL := FALSE;
    conveyorActive : BOOL := FALSE;
    photoEdgePassed : BOOL := FALSE;
    productPosition : REAL := -250.0; (* Initial product center position in mm *)
END_VAR

(* Implement the control logic here. *)

(* Constants *)
CONST
    PRODUCT_LENGTH : REAL := 180.0; (* mm *)
    PHOTO_SENSOR_POSITION : REAL := 120.0; (* mm *)
    CONVEYOR_SPEED : REAL := 400.0; (* mm/s, arbitrary fixed speed within given range *)
    SCAN_PERIOD : REAL := 0.01; (* 10 ms in seconds *)
END_CONST

(* Main Logic *)
IF NOT started AND (X10 AND D10 = 1) THEN
    started := TRUE;
END_IF

IF started AND NOT conveyorActive THEN
    Y20 := TRUE; (* Start conveyor *)
    conveyorActive := TRUE;
END_IF

IF conveyorActive THEN
    (* Update product position *)
    productPosition := productPosition + (CONVEYOR_SPEED * SCAN_PERIOD);

    (* Check if trailing edge has passed the photoeye position *)
    IF productPosition + (PRODUCT_LENGTH / 2.0) > PHOTO_SENSOR_POSITION THEN
        photoEdgePassed := TRUE;
    END_IF

    (* If the trailing edge has passed the sensor, stop conveyor *)
    IF photoEdgePassed THEN
        Y20 := FALSE; (* Stop conveyor *)
        conveyorActive := FALSE;
        IF productPosition + (PRODUCT_LENGTH / 2.0) <= 450.0 THEN
            Y2 := TRUE; (* Declare completion *)
        END_IF
    END_IF
END_IF

END_PROGRAM