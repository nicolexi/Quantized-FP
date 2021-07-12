IC_Array = IC_Array/max(max(max(IC_Array)))*5500;%*7.1429e+03;
PupPha = Apert;
temp_samp = IC_Array(:,:,1);
SampI = imresize(temp_samp,Imrf);
initial_center = sqrt(IC_Array(:,:,1)./expo_list(1));
SampI_FT_p = padarray(I_FT(initial_center),[(Dim2-Dim1)/2 (Dim2-Dim1)/2],0);
nn = 12; %12 bit
[SampI_new,PupPha] = QuantizedFP_diffbit(nn,Imrf,expo_list,itern,LED_st,LED_en,Le_dx,Le_dy,Fil_PS, Dim1,Dim2,SampI_FT_p,PupPha,IC_Array,F_FT,I_FT);
PupPha = (abs(PupPha)>0).*exp(1i*angle(PupPha));
figure(7); subplot(1,2,1);imagesc(fliplr(abs(rot90((SampI_new),0)))); axis image; colormap gray; title('Reconstructed Amplitude');pause(0.01);
figure(7); subplot(1,2,2);imagesc(fliplr(angle(rot90((SampI_new),0)))); axis image; colormap gray; title('Reconstructed Phase');pause(0.01);
PupPha12 = PupPha;


