function [edges, edgeImage] = grdGetEdgeImage(img, op, T, T2, sigma)
    %{
        Performs an edge detection process onto img and returns the result

        [Args]
        img : Image
        op  : Edge detection operator: Sobel, Prewitt, Roberts, or Canny
        T   : Thresholding value

        [Output]
        edge        : Detected edge from img
        edgeImage   : Binary image containing edge for img
    %}

    % Cast to RGB
    img = rgb2gray(img);

    if (strcmp(op, 'Canny'))
        % Normalize threshold values to [0, 1]
        T = double(T) / 255;
        T2 = double(T2) / 255;
        
        % Performs edge detection with canny operator
        edges = edge(img, "canny", [T T2], sigma);

        % Fill three channels
        edgeImage = toGrayscale(im2uint8(edges));
    else
        % Get filter mask
        [Px, Py] = grdGetMask(op);
    
        % Fill three channels
        img = toGrayscale(img);

        % Performs edge detection
        Jx = convn(double(img), double(Px), 'same');
        Jy = convn(double(img), double(Py), 'same');
        Jedge = sqrt(Jx.^2 + Jy.^2); 

        edges = Jedge > T;
        edgeImage = im2uint8(uint8(Jedge) > T);
    end
end
