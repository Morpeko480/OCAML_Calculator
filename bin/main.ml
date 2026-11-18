let () =
  let _ = GMain.init () in

  (* Load CSS *)
let css_provider = GtkData.CssProvider.create () in

let css_file = open_in "bin/style.css" in
let css_length = in_channel_length css_file in
let css_content = really_input_string css_file css_length in
close_in css_file;

GtkData.CssProvider.load_from_data css_provider css_content;

(* Apply CSS globally *)
let screen = Gdk.Screen.default () in

GtkData.StyleContext.add_provider_for_screen
  screen
  css_provider
  GtkData.StyleContext.ProviderPriority.application;

let window =
  GWindow.window
    ~title:"OCaml Calculator"
    ~width:520
    ~height:620
    ~border_width:12
    ~decorated:true
    ()
in

let _ = window#connect#destroy ~callback:GMain.quit in

let layout = 
  GPack.vbox
    ~spacing:8
    ~packing:window#add
    ()
in

let display =
  GEdit.entry
    ~text:"0"
    ~packing:layout#add
    ()
in

display#set_editable false;

let current_input = ref "0" in
let stored_value = ref 0.0 in
let pending_operation = ref None in
let start_new_number = ref true in
let second_mode = ref false in
let button_mode = ref None in
let buttons = ref [] in


let update_buttons () =
  List.iter
    (fun (original_label, button) ->
      let new_label = 
        if !second_mode then 
          match original_label with
          | "7" -> "xʸ"
          | "8" -> "x²"
          | "9" -> "√"
          | "4" -> "sin"
          | "5" -> "cos"
          | "6" -> "tan"
          | "1" -> "%"
          | "2" -> "ln"
          | "3" -> "log"
          | "C" -> "DEL"
          | _ -> original_label
        else
          original_label
        in
        button#set_label new_label
    )
    !buttons
in  

let toggle_second_mode () = 
  second_mode := not (!second_mode);
  update_buttons ();
  match !button_mode with
  | None -> ()
  | Some button -> 
    if !second_mode 
      then 
        button#misc#style_context#add_class "mode-active"
  else button#misc#style_context#remove_class "mode-active"
in

let update_display () =
  display#set_text !current_input
in

let add_digit digit = 
  if !start_new_number then (
    current_input := digit;
    start_new_number := false
  )
  else if digit <> "." || not (String.contains !current_input '.') then (
    if !current_input = "0" && digit <> "." then
      current_input := digit
    else
      current_input := !current_input ^ digit
  );
  update_display()
in

let choose_operation operation = 
  try
    stored_value := float_of_string !current_input;
    pending_operation := Some operation;
    start_new_number := true
  with Failure _ ->
    current_input := "Error";
    update_display(); 
in

let calculate_result () =
  match !pending_operation with
  | None -> ()
  | Some operation ->
    (try
      let second_value = float_of_string !current_input in
      
      let result = Calculator.calculate !stored_value second_value operation
      in

      current_input := Printf.sprintf "%.10g" result;
      pending_operation := None;
      start_new_number := true;
      update_display()

    with Failure _ ->
      current_input := "Error";
      pending_operation := None;
      start_new_number := true;
      update_display())
in

let delete () = 
  if (String.length !current_input = 0) then (
    current_input := "0"; 
    update_display ()) 
  else 
    if (String.length !current_input = 1) then current_input := "0" 
    else current_input := (String.sub !current_input 0 (String.length !current_input - 1)); 
    update_display () 
in

let clear () =
  current_input := "0";
  stored_value := 0.0;
  pending_operation := None;
  start_new_number := true;
  update_display()
in

let handle_button label =
  match label with
  | "C" -> if not (!second_mode) then clear () else delete ()
  | "Switch Mode" -> toggle_second_mode ()
  | "=" -> calculate_result ()
  | "+" -> choose_operation Calculator.ADD
  | "-" -> choose_operation Calculator.SUB
  | "*" -> choose_operation Calculator.MUL
  | "/" -> choose_operation Calculator.DIV
  | x -> 
    if not (!second_mode) then add_digit x
    else (
      if x = "7" then choose_operation Calculator.POW
      else if x = "8" then choose_operation Calculator.SQUARE
      else if x = "9" then choose_operation Calculator.SQRT
      else if x = "4" then choose_operation Calculator.LN
      else if x = "5" then choose_operation Calculator.SIN
      else if x = "6" then choose_operation Calculator.COS 
      else if x = "1" then choose_operation Calculator.MOD
      else if x = "2" then choose_operation Calculator.LN
      else if x = "3" then choose_operation Calculator.LOG
      else ())
in

let add_row labels =
  let row = 
    GPack.hbox
      ~spacing:5
      ~homogeneous:true
      ~packing:layout#add
      ()
  in
  
  List.iter 
    (fun label -> 
      let button = GButton.button
        ~label
        ~packing:row#add  
        ()
      in
      if label = "C" then button#misc#style_context#add_class "clear-button" else
      if label = "=" then button#misc#style_context#add_class "equals-button" else
      if List.mem label ["."; "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"] then button#misc#style_context#add_class "number-button";
      if List.mem label ["7"; "8"; "9"; "4"; "5"; "6"; "1"; "2"; "3"; "C"] then buttons := (label, button) :: !buttons 
      else
      if label = "Switch Mode" then button_mode := Some button;
      let _ = 
        button#connect#clicked
        ~callback:(fun () -> handle_button label)
      in
      ())
      labels
in

add_row["7"; "8"; "9"; "/"];
add_row["4"; "5"; "6"; "*"];
add_row["1"; "2"; "3"; "-"];
add_row["C"; "0"; "."; "+"];
add_row["="; "Switch Mode"];

window#show ();
in 

GMain.main ()