function res=CharNumberRecognition(filename,show,method)
% CharNumberRecognition

if ((show~=true)&&(show~=false))
    error('The second parameter is incorrect');
end
img=imread(filename);
orig=img;
img=correct(img);
[l len]=findnumbers(img);
if ((method==0)||(method==1))
    [num1 num2 num3]=Recognition(l,show,orig,len,method);
else
    error('The third parameter is incorrect');
end
res=[num1 num2 num3];
end

function [num1 num2 num3]=Recognition(l,show,orig,len,method)
st=regionprops(l,'BoundingBox');
num1=10;
num2=10;
num3=10;
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
end
if (show==true)
    figure, imshow(orig);
    printbox(l(:,:)>0);
end
end

function num=numberis0(img)
img=imresize(img,[200 NaN]);
sl=strel('disk',6);
img=imclose(img,sl);
img=img(:,:)>0.8;
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

function num=numberis1(img)
stat=regionprops(img,'Image');
img=stat.Image;
img=imresize(img,[50 30]);
min=1500;
for j=0:9
    name=sprintf('%d.bmp',j);
    n=imread(name);
    n=xor(n,img);
    if (sum(sum(n))<min)
        min=sum(sum(n));
        imin=j;
    end
end
num=imin;
end

function img=correct(img)
img=imadjust(img);
img=medfilt2(img);
img=imadjust(img);
end

function [l len]=findnumbers(img)
bw=img(:,:,:)<110;
l=bwlabel(bw);
l=sortarea(l);
[l len]=findchars(l);
end

function l=sortarea(l)
stat=regionprops(l,'Area');
idx1=find([stat.Area]>50);
idx2=find([stat.Area]<350);
idx=intersect(idx1,idx2);
l=bwlabel(ismember(l,idx));
end

function [l len]=findchars(l)
stat=regionprops(l,'BoundingBox');
len=length([stat.BoundingBox])/4;
idx=[];
for i=1:len
    temp=stat(i);
    h=[temp.BoundingBox];
    if (h(4)>h(3))
        idx=cat(2,idx,i);
    end
end
l=bwlabel(ismember(l,idx));
if (length(idx)>3)
    l=find3(l,stat,length(idx));
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
stat=regionprops(l,'BoundingBox');
len=length([stat.BoundingBox])/4;
for i=1:len
    temp=stat(i);
    h=[temp.BoundingBox];
    h=imrect(gca,h);
    h.setResizable(0);
end
end