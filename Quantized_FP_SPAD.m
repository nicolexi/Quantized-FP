
%{
Author: Xi Yang
Last modified: 11-July-2021

-This algorithm is written based on the manuscript:
"Quantized Fourier ptychography with binary images
from SPAD cameras"

%}

Imrf = 6; % magnifiation
Dim1 = 32; % data size 
%% Function handlers
F_FT = @(x) fftshift(fft2(fftshift(x)));
I_FT = @(x) ifftshift(ifft2(ifftshift(x)));
%% load the calibrated values
load('..\SPAD\parameter.mat');
LED_D = 9;
Det_PS = 50e-6; %50um
%%
numim = LED_D^2;
itern = 100; %iteration time
[Apert, Dim1_kw] = Fori_Pupil(Det_PS, Mag_act, Wvl, NA_Act, Dim1);
[Fil_PS(2,:), Fil_PS(1,:)] = Pupil_Shift(Wvl, LED_NA_x, LED_NA_y, Dim1, Dim1_kw);
LED_st = 1; LED_en = 81; %begin LED number and end LED number
%Binary reconstruction
FP_binary()
%multi-bit depth reconstruction
FP_diffbit()

