function tform = affine_register(moving,fixed)
%AFFINE_REGISTER affine image registration
%   affine register FSE (moving) to 1st frame of magnitude dynamic (fixed)

[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

tform = imregtform(moving, fixed, 'affine', optimizer, metric);

end

