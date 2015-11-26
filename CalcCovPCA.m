function CalcCovPCA ()

data = csvread('c:\DataHack\Mobileye\gitCode\Com\features_table_combined.csv',1,1);
fields = 7:size(data,2);

data (:,end+1) = data(:,2)*10000+data(:,3);

[unique_val,~,val_idx] = unique(data(:,end));
data(:,end+1) = val_idx;

% Extract features
features = data(:,fields);

% Normalize
meanf = mean(features);
stdf = std(features);
features_norm = bsxfun(@times,bsxfun(@minus,features,meanf),1./stdf);

features_norm_mean = [features_norm features_norm features_norm];

% Cov
for i = 1:numel(unique_val)
    good_idx = val_idx == i;
    mean_total = mean(features_norm(good_idx,:),1);
    residuals = bsxfun(@minus,features_norm(good_idx,:),mean_total);
    features_norm_mean(good_idx,numel(fields)+1:end) = [repmat(mean_total,[sum(good_idx),1]), residuals];
end

cov_means = cov(features_norm_mean(:,numel(fields)+1:2*numel(fields)));
cov_res = cov(features_norm_mean(:,2*numel(fields)+1:3*numel(fields)));

cov_mat = cov_means * inv(cov_res+eye(size(cov_res))); % or inverse instead x^-1

[ev,~] = eig(cov_mat);
pca_vec = real(ev(:,end:-1:end-1));

feat_projection = features_norm*pca_vec;


figure,scatter(feat_projection(:,1),feat_projection(:,2),[],val_idx);

% PCA
[pc,~,~,~] = princomp(features_norm);
feat_projection = features_norm*pc(:,1:2);
figure,scatter(feat_projection(:,1),feat_projection(:,2),[],val_idx);

% Corralation
for i = 1:size(features_norm,2)
    cr(i) = abs(corr(val_idx,features_norm(:,i)));
end

[~,sidx] = sort(cr);
figure,scatter(features_norm(:,sidx(1)),features_norm(:,sidx(2)),[],val_idx);