function RGrad = RGrad_2(x)

global r1Size;
global r2Size;

RGrad = zeros(size(x));

for i = 1:r1Size+r2Size
    RGrad(i) = 2*x(i);
end