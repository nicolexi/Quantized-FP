%% function for fresnel ptychography

% here optic axis is considered to be passing through the origin of XY
% plane
% This is for processing experimental multibit data

function [SampI,PupPha] =  QuantizedFP_diffbit(nn,Imrf,expo_list,itern,LED_st,LED_en,Le_dx,Le_dy,Fil_PS, Dim1,Dim2,SampI_FT,PupPha,IC_Array,F_FT,I_FT)
Fil_PS = -Fil_PS;
Le_dx = -Le_dx;
Le_dy = -Le_dy;
Apert = abs(PupPha)>0;
I_Crop = @(x,tx) x(((Dim2-Dim1)/2)+1-Fil_PS(2,tx)+2*Le_dx : (Dim2+Dim1)/2-Fil_PS(2,tx)+2*Le_dx,((Dim2-Dim1)/2)+1-Fil_PS(1,tx)+2*Le_dy : (Dim2+Dim1)/2 -Fil_PS(1,tx)+2*Le_dy);

I = SampI_FT; %estimated fourier domain
for iter = 1:itern
    
    for t = LED_st:LED_en
        
        IC_ = I_Crop(I,t);
        
        % Apply the pupil function called Apert and PupPha and propagate to det
        IC =  Apert.*PupPha.*IC_;    PR_temp1 = IC;
        IC = F_FT(IC);   %real space
        tIbin = round(((abs(IC).^2)*expo_list(t))* 2^(nn-1)); %tIbin = round(tIC/2^nn * 2^nn );
        a_test = ((abs(IC).^2)*expo_list(t))* 2^(nn-1);
        a_test(a_test>(2^nn-1)) = 2^nn-1;
        tIbin = round(a_test);
        %error map
        Indi = sign(tIbin-IC_Array(:,:,t));
        ttIC = IC_Array(:,:,t)/expo_list(t);
        ttIC_new_method = sqrt((Indi>0).*(ttIC) + (Indi<0).*(ttIC) );
        ttIC_new = (abs(IC).*(1-abs(Indi)))+(ttIC_new_method.*abs(Indi));
        
        IC = abs(ttIC_new).*exp(1i*angle(IC));
        
        % Propagate back to the Fourier plane
        
        IC = I_FT(IC); PR_temp2 = IC;
        
        %-------------------------------------------------------------------------
        % Update the lens plane field and lens pupil function
        
        PR_temp3 = Apert.*(PR_temp2-PR_temp1);
        PR_Sn = IC_;
        PR_Pn = PupPha;
        
        PR_Sn1 = PR_Sn + 0.95^(iter-1) * (((abs(PR_Pn)./(max(max(abs(PR_Pn))))).*(conj(PR_Pn).*PR_temp3))./((((abs(PR_Pn)))).^2 + 1e-7));
        if iter < 3
            PR_Pn1 = PR_Pn + 0.95^(iter-1) *  Apert.*(((abs(PR_Sn)./(max(max(abs(PR_Sn))))).*(conj(PR_Sn).*PR_temp3))./((((abs(PR_Sn)))).^2 + 5e-8));
            PupPha = Apert.*(PR_Pn1);
        end
        I(((Dim2-Dim1)/2)+1-Fil_PS(2,t) : (Dim2+Dim1)/2-Fil_PS(2,t),((Dim2-Dim1)/2)+1-Fil_PS(1,t) : (Dim2+Dim1)/2 -Fil_PS(1,t)) = PR_Sn1;
    end
    SampI_FT = I;
    SampI = F_FT(SampI_FT);   
end
