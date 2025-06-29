% =========================================================================
% File        : main_DSP_Feature_Diagnostics.m
% Product     : DSP-Feature-Diagnostics
% Author      : Jason Vasallo
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
signal_dir = "";

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
