function [FDRmap] = LangersSearchlightFDR_BG(Pmap, Mask, pos_matrix, FWHMregion, RegionShape, FWHMnoise);

% rFDR:
%   Derives a map with threshold FDR values from a given P-value map and a given
%   regional weighting function (Langers et al., NeuroImage 2007). By thresholding
%   this map at a level alpha, an estimated FDR is achieved that is bounded by alpha.
% 
% Syntax example:
%   FDRmap = rFDR(Pmap, Mask, Resolution, FWHMregion, RegionShape, FWHMnoise);
%   ActiveVoxels = (FDRmap <= alpha);
%   
% Input:
%   Pmap        : A matrix of P-values (0.0 <= Pmap <= 1.0)
%   Mask        : A matrix of logical/boolean values indicating the voxels of interest
%   Resolution  : A vector with the voxel dimensions (in mm) along the matrix axes
%   FWHMregion  : The FWHM (in mm) of the isotropic regional weighting function
%   RegionShape : The shape of the weighting function.
%                 Available options are:
%                 0. 'infinite'    : Infinite weighting function (constant)
%                 1. 'spherical'   : Spherical weighting function (uniform)
%                 2. 'bartlett'    : Bartlett weighting function (triangular)
%                 3. 'welch'       : Welch weighting function (quadratic)
%                 4. 'connes'      : Connes weighting function (quartic)
%                 5. 'cosine'      : Cosine weighting function (half-period sinusoid)
%                 6. 'hann'        : Hann weighting function (full-period sinusoid)
%                 7. 'invsquare'   : Inverse square limited weighting function ( 1/(1+r^2) )
%                 8. 'exponential' : Exponential weighting function (proportional decrease)
%                 9. 'gaussian'    : Gaussian weighting function (bell-shape)
%                 Shapes can be specified using either the above numbers or strings.
%                 For option 0, the parameter FWHMregion is not used.
%   FWHMnoise   : The FWHM (in mm) of the equivalent Gaussian noise smoothing kernel
% 
% Output:
%   FDRmap      : A matrix with threshold FDR values.


% TRAP INVALID ARGUMENTS
if (~isnumeric(Pmap)) | (ndims(Pmap) > 3)
  error('The P-value map must be a 1D-3D numeric matrix!');
end
if (~islogical(Mask)) | (~isequal(size(Pmap),size(Mask)))
  error('The mask must be a boolean matrix of identical size as the P-value map!');
end
% if (~isnumeric(Resolution)) | (~isequal(size(Resolution(:)), [ndims(Pmap), 1])) | (any(Resolution <= 0.0))
%   error('The resolution vector is invalid!');
% end
% Resolution = [Resolution(:); ones(3-length(Resolution),1)];
if (~isnumeric(FWHMregion)) | (length(FWHMregion) > 1)
  error('The FWHM size of the regions is invalid!');
end
FWHMregion = max(abs(FWHMregion), eps);
if (isnumeric(RegionShape)) & (length(RegionShape) == 1) & (RegionShape >= 0) & (RegionShape <= 9) & (RegionShape == round(RegionShape))
  Shape = RegionShape;
elseif (ischar(RegionShape)) & (ndims(RegionShape) == 2) & (size(RegionShape,1) == 1)
  switch deblank(lower(RegionShape))
    case 'infinite'; Shape = 0;
    case 'spherical'; Shape = 1;
    case 'bartlett'; Shape = 2;
    case 'welch'; Shape = 3;
    case 'connes'; Shape = 4;
    case 'cosine'; Shape = 5;
    case 'hann'; Shape = 6;
    case 'invsquare'; Shape = 7;
    case 'exponential'; Shape = 8;
    case 'gaussian'; Shape = 9;
    otherwise; error('The specified regional weighting function shape is unknown!');
  end
else
  error('The regional weighting function shape is invalid!');
end
if (~isnumeric(FWHMnoise)) | (length(FWHMnoise) > 1)
  error('The FWHM size of the equivalent noise smoothing kernel is invalid!');
end
FWHMnoise = max(abs(FWHMnoise), eps);
if (any(Pmap(Mask) < 0.0)) | (any(Pmap(Mask) > 1.0)) | (any(~isfinite(Pmap(Mask))))
  warning('The P-value map contained invalid entries; these will be excluded from the inclusion mask.');
  Mask = Mask & (Pmap >= 0.0) & (Pmap <= 1.0) & (isfinite(Pmap));
end
if (FWHMregion < FWHMnoise)
  warning('The FWHM size of the regions was chosen too small, and will be increased to match the smoothness of the noise.');
  FWHMregion = FWHMnoise;
end

% INITIALIZATION
FDRmap = NaN*Pmap;
UnsortedIndex = find(Mask);
Ntotal = length(UnsortedIndex);
FalsePositiveSum = zeros(Ntotal,1);
ReselSum = 0.0;

% USER MESSAGE
fprintf('Step 1/2 (estimating regional FDR values) :  0%%');
tic;
StartTime = 0.0;
ShowPercentage = 0;

% CALCULATE REGIONAL FDR VALUES
% See Eq. 5 in Langers et al., NeuroImage 2007
[SortedMap, SortedIndex] = sort(Pmap(UnsortedIndex));
SortedIndex = UnsortedIndex(SortedIndex);
%[X, Y, Z] = ndgrid(Resolution(1)*(1:size(Pmap,1)), Resolution(2)*(1:size(Pmap,2)), Resolution(3)*(1:size(Pmap,3)));
X = pos_matrix(SortedIndex,1); Y = pos_matrix(SortedIndex,2); Z = pos_matrix(SortedIndex,3);


for Voxel = 1:Ntotal
  SquaredDistance = (X-X(Voxel)).^2+(Y-Y(Voxel)).^2+(Z-Z(Voxel)).^2;
  Weights = CalculateWeights(SquaredDistance/(FWHMregion/2.0)^2, Shape);
  CumulativeWeights = cumsum(Weights);
  FDRmap(SortedIndex(Voxel)) = min(SortedMap(Voxel:Ntotal)./max(CumulativeWeights(Voxel:Ntotal), eps))*CumulativeWeights(Ntotal);
  if (ShowPercentage ~= floor(Voxel/Ntotal*10000.0))
    ShowPercentage = floor(Voxel/Ntotal*10000.0);
    fprintf('\b\b\b\b\b\b%5.2f%%',ShowPercentage/100);
  end
end

% USER MESSAGE
fprintf('\b\b\b\b finished in %.1f s.\n', toc-StartTime);
fprintf('Step 2/2 (estimating global FDR values)   :  0%%');
StartTime = toc;
ShowPercentage = 0;

% CALCULATE GLOBAL FDR VALUES
% See Eq. 10 in Langers et al., NeuroImage 2007
[SortedMap, SortedIndex] = sort(FDRmap(UnsortedIndex));
SortedIndex = UnsortedIndex(SortedIndex);
%[X, Y, Z] = ndgrid(Resolution(1)*(1:size(FDRmap,1)), Resolution(2)*(1:size(FDRmap,2)), Resolution(3)*(1:size(FDRmap,3)));
X = pos_matrix(SortedIndex,1); Y = pos_matrix(SortedIndex,2); Z = pos_matrix(SortedIndex,3);
for Voxel = 1:Ntotal
  SquaredDistance = (X-X(Voxel)).^2+(Y-Y(Voxel)).^2+(Z-Z(Voxel)).^2;
  Weights = CalculateWeights(SquaredDistance/(FWHMregion/2.0)^2, Shape);
  CumulativeWeights = cumsum(Weights);
  FalsePositiveSum = FalsePositiveSum+CumulativeWeights/CumulativeWeights(Ntotal);
  ReselSum = ReselSum+(0.5+0.5*sum(Weights(SquaredDistance <= (FWHMnoise/2.0)^2)))/CumulativeWeights(Ntotal);  
  if (ShowPercentage ~= floor(Voxel/Ntotal*100.0))
    ShowPercentage = floor(Voxel/Ntotal*100.0);
    fprintf('\b\b\b\b%3d%%',ShowPercentage);
  end
end

% USER MESSAGE
fprintf('\b\b\b\b finished in %.1f s.\n', toc-StartTime);

% CALCULATE FALSE DISCOVERY RATE THRESHOLD MAP
% Determine smallest FDR threshold for which a particular voxel can stil be considered active
FalsePositiveSum = SortedMap.*(ReselSum./(1.0-SortedMap)+FalsePositiveSum)./(1:Ntotal)';
FDRmap(SortedIndex(Ntotal)) = FalsePositiveSum(Ntotal);
for Voxel = (Ntotal-1):-1:1
  FDRmap(SortedIndex(Voxel)) = min(FDRmap(SortedIndex(Voxel+1)),FalsePositiveSum(Voxel));
end

% USER MESSAGE
fprintf('All calculations completed in %.1f s.\n', toc);



% SUB-ROUTINE TO CALCULATE UNIT-AMPLITUDE WEIGHTING FUNCTION
function [Weights] = CalculateWeights(NormalizedSquaredDistance, Shape);
switch Shape
  case 0; Weights = ones(size(NormalizedSquaredDistance));
  case 1; Weights = (NormalizedSquaredDistance <= 1.0);
  case 2; Weights = max(1.0-sqrt(NormalizedSquaredDistance)/2.0, 0.0);
  case 3; Weights = max(1.0-NormalizedSquaredDistance/2.0, 0.0);
  case 4; Weights = max(1.0-NormalizedSquaredDistance/(2.0+sqrt(2.0)), 0.0).^2;
  case 5; Weights = cos(min(sqrt(NormalizedSquaredDistance)*pi/3,pi/2));
  case 6; Weights = 0.5+0.5*cos(min(sqrt(NormalizedSquaredDistance)*pi/2,pi));
  case 7; Weights = 1.0./(1.0+NormalizedSquaredDistance);
  case 8; Weights = exp(-log(2.0)*sqrt(NormalizedSquaredDistance));
  case 9; Weights = exp(-log(2.0)*NormalizedSquaredDistance);
end