function [mdl, mdl_info, lambda, best_acc, best_acc_idx] = train_model(X, Y, lambda_range, num_folds)

cv_idx = mod(randperm(size(X,1)), num_folds) + 1;
acc_hist = [];

for i = 1:num_folds
    X_train = X(cv_idx ~= i, :);
    Y_train = Y(cv_idx ~= i);
    X_test = X(cv_idx == i, :);
    Y_test = Y(cv_idx == i);
    
    [mdl, info] = lasso(X_train, Y_train, 'Lambda', lambda_range);
    Y_pred = X_test * mdl + repmat(info.Intercept, size(X_test,1), 1);
    acc = corr(Y_pred, Y_test);
    
    acc_hist(:,i) = acc;
end

acc = mean(acc_hist, 2);
[best_acc, best_acc_idx] = max(acc);

[mdl, mdl_info] = lasso(X, Y, 'Lambda', info.Lambda(best_acc_idx));
lambda = info.Lambda(best_acc_idx);

end