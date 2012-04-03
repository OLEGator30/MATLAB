function [num1 num2 num3]=CharNumberRecognition(img,show,method)
%Выделяет три цифры на номере

if (~(strcmp(show,'true')||strcmp(show,'false')))
    error('The second parameter is incorrect');
end

img=correct(img);

boxes(img);

if (method==0)
    [num1 num2 num3]=RecognitionMethod1(img,show);
elseif (method==1)
    [num1 num2 num3]=RecognitionMethod2(img,show);
else
    error('The third parameter is incorrect');
end

end

function [num1 num2 num3]=RecognitionMethod1(img,show)
    num1=0;
    num2=0;
    num3=0;
end

function [num1 num2 num3]=RecognitionMethod2(img,show)
    num1=0;
    num2=0;
    num3=0;
end

function img=correct(img)
    tmp=img;
    img=imadjust(img);
    d=fspecial('disk',1);
    a=fspecial('average');
    g=fspecial('gaussian');
    filt=d*a*g;
    img=imfilter(img,filt);
    img=imadjust(img);
end

function boxes(img)
    bw=im2bw(img,0.2);
    bw=~bw;
    l=bwlabel(bw);
    
    imshow(bw);
    st=regionprops(l,'BoundingBox','Area');
    idx1=find([st.Area]>100);       % слишком маленькие области
    idx2=find([st.Area]<200);       % слишком большие области
    idx=intersect(idx1,idx2);
    l=bwlabel(ismember(l,idx));
    st=regionprops(l,'BoundingBox','Area');
    len=length([st.Area]);
    if (len<3)
        error('sorry, can not find 3 numbers');
    else
        for i=1:len
            temp=st(i);
            h=[temp.BoundingBox];
            h=imrect(gca,h);
            h.setResizable(0);
        end
    end
end