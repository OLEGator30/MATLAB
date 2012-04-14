function sred=Averaging(folder)

sred=zeros(50,30);
for i=1:100
    name=sprintf('%s\\%d.bmp',folder,i);
    img=imread(name);
    img=imadjust(img);
    img=~im2bw(img,graythresh(img));
    img=imresize(img,[50 30]);
    sred=sred+img;
end
sred=sred>75;
end