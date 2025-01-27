function [predicted_dg] = make_wlr_predictions(test_ecog)

%
% Inputs: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.
% Outputs: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)
% Run time: The script has to run less than 1 hour.
%
% The following is a sample script.

% Load Model
% Imagine this mat file has the following variables:
% winDisp, filtTPs, trainFeats (cell array), 

load('team_awesome_model_lasso.mat')
load('../../data.mat')
load('test_features.mat')
load('lr_predictions.mat')

%load weights for each subject and each finger
%w is a 3 x 5 cell array, containing the weights for each subject per row,
%and model for each finger per column

% Predict using linear predictor for each subject
%create cell array with one element for each subject
predicted_dg = cell(3,1);
finger_ss = [0.01;0.01;0.1;0.01;0.01];
%for each subject
for subj = 1:3 
    yhat_int = [];
    yhat_int_padded = [];
    %get the testing ecog
    testset = test_ecog{subj}; 

    %initialize the predicted dataglove matrix
    yhat = zeros(size(testset,1),5);
    
    %for each finger
    for finger = 1:5 
        %predict dg based on ECOG for each finger
        yhat(:,finger) = testset * models{subj,finger}.weights + models{subj,finger}.info.Intercept;
        y_hat(:,finger) = [0; yhat(1:end-1,finger)];
        yhat(:,finger) = yhat(:,finger) .* yhat_lr{subj}(:,finger);
        lms = dsp.LMSFilter('Length',32,'StepSize',finger_ss(finger));
       des =yhat(:,finger) ;
       des(yhat(:,finger)<0.1) = 0;
       yhat(:,finger) = step(lms,yhat(:,finger),des);
        yhat_int(:,finger) = spline(1:length(yhat(:,finger)), yhat(:,finger)', linspace(1,length(yhat(:,finger)),147500-80));
        yhat_int_padded(:,finger) = [zeros(140,1); yhat_int(1:end-60,finger)];
    end
    predicted_dg{subj} = yhat_int_padded;
     
end

save('predictions1_wlr_shifted', 'predicted_dg')

end
