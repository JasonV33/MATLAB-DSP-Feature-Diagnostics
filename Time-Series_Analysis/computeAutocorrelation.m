function [lags, autocorrValues] = computeAutocorrelation(signal, fs, maxLagSec)
% computeAutocorrelation - Computes full-signal autocorrelation up to max lag.
%
% Inputs:
%   signal     : 1D mono audio signal
%   fs         : Sampling frequency (Hz)
%   maxLagSec  : Maximum lag (in seconds) to compute
%
% Outputs:
%   lags            : Lag values in seconds (X-axis)
%   autocorrValues  : Normalized autocorrelation values (Y-axis)
%
% Usage:
%   [lags, r] = computeAutocorrelation(signal, fs, 0.2);
%   plot(lags, r);

    % Ensure mono
    if size(signal, 2) > 1
        signal = mean(signal, 2);
    end

    % Normalize for stability
    signal = signal / max(abs(signal));

    % Compute autocorrelation
    maxLagSamples = round(maxLagSec * fs);
    r = xcorr(signal, maxLagSamples, 'coeff');

    % Convert lags from samples to seconds
    lagSamples = -maxLagSamples:maxLagSamples;
    lags = lagSamples / fs;

    % Output full symmetric autocorrelation
    autocorrValues = r;
end
