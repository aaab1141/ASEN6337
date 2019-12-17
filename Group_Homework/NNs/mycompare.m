function [tablee,confusionlabels,confusionpredicted] = mycompare(YPred,Labes)
predicted = string(YPred);
labeled = string(Labes);

if size(predicted,1) ~= size(labeled,1)
    error('You done goofed')
end
confusionlabels = zeros(size(predicted,1),1);
confusionpredicted = confusionlabels;
classes = ["Fish";"Flower";"Gravel";"Sugar"];
percentages = zeros(4,1);
totalfish = 0;guessedfish = 0;
totalflower = 0;guessedflower = 0;
totalgravel = 0;guessedgravel = 0;
totalsugar = 0;guessedsugar = 0;
for i = 1:size(predicted,1)
    realclass = labeled(i);
    guessedclass = predicted(i);
    if strcmp("Fish",realclass) == 1
        if strcmp("Fish",guessedclass) == 1
            totalfish = totalfish + 1;
            guessedfish = guessedfish + 1;
            confusionlabels(i) = 1;
            confusionpredicted(i) = 1;
        else
            totalfish = totalfish + 1;
            confusionlabels(i) = 1;
            if strcmp("Flower",guessedclass) == 1
                confusionpredicted(i) = 2;
            elseif strcmp("Gravel",guessedclass) == 1
                confusionpredicted(i) = 3;
            elseif strcmp("Sugar",guessedclass) == 1
                confusionpredicted(i) = 4;
            else
                error('Bloody Ashes!')
            end
        end        
    elseif strcmp("Flower",realclass) == 1
        if strcmp("Flower",guessedclass) == 1
            totalflower = totalflower + 1;
            guessedflower = guessedflower + 1;
            confusionlabels(i) = 2;
            confusionpredicted(i) = 2;
        else
            totalflower = totalflower + 1;
            confusionlabels(i) = 2;
            if strcmp("Fish",guessedclass) == 1
                confusionpredicted(i) = 1;
            elseif strcmp("Gravel",guessedclass) == 1
                confusionpredicted(i) = 3;
            elseif strcmp("Sugar",guessedclass) == 1
                confusionpredicted(i) = 4;
            else
                error('Bloody Ashes!')
            end
        end   
    elseif strcmp("Gravel",realclass) == 1
        if strcmp("Gravel",guessedclass) == 1
            totalgravel = totalgravel + 1;
            guessedgravel = guessedgravel + 1;
            confusionlabels(i) = 3;
            confusionpredicted(i) = 3;
        else
            totalgravel = totalgravel + 1;
            confusionlabels(i) = 3;
            if strcmp("Fish",guessedclass) == 1
                confusionpredicted(i) = 1;
            elseif strcmp("Flower",guessedclass) == 1
                confusionpredicted(i) = 2;
            elseif strcmp("Sugar",guessedclass) == 1
                confusionpredicted(i) = 4;
            else
                error('Bloody Ashes!')
            end
        end   
    elseif strcmp("Sugar",realclass) == 1
        if strcmp("Sugar",guessedclass) == 1
            totalsugar = totalsugar + 1;
            guessedsugar = guessedsugar + 1;
            confusionlabels(i) = 4;
            confusionpredicted(i) = 4;
        else
            totalsugar = totalsugar + 1;
            confusionlabels(i) = 4;
            if strcmp("Fish",guessedclass) == 1
                confusionpredicted(i) = 1;
            elseif strcmp("Flower",guessedclass) == 1
                confusionpredicted(i) = 2;
            elseif strcmp("Gravel",guessedclass) == 1
                confusionpredicted(i) = 3;
            else
                error('Bloody Ashes!')
            end
        end 
    else
        error('This is a worse goof')
    end
end
percentages(1) = guessedfish/totalfish;
percentages(2) = guessedflower/totalflower;
percentages(3) = guessedgravel/totalgravel;
percentages(4) = guessedsugar/totalsugar;
tablee = table(classes,percentages);

end

