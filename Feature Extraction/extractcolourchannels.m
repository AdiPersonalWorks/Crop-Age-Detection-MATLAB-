function [img_redchannel,img_greenchannel,img_bluechannel] = extractcolourchannels( noisefree_img )

img_redchannel = noisefree_img(:,:,1);
img_greenchannel = noisefree_img(:,:,2);
img_bluechannel = noisefree_img(:,:,3);

end

