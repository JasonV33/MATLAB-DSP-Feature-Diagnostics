% =========================================================================
% File        : main_DSP_Feature_Diagnostics.m
% Product     : DSP-Feature-Diagnostics
% Author      : Jason Menard Vasallo
% Contact     : vasallojg@gmail.com
% Created on  : 2025-06-29
%
% Description :
% Main controller script for the DSP-Feature-Diagnostics tool.
% It enables and organizes the analysis and visualization of audio signals
% through modular techniques grouped into:
%   1. Time-Series Analysis
%   2. Frequency-Domain Analysis
%   3. Time-Frequency Analysis
%
% This script supports enabling/disabling each analysis group and their
% individual techniques. Outputs are visualized in separate figure windows
% per group. Each technique is implemented as a separate modular function.
%
% Usage :
%   - Set signal directory and toggle settings below.
%   - Run the script to generate plots for enabled modules.
%
% =========================================================================

% Load signal
signal_dir = "<insert_script>";
[audio, fs] = audioread(signal_dir);

% Settings
doTimeSeries = true;
doFrequency = true;
doTimeFrequency = true;
doStats = true;

% Time-Series Analysis Settings
doSignalEnvelop = true;
doShortTimeenergy = true;
doZeroCrossingRate = true;
doSignalStatistics = true;
doPitchTracking = true;
doAutocorrelation = true;

% Frequency-Domain Analysis Settings
doFFT = true;
doSpectralCentroid = true;
doSpectralBandwith = true;
doSpectralRolloff = true;
doSpectralFlatness = true;
doSpectralFlux = true;
doEnvelopeSpectrum = true;

% Time-Frequency Analysis Settings
doSTFTSpectogram = true;
doMelSpectogram = true;
doLogMelSpectogram = true;
doMFCC = true;
doDeltaMFCC = true;
doCWT = true;
doCQT = true;
doFormants = true;

window_count = sum(logical([doTimeSeries, doFrequency, doTimeFrequency, doStats]))
time_series_count = sum(logical([doSignalEnvelop, doShortTimeenergy, doZeroCrossingRate, doSignalStatistics, doPitchTracking, doAutocorrelation]));
frequency_domain_count = sum(logical([doFFT, doSpectralCentroid, doSpectralBandwith, doSpectralRolloff, doSpectralFlatness, doSpectralFlux, doEnvelopeSpectrum]));
time_frequency_count = doSTFTSpectogram + doMelSpectogram + doLogMelSpectogram + doMFCC + 2 * doDeltaMFCC + doCWT + doCQT + doFormants;




% === Time-Series Analysis ===
if doTimeSeries
    % Dynamically determine layout (e.g., 2 columns, N rows)
    nCols = 2;
    nRows = ceil(time_series_count / nCols);

    figure('Name', 'Time-Series Analysis', 'Color', 'w');
    tlo = tiledlayout(nRows, nCols);
    title(tlo, 'Time-Series Analysis');

    nexttile;
    t = (0:length(audio)-1)/fs;
    plot(t, audio / max(abs(audio)));  % Normalized waveform
    xlabel('Time (s)'); ylabel('Amplitude'); title('Audio Waveform'); grid minor;

    if doSignalEnvelop
        [t, hEnv, rmsEnv] = computeSignalEnvelope(audio, fs);
        nexttile;
        plot(t, hEnv, 'r'); hold on;
        plot(t, rmsEnv, 'g');
        title('Signal Envelope');
        xlabel('Time (s)'); ylabel('Amplitude'); grid minor; legend('Hilbert','RMS');
    end

    if doShortTimeenergy
        [tE, E] = computeShortTimeEnergy(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tE, E); title('Short-Time Energy');
        xlabel('Time (s)'); ylabel('Energy'); grid minor;
    end

    if doZeroCrossingRate
        [tZCR, zcr] = computeZCR(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tZCR, zcr); title('Zero-Crossing Rate');
        xlabel('Time (s)'); ylabel('Rate'); grid minor;
    end

    if doPitchTracking
        [tPitch, pitch] = estimatePitch(audio, fs, 0.03, 0.01, 50, 500);
        nexttile;
        plot(tPitch, pitch, 'm'); title('Pitch Tracking');
        xlabel('Time (s)'); ylabel('Hz'); ylim([0 600]); grid minor;
    end

    if doAutocorrelation
        [lags, acf] = computeAutocorrelation(audio, fs, 0.2);
        nexttile;
        plot(lags, acf); title('Autocorrelation');
        xlabel('Lag (s)'); ylabel('Correlation'); grid minor;
    end
end

% === Frequency-Domain Analysis ===
if doFrequency
    nCols = 2;
    nRows = ceil(frequency_domain_count / nCols);
    figure('Name', 'Frequency-Domain Analysis', 'Color', 'w');
    tlo = tiledlayout(nRows, nCols);
    title(tlo, 'Frequency-Domain Features');


    if doFFT
        [f, mag] = computeFFT(audio, fs);
        nexttile;
        plot(f, mag); title('FFT Magnitude');
        xlabel('Frequency (Hz)'); ylabel('Magnitude'); grid minor;
    end

    if doSpectralCentroid
        [tC, cHz] = computeSpectralCentroid(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tC, cHz); title('Spectral Centroid');
        xlabel('Time (s)'); ylabel('Hz'); grid minor;
    end

    if doSpectralBandwith
        [tBW, bw] = computeSpectralBandwidth(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tBW, bw); title('Spectral Bandwidth');
        xlabel('Time (s)'); ylabel('Hz'); grid minor;
    end

    if doSpectralRolloff
        [tRoll, roll] = computeSpectralRolloff(audio, fs, 0.02, 0.01, 0.85);
        nexttile;
        plot(tRoll, roll); title('Spectral Rolloff (85%)');
        xlabel('Time (s)'); ylabel('Hz'); grid minor;
    end

    if doSpectralFlatness
        [tFlat, flat] = computeSpectralFlatness(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tFlat, flat); title('Spectral Flatness');
        xlabel('Time (s)'); ylabel('Flatness'); grid minor;
    end

    if doSpectralFlux
        [tFlux, flux] = computeSpectralFlux(audio, fs, 0.02, 0.01);
        nexttile;
        plot(tFlux, flux); title('Spectral Flux');
        xlabel('Time (s)'); ylabel('Flux'); grid minor;
    end

    if doEnvelopeSpectrum
        [fEnv, magEnv] = computeEnvelopeSpectrum(audio, fs);
        nexttile;
        plot(fEnv, magEnv); title('Envelope Spectrum');
        xlabel('Modulation Freq (Hz)'); ylabel('Mag'); xlim([0 50]); grid minor;
    end
end

% === Time-Frequency Analysis ===
if doTimeFrequency
    nCols = 2;
    nRows = ceil(time_frequency_count / nCols);

    figure('Name', 'Time-Frequency Analysis', 'Color', 'w');
    tlo = tiledlayout(nRows, nCols);
    title(tlo, 'Time-Frequency Features');

    if doSTFTSpectogram
        nFFT = 1024;
        [S, fS, tS] = computeSpectrogramSTFT(audio, fs, 0.025, 0.01, nFFT);
        nexttile;
        imagesc(tS, fS, 20*log10(S + eps)); axis xy; colormap jet; colorbar;
        title('STFT Spectrogram'); xlabel('Time (s)'); ylabel('Hz');
    end

    if doMelSpectogram
        [S_mel, fMel, tMel] = computeMelSpectrogram(audio, fs, 0.025, 0.01, 40);
        nexttile;
        imagesc(tMel, fMel, 10*log10(S_mel + eps)); axis xy; colormap jet; colorbar;
        title('Mel Spectrogram'); xlabel('Time (s)'); ylabel('Hz');
    end

    if doLogMelSpectogram
        [S_logMel, fLogMel, tLogMel] = computeLogMelSpectrogram(audio, fs, 0.025, 0.01, 40);
        nexttile;
        imagesc(tLogMel, fLogMel, S_logMel); axis xy; colormap jet; colorbar;
        title('Log-Mel Spectrogram'); xlabel('Time (s)'); ylabel('Hz');
    end

    if doMFCC
        [mfccs, tMFCC] = computeMFCC(audio, fs, 0.025, 0.01, 13);
        nexttile;
        imagesc(tMFCC(:)', 1:13, squeeze(mfccs(:, :, 1))'); axis xy; colormap jet; colorbar;
        title('MFCCs'); xlabel('Time (s)'); ylabel('Coeff Index');
    end

    if doDeltaMFCC
        [mfccs, tMFCC] = computeMFCC(audio, fs, 0.025, 0.01, 13);
        [dMFCC, ddMFCC] = computeDeltaMFCC(mfccs);
        nexttile;
        imagesc(tMFCC(:)', 1:13, dMFCC'); axis xy; colormap jet; colorbar;
        title('Delta MFCCs'); xlabel('Time (s)'); ylabel('Coeff Index');

        nexttile;
        imagesc(tMFCC(:)', 1:13, dMFCC'); axis xy; colormap jet; colorbar;
        title('Delta-Delta MFCCs'); xlabel('Time (s)'); ylabel('Coeff Index');
    end

    if doCWT
        [cfs, fCWT, tCWT] = computeCWT(audio, fs);
        nexttile;
        imagesc(tCWT, fCWT, abs(cfs)); axis xy; colormap jet; colorbar;
        title('CWT Scalogram'); xlabel('Time (s)'); ylabel('Hz');
    end

    if doCQT
        [magCQT, fCQT, tCQT] = computeCQT(audio, fs);
        nexttile;
        imagesc(tCQT, fCQT, 20*log10(magCQT + eps)); axis xy; colormap jet; colorbar;
        title('CQT'); xlabel('Time (s)'); ylabel('Hz');
    end

    if doFormants
        [tF, formants] = computeFormantsLPC(audio, fs, 0.03, 0.01, 3);
        nexttile;
        plot(tF, formants, 'LineWidth', 1.2);
        title('Formants (LPC)'); xlabel('Time (s)'); ylabel('Hz');
        legend('F1','F2','F3'); grid minor;
    end
end

