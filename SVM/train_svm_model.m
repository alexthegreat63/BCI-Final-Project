function [mdl, acc_cv] = train_svm_model(X, Y, kernel, num_folds)

cv_idx = mod(randperm(size(X,1)), num_folds) + 1;
acc_hist = [];

for i = 1:num_folds
    X_train = X(cv_idx ~= i, :);
    Y_train = Y(cv_idx ~= i);
    X_test = X(cv_idx == i, :);
    Y_test = Y(cv_idx == i);
    
    mdl = fitrsvm(X_train, Y_train, 'KernelFunction', kernel);
    Y_pred = predict(mdl, X_test);
    acc = corr(Y_pred, Y_test);
    
    acc_hist(i) = acc;
end

acc_cv = mean(acc_hist);

mdl = lasso(X, Y, 'KernelFunction', kernel);

end