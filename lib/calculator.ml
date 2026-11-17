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

let calculate a b op = 
  match op with
  | ADD -> a +. b
  | SUB -> a -. b
  | MUL -> a *. b
  | DIV -> if b = 0.0 then failwith "Division by zero" else a /. b
  | SQUARE -> Float.pow a 2.
  | LN -> Float.log a
  | SIN -> Float.sin a
  | COS -> Float.cos a 
  | SQRT -> Float.sqrt a 
  | POW -> Float.pow a b 