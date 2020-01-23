function [newMap, ticks, tickLabels] = cmapnonlin(myColors, centerPoint, cLim, scalingIntensity, inc)
    % Credits to Allen Yin on 2 Nov 2017 from:
    % https://uk.mathworks.com/matlabcentral/answers/307318-does-matlab-have-a-nonlinear-colormap-how-do-i-make-one
    % who came up with this function and named it: "MC_nonlinearCmap"
    % I renamed it to "cmapnonlin" for personal convenience
    % Olivier Codol 25th June 2019
    
    dataMax = cLim(2);
    dataMin = cLim(1);
    nColors = size(myColors,1);
    colorIdx = 1:nColors;
    colorIdx = colorIdx - (centerPoint-dataMin)*numel(colorIdx)/(dataMax-dataMin); % idx wrt center point
    colorIdx = scalingIntensity * colorIdx/max(abs(colorIdx));  % scale the range
    colorIdx = sign(colorIdx).*colorIdx.^2;
    colorIdx = colorIdx - min(colorIdx);
    colorIdx = colorIdx*nColors/max(colorIdx)+1;
    newMap = interp1(colorIdx, myColors, 1:nColors);
      if nargout > 1
          % ticks and tickLabels will mark [centerPoint-inc, ... centerPoint+inc, centerPoint+2*inc]
          % on a linear color bar with respect the colors corresponding to the new non-linear colormap
          linear_cValues = linspace(cLim(1), cLim(2), nColors);
          nonlinear_cValues = interp1(1:nColors, linear_cValues, colorIdx);
          tickVals = fliplr(centerPoint:-inc:cLim(1));
          tickVals = [tickVals(1:end-1), centerPoint:inc:cLim(2)];
          ticks = nan(size(tickVals));
          % find what linear_cValues correspond to when nonlinear_cValues==ticks
          for i = 1:numel(tickVals)
              [~, idx] = min(abs(nonlinear_cValues - tickVals(i)));
              ticks(i) = linear_cValues(idx);
          end
          tickLabels = arrayfun(@num2str, tickVals, 'Uniformoutput', false);
      end
  end