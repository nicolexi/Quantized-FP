function [Apert, Dim1_w2] = F_Pupil(Det_PS, Mag, Wvl, NA, Dim1)
    Img_PS = Det_PS/Mag;
    Dim1_w2 = (2*pi)/Img_PS;                                                    % Fourier plane width in cycles
    Rad2 = (2*pi*NA)/Wvl;                                                       % Radius of the pupil aperture in cycles
    R_Pix2 = (Dim1/Dim1_w2)*Rad2;                                               % Radius of the pupil aperture in pixels
    [Fr_X, Fr_Y] = meshgrid(-Dim1_w2/2:Dim1_w2/(Dim1-1):Dim1_w2/2,-Dim1_w2/2:Dim1_w2/(Dim1-1):Dim1_w2/2);
    Apert = abs(sqrt(Fr_X.^2+Fr_Y.^2)<=Rad2);
    disp(['Fraunhofer pupil radius in pixels: ' num2str(R_Pix2)]);
end