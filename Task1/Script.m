function proc=Script(method)
load numbers.mat
load numbers_night.mat
col1=0;
col2=0;
for i=1:50
    name=sprintf('std\\%d.bmp',i);
    res1=CharNumberRecognition(name,false,method);
    name=sprintf('bonus\\%d.bmp',i);
    res2=CharNumberRecognition(name,false,method);
    for j=1:3
        if (numbers(i,j)==res1(j))
            col1=col1+1;
        %else
        %    fprintf('std\\%d.bmp\n',i);
        end
        if (numbers_night(i,j)==res2(j))
            col2=col2+1;
        %else
        %    fprintf('bonus\\%d.bmp\n',i);
        end
    end
end
proc=[(col1/(i*j))*100 (col2/(i*j))*100];
end