function class=recognize_sign(img,model,mode)
    if (mode==0)
        img=imresize(img,[30 30]);
        img=compute_hog(img,10,2,8);
        class=svmpredict(0,img,model);
    else
        img=imresize(img,[30 30]);
        img=compute_hog(img,10,2,8);
        class=svmpredict(0,img,model);
    end
    class=class2str(class);
end

function a=class2str(class)
    i=0;
    while (1)
        i=i+1;
        tmp=mod(class,100);
        class=fix(class/100);
        b(i)=tmp;
        if (~class)
            break;
        end
    end
    b=b+48;
    b=fliplr(b);
    a=zeros(1,length(b)+3);
    a(1:3)='be_';
    a(4:length(a))=b;
    a=char(a);
end