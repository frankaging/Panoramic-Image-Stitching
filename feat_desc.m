function [p] = feat_desc(im, y, x)
    %Initialization
    im=padarray(im,[20 20],'both');
    %p is an array of descripters 8*8
    p=zeros(64,size(y,1));
    %Getting the sample region of 40*40
    y = y+20;
    x = x+20;
    %Blur the image
    a = 0.6;
    gx=[(0.25-a/2) 0.25 a 0.25 (0.25-a/2)];
    G=conv2(gx,gx');
    %Getting the subsample of those descriptors, and normalization
    for i=1:size(y,1)
        imCurrent = im((y(i)-20):(y(i)+19),(x(i)-20):(x(i)+19));
        im=conv2(double(im),G,'same');
        p(:,i)=reshape(imCurrent(1:5:size(imCurrent,1),1:5:size(imCurrent,2)),[64,1]);
        p(:,i)=(p(:,i)-mean(p(:,i)))/std(p(:,i),1,1);
    end
end