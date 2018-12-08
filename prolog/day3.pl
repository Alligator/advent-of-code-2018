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

main(Result1) :-
  % part 1
  File = `#1 @ 1,3: 4x4\n#2 @ 3,1: 4x4\n#3 @ 5,5: 2x2`,
  phrase(claims(Claims), File),
  Result1 = Claims.
