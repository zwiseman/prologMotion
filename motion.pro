
/*printImage(+Image)*/

printEl([]).
printEl(El) :- print(El).
printRow([]).
printRow([RH|RT]) :- printEl(RH), printRow(RT).
printImage([]).
printImage([IH|IT]) :- printRow(IH), nl, printImage(IT).

/*diffIm(+Image1,+Image2,-Diff)*/

diffEl([],[],[]).
diffEl(El1,El2,Diff) :- Diff is El2 - El1.
diffRow([],[],[]).
diffRow([R1H|R1T],[R2H|R2T],[DiffH|DiffT]) :- diffRow(R1T,R2T,DiffT), diffEl(R1H,R2H,DiffH).
diffIm([],[],[]).
diffIm([I1H|I1T],[I2H|I2T],[DiffH|DiffT]) :- diffIm(I1T,I2T,DiffT), diffRow(I1H,I2H,DiffH).

/*zeroDiffIm(+Image1,+Image2)*/

zeroEl(El) :- El = 0.
diffEl([]).
diffEl([RH|RT]) :- zeroEl(RH), diffEl(RT).
diffIma([]).
diffIma([DH|DT]) :- diffEl(DH), diffIma(DT).
zeroDiffIm([]).
zeroDiffIm(I1,I2) :- diffIm(I1,I2,D), diffIma(D).

/*mask(+Image1,+Image2,+DiffIm,-I1masked,-I2masked)*/

maskEl(_,_,0,I1mRH,I2mRH) :- I1mRH is 0, I2mRH is 0.
maskEl(I1RH,I2RH,DImRH,I1mRH,I2mRH):-
(DImRH < 0, I1mRH is I1RH, I2mRH is 0);
(DImRH > 0, I2mRH is I2RH, I1mRH is 0).
maskRow([],[],[],[],[]).
maskRow([I1RH|I1RT],[I2RH|I2RT],[DImRH|DImRT],[I1mRH|I1mRT],[I2mRH|I2mRT]) :- maskEl(I1RH,I2RH,DImRH,I1mRH,I2mRH), maskRow(I1RT,I2RT,DImRT,I1mRT,I2mRT), !.
mask([],[],[],[],[]).
mask([I1H|I1T],[I2H|I2T],[DImH|DImT],[I1MH|I1MT],[I2MH|I2MT]) :- 
maskRow(I1H,I2H,DImH,I1MH,I2MH), mask(I1T,I2T,DImT,I1MT,I2MT).

/*add one to list*/

addOne(X,Y) :- Y is X + 1.

/*fnzRowEl(+Mask,-Index)*/

rowEl([],_,_).
rowEl([0|MRT],Index,Count) :- !, addOne(Count,New), rowEl(MRT, Index, New).
rowEl([_|_], Index, Count) :- addOne(Count,New), Index is New.
fnzRowEl(M, Index) :- rowEl(M,Index,0), Index \= (M).

/*firstNonZero(+MaskedImage,-RowIndex,-ColIndex)*/

firstNon([],_,_,_).
firstNon([GH|_],RI,CI,Count) :- fnzRowEl(GH,CI), RI is Count.
firstNon([_|GT],RI,CI,Count) :- addOne(Count,NewCount), firstNon(GT,RI,CI,NewCount).
firstNonZero(MI,RI,CI) :- firstNon(MI,RI,CI,1).

/*theMotion(+Image1,+Image2,-Moti,-Motj)*/

theMotionOne(I1,I2,Mi,Mj) :- diffIm(I1,I2,Diff), mask(I1,I2,Diff,M1,M2),
 printImage(M1),printImage(M2), firstNonZero(M1,Mi1,Mj1), firstNonZero(M2,Mi2,Mj2), Mi is Mi2-Mi1, Mj is Mj2-Mj1.
isMotion(I1,I2,_,_) :- zeroDiffIm(I1,I2), write('***** No Motion in This Case *****'),nl.
isMotion(I1,I2,Mi,Mj) :- theMotionOne(I1,I2,Mi,Mj).
theMotion(I1,I2,Mi,Mj) :- isMotion(I1,I2,Mi,Mj).
