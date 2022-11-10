function res = getSegmentedImage(img, edge)
    %{
        Performs image segmentation onto img based on passed edge

        [Args]
            img     : Image
            edge    : Detected edge from img
        [Output]
            res     : Segmented Image
    %}

    % Dilate the image
    mask = imdilate(edge, [ ...
        strel('line', 4, 0), ....
        strel('line', 4, 90), ...
        strel('line', 4, 135), ...
        strel('disk', 6), ...
    ]);

    % Fill the area closed by edges
    mask = imfill(mask, "holes");

    % Remove border objects
    mask = imclearborder(mask, 4);

    % Smoothen the objects
    mask = imerode(mask, strel('diamond', 15));

    % Removes all connected objects with less than 1000 pixels
    mask = bwareaopen(mask, 1000);

    res = img .* uint8(mask);
end