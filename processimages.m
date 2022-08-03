names = dir("LabeledRawImages\*.psd");
counter = 1;
for i = 1:length(names)
    try
    filename = fullfile(names(i).folder,names(i).name);
    data = psdRead(filename);
    mask = data.layerImages{2};
    mask = mask(:,:,1);
    II = data.layerImages{1};
    R = II(:,:,1);
    G = II(:,:,2);
    B = II(:,:,3);
    luminance = 0.3*R+0.59*G+0.11*B;
    outputname = [num2str(counter),'.png'];
    imwrite(luminance, fullfile("Image/",outputname));
    imwrite(mask, fullfile("Mask/",outputname));
    counter = counter+1;
    catch
    end
end