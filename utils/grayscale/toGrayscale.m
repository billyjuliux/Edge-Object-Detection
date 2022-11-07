function res = toGrayscale(img)
    %{
        Change RGB to grayscale by copying red image to green and blue

        [Args]
            img : Image
        [Output]
            res : Grayscaled image
    %}

    res = img;
    res(:, :, 2) = res(:, :, 1);
    res(:, :, 3) = res(:, :, 1);
end
