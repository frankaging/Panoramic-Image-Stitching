function I =mainMosaic(I1,I2)

    %for accuracy, operations are to be done in gray scale
    Ig1=rgb2gray(I1);
    Ig2=rgb2gray(I2);
    %using default function getting corner mapping
    conerMap1=cornermetric(Ig1);
    conerMap2=cornermetric(Ig2);
    %By doing NMS, getting the final feature maps
    [y1 x1]=anms(conerMap1,200);
    [y2 x2]=anms(conerMap2,200);
  
    %Getting the 8*8 descriptors for future mapping
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
    
    %Thresholding to get H approximation
    thresh=9;
    [H,inliers_idx]=ransac_est_homography(yH1,xH1,yH2,xH2,thresh);
  
    
    tform = projective2d(H');
    I_t = imwarp(I2,tform);
    imshow(I_t)
    
    %Image blending factor
    blendFrac = 0.7;
    
    %Firstly, get the final panoramic view scene
    Ylength=size(Ig2,1);
    Xlength=size(Ig2,2);
    X=[1;Xlength;1;Xlength];
    Y=[1;1;Ylength;Ylength];
    [xCor,yCor]=apply_homography(H,X,Y);
    hInv=inv(H);
    minX=round(min(xCor));
    maxX=round(max(xCor));
    minY=round(min(yCor));
    maxY=round(max(yCor));
    [Xarr,Yarr]=meshgrid(minX:maxX,minY:maxY);
    Xarr=reshape(Xarr,[size(Xarr,1)*size(Xarr,2),1]);
    Yarr=reshape(Yarr,[size(Yarr,1)*size(Yarr,2),1]);
    [ntx,nty]=apply_homography(hInv,Xarr,Yarr);
    minx=min(minX,1);
    miny=min(minY,1);
    maxx=max(maxX,size(I1,2));
    maxy=max(maxY,size(I1,1));
    I=zeros(maxy-miny+1,maxx-minx+1,3);

    %Boundary conditions
    sy = max(1,1-miny);
    sx = max(1,1-minx);
    
    %Copying pixel values from I1
    I((sy):(sy+size(I1,1)-1),(sx):(sx+size(I1,2)-1),:)=I1(:,:,:);
    
    %Linear interpolations
    idx=ntx>=1 & ntx<=size(I2,2) & nty>=1 & nty<=size(I2,1);   
   
    ntx=ntx(idx);
    nty=nty(idx);
    Yarr=Yarr(idx);
    Xarr=Xarr(idx);
    
    %Blending and interpolation
    for i=1:size(Xarr,1)
            ceilPixelx = ceil(ntx(i));
            ceilPixely = ceil(nty(i));
            floorPixelx = floor(ntx(i));
            floorPixely = floor(nty(i));
            yPercent = 0.5;
            xPercent = 0.5;
            
            yavg1 = (1-yPercent)*I2(ceilPixely,floorPixelx,:) + yPercent*I2(floorPixely,floorPixelx,:);
            yavg2 = (1-yPercent)*I2(ceilPixely,ceilPixelx,:) + yPercent*I2(floorPixely,ceilPixelx,:);
            
            xavg = (1-xPercent)*yavg2 + xPercent*yavg1; 
            
            
        if all(I(Yarr(i)-miny+1,Xarr(i)-minx+1,:))== 0
            
               I(Yarr(i)-miny+1,Xarr(i)-minx+1,:) = xavg;
        else
            
               I(Yarr(i)-miny+1,Xarr(i)-minx+1,:)=(blendFrac .* I(Yarr(i)-miny+1,Xarr(i)-minx+1,:)) + ((1-blendFrac) .* double(xavg));%rounding
        end
    end
    I=uint8(I);
 end