type operation = 
  | ADD
  | SUB
  | MUL
  | DIV
  | SQUARE
  | LN
  | LOG
  | SIN
  | COS
  | TAN
  | SQRT
  | POW
  | MOD

let calculate a b op = 
  match op with
  | ADD -> a +. b
  | SUB -> a -. b
  | MUL -> a *. b
  | DIV -> if b = 0.0 then failwith "Division by zero" else a /. b
  | SQUARE -> Float.pow a 2.
  | LN -> Float.log a
  | LOG -> if a < 0.0 || b < 0.0 then failwith "Numbers must be positive" else if b = 1.0 then failwith "Base must be different than 1" else Float.log a /. Float.log b
  | SIN -> Float.sin a
  | COS -> Float.cos a 
  | TAN -> Float.tan a
  | SQRT -> Float.sqrt a 
  | POW -> Float.pow a b 
  | MOD -> if b = 0.0 then failwith "Modulo by 0" else Float.rem a b