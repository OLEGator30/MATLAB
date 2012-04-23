function model=train_sign_recognition(dirname)
    img=dir([dirname '/*.png']);
    txt=dir([dirname '/*.txt']);
    len=length(img);
    hogtxt=zeros(len,1);
    hogimg=zeros(len,2592);
    for i=1:len
        fprintf('processing image %d of %d\r',i,len);
        tmpimg=imread([dirname img(i).name]);
        tmpimg=imresize(tmpimg,[30 30]);
        tmpimg=compute_hog(tmpimg,10,2,8);
        hogimg(i,:)=tmpimg;
        tmptxt=get_ground_truth_class([dirname txt(i).name]);
        hogtxt(i)=mystr2double(tmptxt);
    end
    %model=svmtrain(hogtxt,hogimg,'-t 0'); % for linear function
    model=svmtrain(hogtxt,hogimg,'-t 2'); % for radial basis function
end

function gt_class = get_ground_truth_class(annotation_file)
    f = fopen(annotation_file);
    text = textscan(f, '%s');
    gt_class = text{1}{3};
    gt_class(1:3) = [];
    fclose(f);
end

function a=mystr2double(txt)
    txt=double(txt)-48;
    a=0;
    for i=1:length(txt)
        a=a*100+txt(i);
    end
end