function [m] = feat_match(p1,p2)
    %Setting the threshold(based on the outlier rejection graph)
    thresh=0.75;
    
    %Initialize m as -1 for future usage
    m=-1*ones(size(p1,2),1);
    
    %Looping through every colume of p, which is different descriptors
    for i=1:size(p1,2)
        
        %Getting the norm and distance
        diffDes=bsxfun(@minus,p1(:,i),p2);
        diffDes=sum(diffDes.*diffDes);
        [minDis,idx]=sort(diffDes,2);
        ratio = minDis(1)/minDis(2);
        if (ratio<thresh)
            m(i)=idx(1);
        else
            m(i)=-1;
        end
    end
end