type operation =
    | ADD
    | SUB
    | MUL
    | DIV
    | SQUARE
    | LN
    | SIN
    | COS
    | SQRT
    | POW


val calculate : float -> float -> operation -> float