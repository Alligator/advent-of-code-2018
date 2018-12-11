% parse the input using a DCG
claims([]) --> [].
claims([L|Ls]) --> claim(L), claims(Ls).
claim([Id, X, Y, W, H]) --> "#", nat(Id), " ", "@", " ", nat(X), ",", nat(Y), ":", " ", nat(W), "x", nat(H), ("\n" ; []).

digit(0) --> "0".
digit(1) --> "1".
digit(2) --> "2".
digit(3) --> "3".
digit(4) --> "4".
digit(5) --> "5".
digit(6) --> "6".
digit(7) --> "7".
digit(8) --> "8".
digit(9) --> "9".

nat(N) --> digit(D), nat(D, N).
nat(N, N) --> [].
nat(A, N) --> digit(D), { A1 is A*10 + D }, nat(A1, N).

% gen_row(X, Y, W, Row)
% true when Row is the list of all [X, Y] coordinate pairs from
% [X, Y] to [X + W, Y]
gen_row(X, Y, W, Row) :-
  FinalX is X + W - 1,
  findall([N, Y], between(X, FinalX, N), Row).

% gen_cells(Claim, Cells
% true when Cells is the list of all [X, Y] coordinate pairs
% for the given Claim
gen_cells([_, X, Y, W, H], Cells) :-
  FinalY is Y + H - 1,
  findall(N, between(Y, FinalY, N), Rows),
  maplist({X, W}/[Y2, Out]>>gen_row(X, Y2, W, Out), Rows, NestedCells),
  append(NestedCells, FlatCells),
  sort(FlatCells, Cells).

% overlaps(List, Overlaps)
% true when Overlaps is an assoc list of, for every Element in List,
% Element-NumberOfOccurences
overlaps(List, Overlaps) :-
  empty_assoc(Assoc),
  overlaps(List, Assoc, Overlaps).
overlaps([], Assoc, Assoc).
% case where H is in the assoc list
overlaps([H|T], Assoc, Overlaps) :-
  get_assoc(H, Assoc, _),
  put_assoc(H, Assoc, 2, NewAssoc),
  overlaps(T, NewAssoc, Overlaps).
% case where H is not in the assoc list
overlaps([H|T], Assoc, Overlaps) :-
  put_assoc(H, Assoc, 1, NewAssoc),
  overlaps(T, NewAssoc, Overlaps).

% find_matching_claim(ListOfClaims, Cells, Claim)
% true when Claim is the claim in ListOfClaims that would generate Cells
find_matching_claim([H|_], Cells, Claim) :-
  gen_cells(H, C),
  sort(C, S),
  ord_intersection(S, Cells, S),
  Claim = H.
find_matching_claim([_|T], Cells, Claim) :-
  find_matching_claim(T, Cells, Claim).

main(Result1, Result2) :-
  % part 1
  % File = `#1 @ 1,3: 4x4\n#3 @ 5,5: 2x2\n#2 @ 3,1: 4x4`,
  read_file_to_codes("../inputs/day3", File, []),
  phrase(claims(Claims), File),
  maplist(gen_cells, Claims, Cells),
  append(Cells, AllCells),
  overlaps(AllCells, OverlapsAssoc),

  % part 1
  findall(X, gen_assoc(X, OverlapsAssoc, 2), Overlaps),
  length(Overlaps, Result1),

  % part 2
  findall(X, gen_assoc(X, OverlapsAssoc, 1), NonOverlaps),
  find_matching_claim(Claims, NonOverlaps, [Result2|_]).
