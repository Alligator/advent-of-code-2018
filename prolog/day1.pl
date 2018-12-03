:- use_module(library(list_util)).
:- use_module(library(assoc)).

% number_codes with flipped args so it can be used in maplist/3
parse_num(S, R) :-
  number_codes(R, S).

parse_input(I, R) :-
  split_string(I, "\n", " +", L),
  delete(L, "", L2),
  maplist(parse_num, L2, R).

% use assoc lists to make this much much faster
sum_until_repeat(List, Repeat) :-
  empty_assoc(Assoc),
  sum_until_repeat(List, 0, Assoc, Repeat).
sum_until_repeat([Head|_], Sum, Results, Repeat) :-
  NewSum is Sum + Head,
  get_assoc(NewSum, Results, 1),
  Repeat = NewSum.
sum_until_repeat([Head|Tail], Sum, Results, Repeat) :-
  NewSum is Sum + Head,
  put_assoc(NewSum, Results, 1, NewResults),
  sum_until_repeat(Tail, NewSum, NewResults, Repeat).

main(Result1, Result2) :-
  % part 1
  read_file_to_codes("../inputs/day1", File, []),
  string_codes(StrFile, File),
  parse_input(StrFile, Nums),
  sum_list(Nums, Result1),

  % part 2
  cycle(Nums, InfNums),
  sum_until_repeat(InfNums, Result2).
