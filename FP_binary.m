
PupPha = Apert;
IC_Array_n = IC_Array;
max_I = max(max(max(IC_Array_n)));
IC_temp_re = IC_Array_n./max_I;
T_cut = 0.5;
b = 0.5 ;
tt = 0.9;
for  k = 1:numim
    [threshold_pixel(k)] = find_T(IC_temp_re(:,:,k),tt);
    expo = T_cut./threshold_pixel;
    tIbin_samethre_max(:,:,k) = (IC_temp_re(:,:,k)*expo(k) >= T_cut);
    IC_binary(:,:,k) = tIbin_samethre_max(:,:,k)*((1+T_cut)/2)+(1-tIbin_samethre_max(:,:,k))*(T_cut/2);
end
 
IC_Array_half6 = IC_binary;
SampI_FT_p_half6 = padarray(I_FT(IC_binary(:,:,1)),[(Dim2-Dim1)/2 (Dim2-Dim1)/2],0);
[SampI_bin_half6,PupPha_prior,num_half_ratio6] = QuantizedFP_Binary(T_cut,expo,itern,LED_st,LED_en,Fil_PS,Dim1,Dim2,SampI_FT_p_half6,PupPha,IC_Array_half6,F_FT,I_FT);
PupPha = (abs(PupPha)>0).*exp(1i*angle(PupPha));
figure(98); subplot(1,2,1);imagesc(fliplr(abs(SampI_bin_half6)/max(max(abs(SampI_bin_half6))))); axis image; colormap gray; title(['Reconstructed Amplitude']);pause(0.01);
figure(98); subplot(1,2,2);imagesc(fliplr(angle(SampI_bin_half6))); axis image; colormap gray; title(['Reconstructed Phase']);pause(0.2);