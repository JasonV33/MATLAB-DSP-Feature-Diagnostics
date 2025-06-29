function stats = computeSignalStatistics(signal)
% computeSignalStatistics - Computes core statistical features of a signal.
%
% Inputs:
%   signal : 1D mono audio signal
%
% Outputs:
%   stats  : Struct containing the following fields:
%       - RMS
%       - Variance
%       - Skewness
%       - Kurtosis
%       - Entropy
%
% Usage:
%   stats = computeSignalStatistics(signal);
%   disp(stats.RMS);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Normalize signal to avoid numerical issues in entropy
    signal = signal / max(abs(signal));

    % RMS
    stats.RMS = sqrt(mean(signal.^2));

    % Variance
    stats.Variance = var(signal);

    % Skewness
    stats.Skewness = skewness(signal);

    % Kurtosis
    stats.Kurtosis = kurtosis(signal);

    % Entropy (Shannon entropy from normalized histogram)
    nBins = 100;
    [p, ~] = histcounts(signal, nBins, 'Normalization', 'probability');
    p(p == 0) = [];  % Remove zero entries to avoid log(0)
    stats.Entropy = -sum(p .* log2(p));
end
