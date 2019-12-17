function [numvecs] = percentrepresented(theeigs,percentof)
amount = 0;
i = 1;
sumeigs = sum(theeigs);
runsum = 0;
while amount <= percentof
    runsum = runsum + theeigs(i);
    i = i+1;
    amount = runsum/sumeigs;
end
numvecs = i;
end
