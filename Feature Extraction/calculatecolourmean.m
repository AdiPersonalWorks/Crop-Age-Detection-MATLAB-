function [col_mean_r,col_mean_g,col_mean_b,mean_r,mean_g,mean_b] = calculatecolourmean(img_redchannel,img_greenchannel,img_bluechannel)

col_mean_r = mean(img_redchannel(:,1:end),1);
col_mean_g = mean(img_greenchannel(:,1:end),1);
col_mean_b = mean(img_bluechannel(:,1:end),1);

mean_r = mean(col_mean_r);
mean_g = mean(col_mean_g);
mean_b = mean(col_mean_b);

end

