Require Export imp_ast.

Definition state := id -> nat.

Definition program := id -> com * list  id * aexp.

Inductive status : Type :=
  | SContinue : status
  | SBreak : status.

Definition empty_state : state :=
  fun _ => 0.
  
Definition update (st : state) (x : id) (n : nat) : state :=
  fun x' => if eq_id_dec x x' then n else st x'.

Theorem update_shadow : forall n1 n2 x1 x2 (st : state),
   (update (update st x2 n1) x2 n2) x1 = (update st x2 n2) x1.
Proof.
	intros.
	unfold update.
	repeat destruct eq_id_dec; reflexivity.
Qed.

Theorem update_same : forall n1 x1 x2 (st : state),
  st x1 = n1 ->
  (update st x1 n1) x2 = st x2.
Proof.
	intros. unfold update.
	destruct eq_id_dec.
	subst. reflexivity.
	reflexivity.
Qed.

Theorem update_permute : forall n1 n2 x1 x2 x3 st,
  x2 <> x1 -> 
  (update (update st x2 n1) x1 n2) x3 = (update (update st x1 n2) x2 n1) x3.
Proof.
	intros. unfold update.
	repeat destruct eq_id_dec; try reflexivity.
	subst. contradiction H. reflexivity.
Qed.