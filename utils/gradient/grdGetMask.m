function [Px, Py] = grdGetMask(op)
    %{
        Returns mask filter according to edge detection operator

        [Args]
        op  : Edge detection operator: Sobel, Prewitt, or Roberts

        [Output]
        Px  : Mask for x axis
        Py  : Mask for y axis
    %}
    switch (op)
        case 'Sobel'
            Px = [-1  0  1; 
                  -2  0  2; 
                  -1  0  1];
            Py = [1   2  1;
                  0   0  0; 
                  -1 -2 -1];
        case 'Prewitt'
            Px = [-1  0  1; 
                  -1  0  1; 
                  -1  0  1];
            Py = [1  1  1; 
                  0  0  0; 
                  -1 -1 -1];
        case 'Roberts'
            Px = [1  0;
                  0 -1];
            Py = [0  1;
                 -1  0];
        otherwise
            Px = [];
            Py = [];
    end

end
