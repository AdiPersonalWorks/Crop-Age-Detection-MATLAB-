function f = adpmedian(g, Smax)
%ADPMEDIAN Perform adaptive median filtering.
%   F = ADPMEDIAN(G, SMAX) performs adaptive median filtering of
%   image G.  The median filter starts at size 3-by-3 and iterates up
%   to size SMAX-by-SMAX. SMAX must be an odd integer greater than 1.

% SMAX must be an odd, positive integer greater than 1.
if (Smax <= 1) | (Smax/2 == round(Smax/2)) | (Smax ~= round(Smax))
   error('SMAX must be an odd integer > 1.')
end
[M,N,P] = size(g);

% Initial setup.
f = g;
redChannel = g(:,:,1);
greenChannel = g(:,:,2);
blueChannel = g(:,:,3);
f(:) = 0;
alreadyProcessed = false(size(redChannel));

% Begin filtering.
for k = 3:2:Smax
   zmin = ordfilt2(redChannel, 1, ones(k, k), 'symmetric');
   zmax = ordfilt2(redChannel, k * k, ones(k, k), 'symmetric');
   zmed = medfilt2(redChannel, [k k], 'symmetric');
   
   processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ...
       ~alreadyProcessed; 
   zB = (redChannel > zmin) & (zmax > redChannel);
   outputZxy  = processUsingLevelB & zB;
   outputZmed = processUsingLevelB & ~zB;
   f1(outputZxy) = redChannel(outputZxy);
   f1(outputZmed) = zmed(outputZmed);
   
   alreadyProcessed = alreadyProcessed | processUsingLevelB;
   if all(alreadyProcessed(:))
      break;
   end
end
% Output zmed for any remaining unprocessed pixels. Note that this zmed was computed using a window of size Smax-by-Smax, which is
% the final value of k in the loop.
f1(~alreadyProcessed) = zmed(~alreadyProcessed);

alreadyProcessed = false(size(greenChannel));
for k = 3:2:Smax
   zmin = ordfilt2(greenChannel, 1, ones(k, k), 'symmetric');
   zmax = ordfilt2(greenChannel, k * k, ones(k, k), 'symmetric');
   zmed = medfilt2(greenChannel, [k k], 'symmetric');
   
   processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ...
       ~alreadyProcessed; 
   zB = (greenChannel > zmin) & (zmax > greenChannel);
   outputZxy  = processUsingLevelB & zB;
   outputZmed = processUsingLevelB & ~zB;
   f2(outputZxy) = greenChannel(outputZxy);
   f2(outputZmed) = zmed(outputZmed);
   
   alreadyProcessed = alreadyProcessed | processUsingLevelB;
   if all(alreadyProcessed(:))
      break;
   end
end
% Output zmed for any remaining unprocessed pixels. Note that this zmed was computed using a window of size Smax-by-Smax, which is
% the final value of k in the loop.
f2(~alreadyProcessed) = zmed(~alreadyProcessed);

alreadyProcessed = false(size(blueChannel));
for k = 3:2:Smax
   zmin = ordfilt2(blueChannel, 1, ones(k, k), 'symmetric');
   zmax = ordfilt2(blueChannel, k * k, ones(k, k), 'symmetric');
   zmed = medfilt2(blueChannel, [k k], 'symmetric');
   
   processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ...
       ~alreadyProcessed; 
   zB = (blueChannel > zmin) & (zmax > blueChannel);
   outputZxy  = processUsingLevelB & zB;
   outputZmed = processUsingLevelB & ~zB;
   f3(outputZxy) = blueChannel(outputZxy);
   f3(outputZmed) = zmed(outputZmed);
   
   alreadyProcessed = alreadyProcessed | processUsingLevelB;
   if all(alreadyProcessed(:))
      break;
   end
end
% Output zmed for any remaining unprocessed pixels. Note that this zmed was computed using a window of size Smax-by-Smax, which is
% the final value of k in the loop.
f3(~alreadyProcessed) = zmed(~alreadyProcessed);

f = cat(3,f1,f2,f3);
f = reshape(f,M,N,P);