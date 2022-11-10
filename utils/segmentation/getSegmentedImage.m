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
        strel('line', 2, 0), ...
        strel('line', 2, 90), ...
    ]);

    % Fill the area closed by edges
    mask = imfill(mask, "holes");

    % Remove border objects
    mask = imclearborder(mask, 4);

    % Smoothen the objects, twice
    mask = imerode(mask, strel('diamond', 1));
    mask = imerode(mask, strel('diamond', 1));

    % Removes all connected objects with less than 1000 pixels
    mask = bwareaopen(mask, 1000);

    res = img .* uint8(mask);
end