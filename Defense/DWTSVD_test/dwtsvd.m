function img = dwtsvd(original, mark)

    [LL,LH,HL,HH] = dwt2(original,'haar');
    [WL,WH] = dwt(mark(:)','haar');
    
    [ULH,SLH,VLH] = svd(LH);
    [UHL,SHL,VHL] = svd(HL);
    %[~,WS,~] = svd(WHL);
    
    %startx = 1;
    %starty = 1;
    %[sizeix,sizeiy] = size(S);
    v1 = WL(1:256);
    v2 = WL(257:512);
    
    v3 = WH(1:256);
    v4 = WH(257:512);
    
    a = 0.15;
    for i=(1:256)
        SHL(i,i) = SHL(i,i) + a*v1(i);
        SLH(i,i) = SLH(i,i) + a*v2(i);
    end
    
    %SLH(1,:) = SLH(1,:) + a*v3;
    %SLH(2,:) = SLH(2,:) + a*v4;
    
    %SHL(1,:) = SHL(3,:) + a*v1;
    %SHL(2,:) = SHL(4,:) + a*v2;
    
    LH = ULH*SLH*VLH';
    HL = UHL*SHL*VHL';
    
img = uint8(idwt2(LL,LH,HL,HH,'haar'));