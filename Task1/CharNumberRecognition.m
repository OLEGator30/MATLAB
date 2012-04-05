function [num1 num2 num3]=CharNumberRecognition(img,show,method)
% CharNumberRecognition

if (~((show==true)||(show==false)))
    error('The second parameter is incorrect');
end

orig=img;
img=correct(img);
[l len]=findnumbers(img);

if (method==0)
    [num1 num2 num3]=RecognitionMethod1(l,show,orig,len);
elseif (method==1)
    [num1 num2 num3]=RecognitionMethod2(l,show,orig,len);
else
    error('The third parameter is incorrect');
end

end

function [num1 num2 num3]=RecognitionMethod1(l,show,orig,len)
    num1=10;
    num2=10;
    num3=10;
    st=regionprops(l,'BoundingBox');
    
    if (len==3)
        arr=[st(1).BoundingBox(3) st(2).BoundingBox(3) st(3).BoundingBox(3)];
        arr=sort(arr);
        for i=1:3
            if (st(i).BoundingBox(3)==arr(1))
                num1=numberis1(ismember(l,1));
            end
        end
        for i=1:3
            if (st(i).BoundingBox(3)==arr(2))
                num2=numberis1(ismember(l,2));
            end
        end
        for i=1:3
            if (st(i).BoundingBox(3)==arr(3))
                num3=numberis1(ismember(l,3));
            end
        end
    elseif (len==2)
        if (st(1).BoundingBox(3)<st(2).BoundingBox(3))
            num1=numberis1(ismember(l,1));
            num2=numberis1(ismember(l,2));
        else
            num1=numberis1(ismember(l,2));
            num2=numberis1(ismember(l,1));
        end
    elseif (len==1)
        num1=numberis1(l);
    end
    
    if (show==true)
        imshow(orig);
        printbox(l(:,:)>0);
    end
end

function num=numberis1(bw)
num=0;
end

function [num1 num2 num3]=RecognitionMethod2(l,show,orig,len)
    num1=10;
    num2=10;
    num3=10;
    
    if (show==true)
        imshow(orig);
        printbox(l);
    end
end

function img=correct(img)
    img=imadjust(img);
    img=medfilt2(img);
    img=imadjust(img);
end

function [l len]=findnumbers(img)
    bw=img(:,:,:)<100;
    l=bwlabel(bw);
    l=sortarea(l);
    [l len]=findchars(l);
end

function l=sortarea(l)
    st=regionprops(l,'Area');
    idx1=find([st.Area]>50);
    idx2=find([st.Area]<300);
    idx=intersect(idx1,idx2);
    l=bwlabel(ismember(l,idx));
end

function [l len]=findchars(l)
    st=regionprops(l,'BoundingBox');
    len=length([st.BoundingBox])/4;
    idx=[];
    for i=1:len
        temp=st(i);
        h=[temp.BoundingBox];
        if (h(4)>h(3))
            idx=cat(2,idx,i);
        end
    end
    l=bwlabel(ismember(l,idx));
    if (length(idx)>3)
        l=find3(l,st,length(idx));
        len=3;
        return;
    end
    len=length(idx);
end

function l=find3(l,st,len)
    while len>3
        idx=1:len;
        tmp=st(1);
        h=[tmp.BoundingBox];
        imin=1;
        min=h(4);
        for i=2:len
            tmp=st(i);
            h=[tmp.BoundingBox];
            if (min>h(4))
                min=h(4);
                imin=i;
            end
        end
        idx=setdiff(idx,imin);
        l=bwlabel(ismember(l,idx));
        st=regionprops(l,'BoundingBox');
        len=length(idx);
    end
end

function printbox(l)
    st=regionprops(l,'BoundingBox');
    len=length([st.BoundingBox])/4;
    for i=1:len
        temp=st(i);
        h=[temp.BoundingBox];
        h=imrect(gca,h);
        h.setResizable(0);
    end
end