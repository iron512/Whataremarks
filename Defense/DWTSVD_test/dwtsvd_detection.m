function [result, result_wpsnr] = dwtsvd_detection(original, watermarked, attacked)
    orgn = imread(original);
    wtrm = imread(watermarked);
    atck = imread(attacked);

    [~,OLH,OHL,~] = dwt2(orgn,'haar');
    [~,WLH,WHL,~] = dwt2(wtrm,'haar');
    [~,ALH,AHL,~] = dwt2(atck,'haar');

    [~,OL,~] = svd(OLH);
    [~,WL,~] = svd(WLH);
    [~,AL,~] = svd(ALH);
    
    [~,OH,~] = svd(OHL);
    [~,WH,~] = svd(WHL);
    [~,AH,~] = svd(AHL);

    extr_wtrm = zeros(512,1);
    atck_wtrm = zeros(512,1);
    
    a = 0.15;
    for i=(1:256)
        extr_wtrm(i+256) = (WL(i,i) - OL(i,i))/a;
        atck_wtrm(i+256) = (AL(i,i) - OL(i,i))/a;
        
        extr_wtrm(i) = (WH(i,i) - OH(i,i))/a;
        atck_wtrm(i) = (AH(i,i) - OH(i,i))/a;
    end
    
    extr_wtrm = extr_wtrm';
    %atck_wtrm = atck_wtrm';
    atck_wtrm = extr_wtrm;
    
    sim = sqrt(extr_wtrm * atck_wtrm')/sqrt(atck_wtrm * atck_wtrm');

    fprintf("Sim -> %5.5f", sim);

    result = 0;
    result_wpsnr = 0;