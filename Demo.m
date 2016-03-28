   %Demo Script For Mosaic


    %Getting corner detection and non-max-suppression
    
    I1=imread('IMG_8784.jpg');
    
    I2=imread('IMG_8785.jpg');
    I2 = flipdim(I2,2);      %# Flips the columns, making a mirror image
    I2 = flipdim(I2,1);  %# Flips the rows, making an upside-down image
    
    I3=imread('IMG_8786.jpg');
    I3 = flipdim(I3,2);      %# Flips the columns, making a mirror image
    I3 = flipdim(I3,1);  %# Flips the rows, making an upside-down image
    
    I={I1,I2,I3};
    
    Ig1=rgb2gray(I1);
    Ig2=rgb2gray(I2);
    Ig3=rgb2gray(I3);    

    %using default function getting corner mapping
    
    %original
    conerMap1=cornermetric(Ig1);
    C=double(imregionalmax(conerMap1));
    conerMap1=C.*conerMap1;
    corners=find(conerMap1);
    [y1 x1]=ind2sub(size(conerMap1),corners);
    figure
    subplot(1,2,1);
    imshow(I1)
    hold on
    plot(x1,y1,'.')
    %nms
    [y1 x1] = anms(conerMap1, 200);
    subplot(1,2,2);
    imshow(I1)
    hold on
    plot(x1,y1,'.','Color',[1,0,0]);
    
    %original
    conerMap2=cornermetric(Ig2);
    C=double(imregionalmax(conerMap2));
    conerMap2=C.*conerMap2;
    corners=find(conerMap2);
    [y2 x2]=ind2sub(size(conerMap2),corners);
    figure
    subplot(1,2,1);
    imshow(I2)
    hold on
    plot(x2,y2,'.')
    %nms
    [y2 x2] = anms(conerMap2, 200);
    subplot(1,2,2);
    imshow(I2)
    hold on
    plot(x2,y2,'.','Color',[1,0,0]);
    
    %original
    conerMap3=cornermetric(Ig3);
    C=double(imregionalmax(conerMap3));
    conerMap3=C.*conerMap3;
    corners=find(conerMap3);
    [y3 x3]=ind2sub(size(conerMap3),corners);
    figure
    subplot(1,2,1);
    imshow(I3)
    hold on
    plot(x3,y3,'.')
    %nms
    [y3 x3] = anms(conerMap3, 200);
    subplot(1,2,2);
    imshow(I3)
    hold on
    plot(x3,y3,'.','Color',[1,0,0]); 
    
    %Stiching feature selection demo
    f1=feat_desc(Ig1,y1,x1);
    f2=feat_desc(Ig2,y2,x2);
    %Getting the matched feature
    matchFea=feat_match(f1,f2);
    %Getting the matched feature of image 1
    matchFea1=[1:size(f1,2)]';
    matchFea1=matchFea1(matchFea~=-1);
    %Getting the matched feature of image 2  
    matchFea2=matchFea(matchFea~=-1);
    %Points used to get H
    xH1=x1(matchFea1);
    yH1=y1(matchFea1);
    xH2=x2(matchFea2);
    yH2=y2(matchFea2);

    %Just for plotting
    figure
    subplot(1,2,1);
    imshow(I1)
    hold on
    plot(x1,y1,'b.');
    plot(xH1,yH1,'r.')
    
    subplot(1,2,2);
    imshow(I2)
    hold on
    plot(x2,y2,'b.');
    plot(xH2,yH2,'r.');
    
    %Stiching feature selection demo
    f1=feat_desc(Ig3,y3,x3);
    f2=feat_desc(Ig2,y2,x2);
    %Getting the matched feature
    matchFea=feat_match(f1,f2);
    %Getting the matched feature of image 1
    matchFea1=[1:size(f1,2)]';
    matchFea1=matchFea1(matchFea~=-1);
    %Getting the matched feature of image 2  
    matchFea2=matchFea(matchFea~=-1);
    %Points used to get H
    xH1=x3(matchFea1);
    yH1=y3(matchFea1);
    xH2=x2(matchFea2);
    yH2=y2(matchFea2);

    %Just for plotting
    figure
    subplot(1,2,1);
    imshow(I3)
    hold on
    plot(x3,y3,'b.');
    plot(xH1,yH1,'r.')
    
    subplot(1,2,2);
    imshow(I2)
    hold on
    plot(x2,y2,'b.');
    plot(xH2,yH2,'r.');
    
    
    
