function res = getSegmentedImage(img, edge)
    %{
        Performs image segmentation onto img based on passed edge

        [Args]
            img     : Image
            edge    : Detected edge from img
        [Output]
            res     : Segmented Image
    %}

    mask = imdilate(edge, [ ...
        strel('line', 3, 0), ...
        strel('line', 3, 45), ...
        strel('line', 3, 90), ...
        strel('line', 3, 135), ...
        strel('line', 3, 180), ...
    ]);

    mask = imfill(mask, 26, "holes");

    mask = bwareaopen(mask, 2000);

    res = img .* uint8(mask);
end