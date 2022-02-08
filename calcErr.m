function err = calcErr(T, Y)
    n=size(T,1);
    err=sum(T~=Y)/n;
end