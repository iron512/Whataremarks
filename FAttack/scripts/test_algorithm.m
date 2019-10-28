function [attackedImage, wpsn, attack, factor, points] = test_algorithm(originalImage,watermarkedImage, detectFunction)
[attackedImage, wpsn, attack, factor] = main_attack(originalImage,watermarkedImage, detectFunction);
im = imread(originalImage);
watermarked = imread(watermarkedImage);
dwps = WPSNR(im, watermarked);

fprintf("----------------------------------------------------------------------------\nFINAL RESULT:\nBest attack: ");
for a=attack
   fprintf("%s, ", char(a{1})); 
end
fprintf("\nwith factors: ");
print_vector(factor);
fprintf("\nATTACK WPSNR: %.3f\nDEFENSE WPSNR: %.3f\n", wpsn, dwps);


if dwps >= 66
    dpts = 6;
elseif dwps >= 62
    dpts = 5;
elseif dwps >= 58
    dpts = 4;
elseif dwps >= 54
    dpts = 3;
elseif dwps >= 50
    dpts = 2;
elseif dwps >= 35
    dpts = 1;
else
    dpts = 0;
end

if dwps >= 53
    rpts = 0;
elseif dwps >= 50
    rpts = 1;
elseif dwps >= 47
    rpts = 2;
elseif dwps >= 44
    rpts = 3;
elseif dwps >= 41
    rpts = 4;
elseif dwps >= 38
    rpts = 5;
else
    rpts = 6;
end
points = dpts+rpts;
fprintf("Total competition points: %d (%d quality, %d robustness)\n", points, dpts, rpts);


imshow([im, watermarked, attackedImage]);
end
