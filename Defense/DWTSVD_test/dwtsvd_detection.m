%function [result, result_wpsnr] = dwtsvd_detection(original, watermarked, attacked)
function result = dwtsvd_detection(original, watermarked, attacked)
    orgn = imread(original);
    wtrm = imread(watermarked);
    atck = imread(attacked);

    [~,OLH,OHL,~] = dwt2(orgn,'haar');
    [~,WLH,WHL,~] = dwt2(wtrm,'haar');
    [~,ALH,AHL,~] = dwt2(atck,'haar');

    [UOL,SOL,VOL] = svd(OLH);
    
    [UOH,SOH,VOH] = svd(OHL);
    
    SplusWL = UOH' * WHL * VOH;
    SplusWH = UOL' * WLH * VOL;
    
    SplusAL = UOH' * AHL * VOH;
    SplusAH = UOL' * ALH * VOL;
 
    a = 1;
    wtrm_1 = zeros(256,1,'double');
    
    for i=(1:256)
        wtrm_1(i) = ((SplusWL(i,i)-SOH(i,i))/a);
    end
    
    %extr_wtrmL = extr_wtrmL';
    %extr_wtrmH = extr_wtrmH';
    
    %atck_wtrmL = atck_wtrmL';
    %atck_wtrmH = atck_wtrmH';
    
    %extr_wtrm = idwt(extr_wtrmH,extr_wtrmL,'haar');
    %atck_wtrm = idwt(atck_wtrmL,atck_wtrmH,'haar');
    %atck_wtrm = extr_wtrm;
    
    sim = extr_wtrm * atck_wtrm'/sqrt(atck_wtrm * atck_wtrm');
   
    %sim = extr_wtrm * atck_wtrm' / (sqrt(extr_wtrm*extr_wtrm') * sqrt(atck_wtrm*atck_wtrm'))
    
    %fprintf("Sim -> %5.5f", sim);

    result = sim;
    %result_wpsnr = 0;