% Variables for testing
% clc
% clear all
% impath = "E:\OneDrive - Institut Teknologi Bandung\AI Engineer\Edge-Object-Detection\images";
% img = imread(append(impath, "\avocado.jpg"));
% sigma = 1.5;
% T = 0.09;
% op = 'Laplacian Normal';
% [edges, edgeImage] = lpcGetEdgeImage1(img, op, T, sigma);

function [edges, edgeImage] = lpcGetEdgeImage(img, op, T, sigma)
%{
        Performs an edge detection process onto img and returns the result

        [Args]
        img     : Image
        op      : Edge detection operator: Laplacian Normal, Laplacian Diagonal, LoG
        T       : Thresholding value
        sigma   : Standard deviation for Gaussian Filter in LoG, a positive
        number

        [Output]
        edge        : Detected edge from img (1 channel image)
        edgeImage   : Binary image containing edge for img (3 channel
        image)
%}

% Cast to RGB
img = rgb2gray(img);


if (strcmp(op, 'LoG'))
    % Get filter mask 
    Gaussian_mask = lpcGetMask('Gaussian', sigma);
    Laplacian_mask = lpcGetMask('Laplacian Normal');

    % Apply convolution with Gaussian filter
    img = convn(double(img), double(Gaussian_mask), 'same');
    
else
    % Get filter mask
    Laplacian_mask = lpcGetMask(op);
end

% Apply convolution with Laplacian
edges = convn(double(img), double(Laplacian_mask), 'same');

% Apply thresholding
edges = im2uint8(uint8(edges) > T);

% Create edge-detected image
edgeImage = toGrayscale(im2uint8(edges));

end

