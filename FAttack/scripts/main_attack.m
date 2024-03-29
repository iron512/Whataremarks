function [attackedImage, wpsn, attack, factor] = main_attack(originalImage,watermarkedImage, detectFunction)
if isempty(gcp('nocreate'))
fprintf("Starting thread pool...\n");
parpool;
end
fprintf("Starting attack...\n");
startTime = now;
exampleAttack = @a_awgn;
exampleAttackedImage = qsave(uint8(exampleAttack(double(imread(watermarkedImage)), 0.5)));
detectFunction(originalImage, watermarkedImage, exampleAttackedImage);
detectTime = evaluate_function(detectFunction, originalImage, watermarkedImage, exampleAttackedImage);
fprintf("Measured detect function time: %d ms\n", round(detectTime));
[attackList, bs_precision, ga_trials]  = get_attack_list(detectTime);

fprintf("Searching best single attack with binary search...\n");
[~, values, wpsns, imgs, attackList] = bs_attacks(attackList, originalImage, watermarkedImage, detectFunction, bs_precision, max(ga_trials));
use_attacks_max = min(length(attackList), 6);
if use_attacks_max > max(ga_trials)
    ga_trials(length(ga_trials)+1) = use_attacks_max;
end
wpsn = wpsns(1);
attack = {attackList{1}};
factor = values{1};
factor = [factor(1)];
attackedImage = imgs{1};
fprintf("----------------------------------------------------------------------------\n!!! Best standalone attack: %s - Best WPSNR found: %.2f with factor %.3f\n----------------------------------------------------------------------------\n", char(attack{1}), wpsn, factor(1));

for ga_numi=ga_trials
ga_num = min(ga_numi, length(values));
if ga_num < 1 
    continue;
end
gaAttackList = cell(1, ga_num);
maxes = zeros(1, ga_num);
for i = 1:ga_num
    value = values{i};
    maxes(i) = value(2);
    gaAttackList{i} = attackList{i};
end

min_fn = minimize_function(gaAttackList, originalImage, watermarkedImage, detectFunction);
opts = optimoptions(@ga,'InitialPopulationRange',[zeros(1, ga_num); maxes]);
opts.FunctionTolerance = 0;
opts.MaxStallGenerations = 50;
opts.MaxStallTime = 5*ga_num+6;
opts.PopulationSize = 2*ga_num+4;
%opts.PlotFcn = {@gaplotbestf,@gaplotstopping};
%opts.UseParallel = true;
opts.MaxTime = 120;

fprintf("Starting GA search with %d attacks...\n", ga_num);
[x,fval,~,~] = ga(min_fn,ga_num,[],[],[],[],[],[],[],opts);
w = 1/fval;
fprintf("!!! Best WPSNR found with latest search: %.3f with factors ", w);
print_vector(x);
fprintf("\n");
if wpsn >= w 
    continue;
end
wpsn = w;
factor = x;
attack = gaAttackList;
%attackFn = multi_attack(gaAttackList);
[~,attackedImage] = min_fn(factor);
end

fprintf("Total attack time: %.1f seconds\n", (now-startTime)*100000);



end

