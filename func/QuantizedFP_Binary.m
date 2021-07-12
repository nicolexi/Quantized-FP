%% function for Error-map based GS algorithm
% here optic axis is considered to be passing through the origin of XY plane
% This is for processing experimental data

function [SampI,PupPha,num_half_ratio] = QuantizedFP_Binary(T_cut,expo,itern,LED_st,LED_en,Fil_PS,Dim1,Dim2,SampI_FT,PupPha,IC_Array,F_FT,I_FT)

Apert = abs(PupPha)>0;
%%%%LED position
I_Crop = @(x,tx) x(((Dim2-Dim1)/2)+1-Fil_PS(2,tx): (Dim2+Dim1)/2-Fil_PS(2,tx),((Dim2-Dim1)/2)+1-Fil_PS(1,tx) : (Dim2+Dim1)/2 -Fil_PS(1,tx));
Indi = zeros(size(IC_Array));
I = SampI_FT;
for iter = 1:itern
    
    for t = LED_st:LED_en
        
        IC_ = I_Crop(I,t);
        % Apply the pupil function called Apert and PupPha and propagate to det
        
        IC = Apert.*PupPha.*IC_;    PR_temp1 = IC;
        IC = F_FT(IC);
        tIC = (abs(IC).^2)*expo(t); 
        tIbin = (tIC>=T_cut);
        num_half_ratio(t) = sum(sum(tIbin == 1))/(size(tIbin,1)*size(tIbin,2));
        tIC_bin = tIbin*((1+T_cut)/2)+(1-tIbin)*(T_cut/2);
        %error map
        Indi(:,:,t) = abs(tIC_bin-IC_Array(:,:,t))>0;
        
        ttIC = sqrt((IC_Array(:,:,t))/expo(t));
        
        ttIC_new = (abs(IC).*(1-Indi(:,:,t)))+(ttIC.*Indi(:,:,t));
        IC = abs(ttIC_new).*exp(1i*angle(IC));

        % Propagate back to the Fourier plane
        
        IC = I_FT(IC); PR_temp2 = IC;
        
        %-------------------------------------------------------------------------
        % Update the lens plane field and lens pupil function
        
        PR_temp3 = Apert.*(PR_temp2-PR_temp1);
        PR_Sn = IC_;
        PR_Pn = PupPha;
        
        PR_Sn1 = PR_Sn + 0.95^(iter-1) * (((abs(PR_Pn)./(max(max(abs(PR_Pn))))).*(conj(PR_Pn).*PR_temp3))./((((abs(PR_Pn)))).^2 + 1e-7));
        I(((Dim2-Dim1)/2)+1-Fil_PS(2,t) : (Dim2+Dim1)/2-Fil_PS(2,t),((Dim2-Dim1)/2)+1-Fil_PS(1,t) : (Dim2+Dim1)/2 -Fil_PS(1,t)) = PR_Sn1;
    end
    SampI_FT = I;
    SampI = F_FT(SampI_FT);
end
