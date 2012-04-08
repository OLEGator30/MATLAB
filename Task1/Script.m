function proc=Script(method)
load numbers.mat
col=0;
for i=1:50
    name=sprintf('std\\%d.bmp',i);
    res=CharNumberRecognition(name,false,method);
    for j=1:3
        if (numbers(i,j)==res(j))
            col=col+1;
        end
    end
end
proc=(col/(i*j))*100;
end