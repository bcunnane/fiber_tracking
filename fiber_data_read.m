function fibers = fiber_data_read()
%FIBER_DATA_READ imports fiber points and regions
%   Select excel file with columns: X, Y, Region as single letter
%   Example row: 60 150 'p'

PTS_PER_FIBER = 2;

% import raw data
raw = readcell(uigetfile('.xlsx','Select fiber coordinate file.'));

% create fiber structure
fibers = struct;
fibers.x = cell2mat(raw(:,1));
fibers.y = cell2mat(raw(:,2));
fibers.reg = cell2mat(raw(:,3));
fibers.raw = raw;
end

