function [threshold] = find_T(image,tt)
a = sort(image(:)); a1 = a(round(size(a(:))*tt));
threshold = median(nonzeros(a1));
end
