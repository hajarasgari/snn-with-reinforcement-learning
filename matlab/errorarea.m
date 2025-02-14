function [ha hl] = errorarea(X,MeanValue,StdValue,colorArea,colorLine)
% errorarea
%   X               - Horizontal axis.
%   MeanValue       - Values of mean.
%   StdValue        - Values of standard deviation.
%   colorArea       - Color for the area, which covers +- 1 STD.
%   colorLine       - Color for the line line, which shows the mean.
%
% RETURN
%   ha              - Handle to area.
%   hl              - Handle to line.
%

%   Florian Raudies, 09/07/2014, Boston University.

if nargin<4, colorArea = 'b'; end
if nargin<5, colorLine = 'k'; end

Xd = [X(:); flipud(X(:))];
Yd = [MeanValue(:)-StdValue(:); flipud(MeanValue(:)+StdValue(:))];
ha = fill(Xd,Yd,colorArea,'LineStyle','none'); hold on;
hl = plot(X(:),MeanValue(:),'-','LineWidth',2.0,'Color',colorLine); hold off;
