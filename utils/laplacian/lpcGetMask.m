function mask = lpcGetMask(op, sigma)
    %{
        Returns mask filter according to edge detection operator

        [Args]
        op  : Edge detection operator: Laplacian Normal, Laplacian Diagonal, Gaussian

        [Output]
        mask  : Mask 
    %}
    switch (op)
        case 'Laplacian Normal'
            mask = [0 1 0;
                    1 -4 1;
                    0 1 0];
        case 'Laplacian Diagonal'
            mask = [1 1 1;
                    1 -8 1;
                    1 1 1];
        case 'Gaussian'
            mask = fspecial('gaussian', 3, sigma);
        otherwise
            mask = [];
    end

end
