type lambda_term =
  | FreeVar of string 
  | BoundVar of int 
  | Abs of lambda_term
  | Appl of (lambda_term * lambda_term)


let rec lambda_term_to_string t = 
  match t with
  | FreeVar v -> v
  | BoundVar v -> string_of_int v        
  | Abs x -> "[]." ^ lambda_term_to_string x 
  | Appl (x,y) -> "(" ^ lambda_term_to_string x ^ " " ^ lambda_term_to_string y ^ ")"

let rec substitution t var tsub= 
match t with 
| FreeVar v -> FreeVar v 
| BoundVar v -> if v = var then tsub else BoundVar v
| Abs x -> Abs(substitution x (var+1) tsub)
| Appl (x,y) -> Appl(substitution x var tsub,substitution y var tsub)



let alpha_equiv terme_un terme_deux = 
(lambda_term_to_string terme_un) = (lambda_term_to_string terme_deux)


let reduction t = 
match t with
| FreeVar v -> FreeVar v
| BoundVar v -> BoundVar v
| Abs x -> Abs(x)
| Appl(Abs(x),y) -> substitution x 0 y
| Appl(x,y) -> failwith "erreur reduction"


let rec evaluation t = 
match t with 
| FreeVar v -> FreeVar v 
| BoundVar v -> BoundVar v 
| Abs x -> Abs x
| Appl(Abs(x),y) -> evaluation(reduction t)
| Appl(BoundVar x,y) -> Appl(BoundVar x,y)
| Appl(FreeVar x,y) -> Appl(FreeVar x,y)
| Appl(x,y) -> evaluation(Appl(evaluation x, y))

(* let rec reduction_forte t = 
match t with 
| FreeVar v -> FreeVar v 
| BoundVar v -> BoundVar v
| Abs x -> Abs(reduction_forte x)
| Appl(Abs(x),y) -> reduction_forte(substitution x 0 y)
| Appl(x,y) -> (Appl(reduction_forte x, reduction_forte y)) *)


let rec reduction_forte t = 
match t with
| FreeVar v -> FreeVar v 
| BoundVar v -> BoundVar v
| Abs x -> Abs(reduction_forte x)
| Appl(BoundVar x,y) -> Appl(BoundVar x, reduction_forte y)
| Appl(FreeVar x,y) -> Appl(FreeVar x, reduction_forte y)
| Appl(Abs(x),y) -> reduction_forte(substitution x 0 (reduction_forte y))
| Appl(x,y) -> reduction_forte(Appl(reduction_forte x ,reduction_forte y)) 
	       
			 (* Les booléens *)

let lambda_true = Abs(Abs(BoundVar 1))
let lambda_false = Abs(Abs(BoundVar 0))		      
let lambda_if_else = Abs(Abs(Abs(Appl(Appl(BoundVar 2, BoundVar 1),BoundVar 0))))

			
let test2 = Appl(Appl(lambda_if_else,lambda_false),FreeVar "y")
  
let test = Appl(Appl(Appl(lambda_if_else,lambda_false),FreeVar "y"),FreeVar "x")
(*let test3 = Appl(lambda_if_else, *)

let () = Printf.printf "%s \n" (lambda_term_to_string lambda_true)
let () = Printf.printf "%s \n" (lambda_term_to_string lambda_false)
let () = Printf.printf "%s \n" (lambda_term_to_string lambda_if_else)
let () = Printf.printf "%s \n" (lambda_term_to_string test)
let () = Printf.printf "\n"
let () = Printf.printf "%s \n" (lambda_term_to_string (evaluation test2))
let () = Printf.printf "%s \n" (lambda_term_to_string (evaluation test))

let () = Printf.printf "\n"
let arguments3 = Appl(Appl(Abs(BoundVar 0),Abs(BoundVar 0)),FreeVar "y")
let () = Printf.printf "%s \n" (lambda_term_to_string (evaluation arguments3))









		       (* Les entiers de church *)
(* Fonctions de manipulation *)

let rec church_num n =
  match n with
  | 0 -> BoundVar 0
  | n -> Appl(BoundVar 1,(church_num (n-1)))
		       
let int_to_lambda_term n =
  Abs(Abs(church_num n))

let rec lambda_term_to_int t =
  match t with
  | BoundVar x -> 0
  | Abs(Abs(x)) -> 0 + (lambda_term_to_int x)
  | Appl(BoundVar x,y) -> 1 + (lambda_term_to_int y)
  | FreeVar y -> failwith " to_int FreeVar erreur"
  | Appl(x,y) -> failwith "to_int Appl erreur"
  | Abs(x) -> failwith "to_int Abs erreur"

(* Défintions des termes *)

let plus = Abs(Abs(Abs(Abs(Appl(Appl(Appl(Appl (BoundVar 3, BoundVar 1),BoundVar 2),BoundVar 1),BoundVar 0)))))
let plus = Abs(Abs(Abs(Abs(Appl(Appl(BoundVar 3,BoundVar 1),Appl(Appl(BoundVar 2,BoundVar 1),BoundVar 0))))))
let plustest = Appl(Appl(plus,(int_to_lambda_term 2)),(int_to_lambda_term 2))
let succ = Abs(Abs(Abs(Appl(BoundVar 1,Appl(Appl(BoundVar 2,BoundVar 1),BoundVar 0)))))
let testsucc = Appl(succ,(int_to_lambda_term 2))
		
(*let () = Printf.printf "%s \n" (lambda_term_to_string(evaluation plustest))
let () = Printf.printf "%s \n" (lambda_term_to_string(reduction_forte(reduction_forte(reduction_forte plustest)))) *)
let () = Printf.printf "%s \n" (lambda_term_to_string(reduction_forte testsucc))
let () = Printf.printf "%d \n" (lambda_term_to_int(reduction_forte testsucc))
(*let () = Printf.printf "%s \n" (lambda_term_to_string(reduction_forte plustest)) *) 
						 
(*let () = Printf.printf "%s \n" (lambda_term_to_string(plustest))
let () = Printf.printf "%s \n" (lambda_term_to_string(evaluation(plustest))) *)


(*
let () = Printf.printf "%s \n" (lambda_term_to_string (int_to_lambda_term 0))
let () = Printf.printf "%s \n" (lambda_term_to_string (int_to_lambda_term 1))
let () = Printf.printf "%s \n" (lambda_term_to_string (int_to_lambda_term 2))
    

let () = Printf.printf "%d \n" (lambda_term_to_int(int_to_lambda_term 2))
let () = Printf.printf "%d \n" (lambda_term_to_int(int_to_lambda_term 1))
let () = Printf.printf "%d \n" (lambda_term_to_int(int_to_lambda_term 0)) *)
		       


						 