function [Z, W] = Pupil_Shift(Wvl, LED_NA_x, LED_NA_y, Dim1, Dim1_kw)
    FreqStep_x = LED_NA_x.*(2*pi/Wvl); % x axis Pupil shifts in cycles
    FreqStep_y = LED_NA_y.*(2*pi/Wvl); % y axis Pupil shifts in cycles
    Z = round(FreqStep_x.*(Dim1/Dim1_kw));            % x axis pupil shifts in pixels
    W = round(FreqStep_y.*(Dim1/Dim1_kw));            % y axis pupil shifts in pixels
end