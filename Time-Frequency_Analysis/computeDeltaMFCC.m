function [deltaMFCC, deltaDeltaMFCC] = computeDeltaMFCC(mfccMatrix)
% computeDeltaMFCC - Computes first and second derivatives (delta, delta-delta) of MFCCs
%
% Inputs:
%   mfccMatrix        : 3D matrix from mfcc() function (frames x coeffs x 1/3)
%
% Outputs:
%   deltaMFCC         : Delta coefficients
%   deltaDeltaMFCC    : Delta-delta coefficients

    % Extract static MFCCs
    if ndims(mfccMatrix) == 3
        staticMFCC = squeeze(mfccMatrix(:, :, 1));  % [frames x coeffs]
    else
        staticMFCC = mfccMatrix;
    end

    % Transpose to [coeffs x frames]
    staticMFCC = staticMFCC';

    % Define delta kernel (centered, ±2 context)
    deltaKernel = [-2 -1 0 1 2] / 10;

    % Apply convolution with padding
    padded = padarray(staticMFCC, [0, 2], 'replicate', 'both');
    deltaMFCC = conv2(padded, deltaKernel, 'valid');

    padded2 = padarray(deltaMFCC, [0, 2], 'replicate', 'both');
    deltaDeltaMFCC = conv2(padded2, deltaKernel, 'valid');

    % Transpose back to [frames x coeffs]
    deltaMFCC = deltaMFCC';
    deltaDeltaMFCC = deltaDeltaMFCC';
end


% Example Usage:
% if doDeltaMFCC
%     [mfccs, tMFCC] = computeMFCC(audio, fs, 0.025, 0.01, 13);
%     [deltaM, deltaDeltaM] = computeDeltaMFCC(mfccs);

%     figure('Name', 'Delta & Delta-Delta MFCCs', 'Color', 'w');

%     subplot(2,1,1);
%     imagesc(tMFCC, 1:13, deltaM'); axis xy;
%     title('Delta MFCCs (First Derivative)');
%     ylabel('Coefficient Index'); colormap jet; colorbar;

%     subplot(2,1,2);
%     imagesc(tMFCC, 1:13, deltaDeltaM'); axis xy;
%     title('Delta-Delta MFCCs (Second Derivative)');
%     xlabel('Time (s)'); ylabel('Coefficient Index');
%     colormap jet; colorbar;
% end
