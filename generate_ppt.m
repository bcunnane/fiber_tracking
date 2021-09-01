% GENERATE_PPT automatically creates fiber tracking results powerpoint
%   set directory to fiber tracking results location

import mlreportgen.ppt.*

% get case information
name = char(regexp(pwd,'\d{6}-\w{2}','match'));
gifs = dir('*.gif');
plots = dir('*.png');

% create powerpoint
ppt = Presentation([name,' fiber tracking results.pptx']);
for n = 1:length(plots)
    
    plt = Picture(plots(n).name);
    plt.X = '400';
    plt.Y = '5';
    
    gif = Picture(gifs(n).name);
    gif.X = '40';
    gif.Y = '200';
    
    slide = add(ppt,'Blank');
    add(slide,plt)
    add(slide,gif)
end
close(ppt)