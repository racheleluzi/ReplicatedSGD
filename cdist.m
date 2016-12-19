function d =cdist( J1,J2 )
K=size(J1,2);
J1=double(J1);
J2=double(J2);
for k=1:K
    s(k)=-2*dot(J1(:,k),J2(:,k))+sum(J1(:,k))+sum(J2(:,k))
    dot(J1(:,k),J2(:,k))
end
d=sum(s);

end

