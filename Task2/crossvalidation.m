function crossvalidation(dirname)
    img=dir([dirname '/*.png']);
    txt=dir([dirname '/*.txt']);
    len=length(img);
    hogtxt=zeros(len,1);
    hogimg=zeros(len,2592);
    for i=1:len
        fprintf('processing image %d of %d\n',i,len);
        tmpimg=imread([dirname img(i).name]);
        tmpimg=imresize(tmpimg,[30 30]);
        tmpimg=compute_hog(tmpimg,10,2,8);
        tmptxt=get_ground_truth_class([dirname txt(i).name]);
        hogimg(i,:)=tmpimg;
        hogtxt(i)=mystr2double(tmptxt);
    end
    len=length(hogtxt);
    i=1:len;
    err=0;
    for j=1:5
        fprintf('iteration %d of 5\n',j);
        idx=crossvalind('Kfold',i,5);
        coltest=1;
        coltrain=1;
        traintxt=hogtxt;
        trainimg=hogimg;
        for i=1:len
            if (idx(i)==5)
                testimg(coltest,:)=hogimg(i,:);
                testtxt(coltest)=hogtxt(i);
                coltest=coltest+1;
                trainimg(coltrain,:)=[];
                traintxt(coltrain)=[];
            else
                coltrain=coltrain+1;
            end
        end
        model=svmtrain(traintxt,trainimg,'-t 0'); % for linear function
        % model=svmtrain(hogtxt,hogimg,'-t 2'); % for radial basis function
        [a b c]=svmpredict(testtxt',testimg,model);
        err=err+b;
    end
    err=err/5;
    fprintf('average error = %d',err);
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