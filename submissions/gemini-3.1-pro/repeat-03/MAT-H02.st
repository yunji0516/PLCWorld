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
    X22 : BOOL;
    X23 : BOOL;
    X24 : BOOL;
    X25 : BOOL;
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
    Y20 : BOOL;
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
    D13 : INT;
    D14 : INT;
    D15 : INT;
    D16 : INT;
    D200 : INT;
    D201 : INT;
    X1A : BOOL;
    X1B : BOOL;
    X1C : BOOL;
    X1D : BOOL;
    X1E : BOOL;
    X1F : BOOL;
    Y1A : BOOL;
    Y1B : BOOL;
    Y1C : BOOL;
    Y1D : BOOL;
    Y1E : BOOL;
    Y1F : BOOL;

    A_Step : INT := 0;
    B_Step : INT := 0;
    Box_Step : INT := 0;
    Deck_Step : INT := 0;
    
    Target_Storage : INT := 0;
    Target_Kit : INT := 0;
    
    Ack_A_Count : INT := 0;
    Ack_B_Count : INT := 0;
    Box_Dispatched_Count : INT := 0;
    
    Box_Timer : TON;
    Complete_Timer : TON;
END_VAR

Box_Timer(IN:=(Box_Step = 2), PT:=T#300ms);

(* Kit A processing *)
CASE A_Step OF
0:
    Y19 := 0; Y17 := 0; Y15 := 0; Y13 := 0;
    IF X13 AND NOT X15 THEN
        Y13 := 1;
        A_Step := 1;
    END_IF;
1:
    IF X15 THEN
        Y13 := 0;
        A_Step := 2;
    END_IF;
2:
    IF D13 = 2 THEN
        Y15 := 1;
        A_Step := 3;
    END_IF;
3:
    IF X17 THEN
        Y15 := 0;
        A_Step := 4;
    END_IF;
4:
    IF X19 THEN
        Y17 := 1;
        A_Step := 5;
    END_IF;
5:
    IF X1B THEN
        Y17 := 0;
        A_Step := 6;
    END_IF;
6:
    IF X22 THEN
        A_Step := 7;
    END_IF;
7:
    Y19 := 1;
    A_Step := 8;
8:
    IF NOT X15 THEN
        Y19 := 0;
        Ack_A_Count := Ack_A_Count + 1;
        A_Step := 0;
    END_IF;
END_CASE;

(* Kit B processing *)
CASE B_Step OF
0:
    Y1A := 0; Y18 := 0; Y16 := 0; Y14 := 0;
    IF X14 AND NOT X16 THEN
        Y14 := 1;
        B_Step := 1;
    END_IF;
1:
    IF X16 THEN
        Y14 := 0;
        B_Step := 2;
    END_IF;
2:
    IF D14 = 2 THEN
        Y16 := 1;
        B_Step := 3;
    END_IF;
3:
    IF X18 THEN
        Y16 := 0;
        B_Step := 4;
    END_IF;
4:
    IF X1A THEN
        Y18 := 1;
        B_Step := 5;
    END_IF;
5:
    IF X1C THEN
        Y18 := 0;
        B_Step := 6;
    END_IF;
6:
    IF X23 THEN
        B_Step := 7;
    END_IF;
7:
    Y1A := 1;
    B_Step := 8;
8:
    IF NOT X16 THEN
        Y1A := 0;
        Ack_B_Count := Ack_B_Count + 1;
        B_Step := 0;
    END_IF;
END_CASE;

(* Moving deck part processing and transfer *)
CASE Deck_Step OF
0:
    Y10 := 0; Y11 := 0; Y12 := 0;
    IF X15 AND D13 < 2 AND ((D5 > 0 AND D6 = D11) OR (D7 > 0 AND D8 = D11)) THEN
        IF D5 > 0 AND D6 = D11 THEN Target_Storage := 2; ELSE Target_Storage := 3; END_IF;
        Target_Kit := 4;
        D200 := Target_Storage;
        Y10 := 1;
        Deck_Step := 1;
    ELSIF X16 AND D14 < 2 AND ((D5 > 0 AND D6 = D12) OR (D7 > 0 AND D8 = D12)) THEN
        IF D5 > 0 AND D6 = D12 THEN Target_Storage := 2; ELSE Target_Storage := 3; END_IF;
        Target_Kit := 5;
        D200 := Target_Storage;
        Y10 := 1;
        Deck_Step := 1;
    ELSIF X10 THEN
        D200 := 1;
        Y10 := 1;
        Deck_Step := 10;
    END_IF;
1:
    IF D0 = Target_Storage AND NOT X11 THEN
        Y10 := 0;
        Y11 := 1;
        Deck_Step := 2;
    END_IF;
2:
    IF D1 > 0 AND NOT X11 THEN
        Y11 := 0;
        D200 := Target_Kit;
        Y10 := 1;
        Deck_Step := 3;
    END_IF;
3:
    IF D0 = Target_Kit AND NOT X11 THEN
        Y10 := 0;
        IF Target_Kit = 4 THEN D201 := D9; ELSE D201 := D10; END_IF;
        Y12 := 1;
        Deck_Step := 4;
    END_IF;
4:
    IF D1 = 0 AND NOT X11 THEN
        Y12 := 0;
        Deck_Step := 0;
    END_IF;
10:
    IF D0 = 1 AND NOT X11 THEN
        Y10 := 0;
        Y11 := 1;
        Deck_Step := 11;
    END_IF;
11:
    IF D1 > 0 AND NOT X11 THEN
        Y11 := 0;
        IF X15 AND D11 = D2 AND D13 < 2 THEN
            Target_Kit := 4;
            D200 := 4;
            Y10 := 1;
            Deck_Step := 3;
        ELSIF X16 AND D12 = D2 AND D14 < 2 THEN
            Target_Kit := 5;
            D200 := 5;
            Y10 := 1;
            Deck_Step := 3;
        ELSE
            IF D5 = 0 THEN D200 := 2; ELSE D200 := 3; END_IF;
            Y10 := 1;
            Deck_Step := 12;
        END_IF;
    END_IF;
12:
    IF D0 = D200 AND NOT X11 THEN
        Y10 := 0;
        Y12 := 1;
        Deck_Step := 13;
    END_IF;
13:
    IF D1 = 0 AND NOT X11 THEN
        Y12 := 0;
        Deck_Step := 0;
    END_IF;
END_CASE;

(* Box and packing processing *)
CASE Box_Step OF
0:
    Y1C := 0; Y1D := 0; Y1E := 0; Y1F := 0; Y20 := 0;
    IF Box_Dispatched_Count < 2 THEN
        Y1C := 1;
        Box_Step := 1;
    END_IF;
1:
    Y1C := 1;
    IF X1F THEN
        Y1D := 1;
        Box_Step := 2;
    END_IF;
2:
    Y1C := 1;
    Y1D := 1;
    IF Box_Timer.Q AND X20 THEN
        Y1C := 0;
        Box_Step := 3;
    END_IF;
3:
    IF A_Step = 6 AND X1B AND D9 = D16 AND NOT X21 THEN
        Y1E := 1;
        Box_Step := 40;
    ELSIF B_Step = 6 AND X1C AND D10 = D16 AND NOT X21 THEN
        Y1F := 1;
        Box_Step := 50;
    ELSIF X24 THEN 
        Y1D := 0;
        Box_Step := 6;
    END_IF;
40:
    IF X21 THEN 
        Y1E := 0; 
        Box_Step := 41; 
    END_IF;
41:
    IF NOT X21 THEN 
        Box_Step := 3; 
    END_IF;
50:
    IF X21 THEN 
        Y1F := 0; 
        Box_Step := 51; 
    END_IF;
51:
    IF NOT X21 THEN 
        Box_Step := 3; 
    END_IF;
6:
    Y1D := 0;
    IF X25 THEN
        Y20 := 1;
        Box_Step := 7;
    END_IF;
7:
    IF NOT X1F THEN
        Y20 := 0;
        Box_Dispatched_Count := Box_Dispatched_Count + 1;
        Box_Step := 0;
    END_IF;
END_CASE;

Complete_Timer(IN:= (Ack_A_Count = 2 AND Ack_B_Count = 2 AND Box_Dispatched_Count = 2 AND Deck_Step = 0 AND D1 = 0 AND X1D), PT:=T#500ms);
IF Complete_Timer.Q THEN
    Y1B := 1;
END_IF;

END_PROGRAM