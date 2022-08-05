names = dir("LabeledRawImages\*.psd");
counter = 1;
for i = 1:length(names)
    try
    filename = fullfile(names(i).folder,names(i).name);
    data = psdRead(filename);
    II = data.layerImages{1};
    if size(II,3) == 3 
        R = II(:,:,1);
        G = II(:,:,2);
        B = II(:,:,3);
        luminance = 0.3*R+0.59*G+0.11*B;
    elseif size(II,3) == 4
        luminance = II(:,:,4);
    else
        luminance = II;
    end
    IImask = luminance;
    IImask(:) = 255;

%    mask = data.layerImages{2};
%     mask = mask(:,:,1)*0.3 + mask(:,:,2)*0.59 + mask(:,:,3)*0.59;
%     mask = mask<0.5;
%     mask = uint8(double(mask)*255);

    maskfile = strrep(names(i).name,'.psd','.jpg');
    if i>=99
        maskfile = strrep(maskfile,'JV-LAB-0','JV-LAB-MASK-');
    else
        maskfile = strrep(maskfile,'JV-LAB-','JV-LAB-MASK-');
    end
    maskfile = fullfile("Jose Venegas Masks/",maskfile);
    mask = imread(maskfile);
    if size(mask,3)==1
    else
        mask = mask(:,:,3);
    end

    mask = double(mask);
    mask = mask-totmin(mask);
    mask = mask./totmax(mask);
    mask = mask.*255;
    mask = uint8(mask);
    bb = data.metadata.layersInformation.layer2.layerRecords.rectangle;
    if sum(bb) == 0
        bb = data.metadata.layersInformation.layer3.layerRecords.rectangle;
    end
    IImask(bb(1)+1:bb(3),bb(2)+1:bb(4)) = mask;

%     if max(mask(:)) < 0.5
%         mask = data.layerImages{3};
%         mask = mask(:,:,1)*0.3 + mask(:,:,2)*0.59 + mask(:,:,3)*0.59;
%         mask = mask>0.5;
%         mask = uint8(double(mask)*255);
%         bb = data.metadata.layersInformation.layer2.layerRecords.rectangle;
%         IImask(bb(1)+1:bb(3),bb(2)+1:bb(4)) = mask;
%     end

    outputname = strrep(names(i).name,'.psd','.png');
    imwrite(luminance, fullfile("Image/",outputname));
    imwrite(IImask, fullfile("Mask/",outputname));
    counter = counter+1;
    catch
    end
end