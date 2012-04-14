function res=CharNumberRecognition(filename,show,method)
img=imread(filename);
orig=img;
img=correct(img);
[img len]=findnumbers(img);
if ((method==0)||(method==1))
    [num1 num2 num3]=Recognition(img,show,orig,len,method);
else
    error('The third parameter is incorrect');
end
res=[num1 num2 num3];
end

function [num1 num2 num3]=Recognition(l,show,orig,len,method)
st=regionprops(l,'BoundingBox');
if (len==3)
    arr=[st(1).BoundingBox(1) st(2).BoundingBox(1) st(3).BoundingBox(1)];
    arr=sort(arr);
    for i=1:3
        if (st(i).BoundingBox(1)==arr(1))
            if (method==0)
                num1=numberis0(ismember(l,i));
            else
                num1=numberis1(ismember(l,i));
            end
            break;
        end
    end
    for i=1:3
        if (st(i).BoundingBox(1)==arr(2))
            if (method==0)
                num2=numberis0(ismember(l,i));
            else
                num2=numberis1(ismember(l,i));
            end
            break;
        end
    end
    for i=1:3
        if (st(i).BoundingBox(1)==arr(3))
            if (method==0)
                num3=numberis0(ismember(l,i));
            else
                num3=numberis1(ismember(l,i));
            end
            break;
        end
    end
elseif (len==2)
    if (st(1).BoundingBox(1)<st(2).BoundingBox(1))
        if (method==0)
            num1=numberis0(ismember(l,1));
            num2=numberis0(ismember(l,2));
        else
            num1=numberis1(ismember(l,1));
            num2=numberis1(ismember(l,2));
        end
    else
        if (method==0)
            num1=numberis0(ismember(l,2));
            num2=numberis0(ismember(l,1));
        else
            num1=numberis1(ismember(l,2));
            num2=numberis1(ismember(l,1));
        end
    end
elseif (len==1)
    if (method==0)
        num1=numberis0(l);
    else
        num1=numberis1(l);
    end
else
    num1=10;
    num2=10;
    num3=10;
end
if (show==true)
    figure, imshow(orig);
    printbox(l>0,len,size(orig));
end
end

function num=numberis0(img)
st=regionprops(img,'BoundingBox','Area','EulerNumber','FilledArea','Centroid','Extrema');
if (st.EulerNumber==-1)
    num=8;
elseif (st.EulerNumber==0)
    if (st.FilledArea/st.Area>1.45)
        num=0;
    else
        if ((st.BoundingBox(2)+st.BoundingBox(4)/2)>st.Centroid(2))
            num=9;
        else
            num=6;
        end
    end
else
    if (st.Centroid(1)>st.Extrema(5,1))
        num=7;
        return;
    end
    if (st.Centroid(1)<st.Extrema(6,1))
        if (img(round(st.BoundingBox(2))+5,round(st.BoundingBox(1)+st.BoundingBox(3))-8)==0)
            num=4;
        else
            num=1;
        end
        return;
    end
    if ((st.Extrema(4,1)<st.Extrema(5,1)+5)&&(st.Extrema(7,1)<st.Extrema(6,1)+5))
        num=2;
        return;
    end
    if (img(round(st.BoundingBox(2)+st.BoundingBox(4)/2-7),round(st.BoundingBox(1))+5)==0)
        num=3;
        return;
    end
    num=5;
end
end

function imin=numberis1(img)
stat=regionprops(img,'Image');
img=stat.Image;
img=imresize(img,[50 30]);
min=1500;
for j=0:9
    n=sprintf('%d.bmp',j);
    n=imread(n);
    n=xor(n,img);
    if (sum(sum(n))<min)
        min=sum(sum(n));
        imin=j;
    end
end
end

function img=correct(img)
img=imresize(img,[250 NaN]);
img=adapthisteq(img,'Distribution','exponential','Alpha',0.1);
img=imadjust(img);
f=fspecial('gaussian')*fspecial('average');
img=imfilter(img,f);
img=imadjust(img);
end

function [img len]=findnumbers(img)
img=~im2bw(img,graythresh(img)-0.075);
img=sortarea(bwlabel(img));
[img len]=findchars(img);
end

function l=sortarea(l)
l=imopen(l,strel('disk',2));
stat=regionprops(l,'Area');
idx1=find([stat.Area]>500);
idx2=find([stat.Area]<6500);
idx=intersect(idx1,idx2);
l=bwlabel(ismember(l,idx));
end

function [l len]=findchars(l)
stat=regionprops(l,'BoundingBox');
len=length([stat.BoundingBox])/4;
idx=[];
for i=1:len
    if ((stat(i).BoundingBox(4)>stat(i).BoundingBox(3))&&(stat(i).BoundingBox(4)/stat(i).BoundingBox(3)<3.5))
        idx=cat(2,idx,i);
    end
end
l=bwlabel(ismember(l,idx));
if (length(idx)>3)
    l=find3(l);
    len=3;
    return;
end
len=length(idx);
end

function l=find3(l)
while 1
    st=regionprops(l,'BoundingBox');
    len=length([st.BoundingBox])/4;
    idx=findmax(st,len);
    arr=[abs(st(idx(1)).BoundingBox(1)-st(idx(2)).BoundingBox(1)) abs(st(idx(3)).BoundingBox(1)-st(idx(2)).BoundingBox(1)) abs(st(idx(1)).BoundingBox(1)-st(idx(3)).BoundingBox(1))];
    [arr i]=sort(arr);
    if (((arr(1)<95)&&(arr(2)<95))||(len==3))
        l=bwlabel(ismember(l,idx));
        break;
    else
        if (i(1)==1)
            id=1:len;
            idx=setdiff(id,idx(3));
        elseif (i(1)==2)
            id=1:len;
            idx=setdiff(id,idx(1));
        else
            id=1:len;
            idx=setdiff(id,idx(2));
        end
        l=bwlabel(ismember(l,idx));
    end
end
end

function idx=findmax(st,len)
for i=1:len
    arr(i)=st(i).BoundingBox(4);
end
[arr idx]=sort(arr,'descend');
idx=idx(1:3);
end

function printbox(l,len,s)
l=imresize(l,s);
stat=regionprops(l,'BoundingBox');
for i=1:len
    l=[stat(i).BoundingBox];
    l=imrect(gca,l);
    l.setResizable(0);
end
end