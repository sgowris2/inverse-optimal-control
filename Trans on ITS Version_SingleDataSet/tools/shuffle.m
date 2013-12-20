function a = shuffle(a)

length = numel(a);

for i = 1:length
    swapto = randi(length,1,1);
    temp = a(swapto);
    a(swapto) = a(i);
    a(i) = temp;
end