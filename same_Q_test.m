M1=[1,5,6;2,4,6;1,3,6];
M2=[2,3,6;3,1,7;9,4,7];
N1=[1,5,2];
N2=[3,7,3];
M1=normr(M1).*normr(M1);
M2=normr(M2).*normr(M2);
N1=normr(N1).*normr(N1);
N2=normr(N2).*normr(N2);

graph_matching(ARG(M1,N1),ARG(M2,N2));