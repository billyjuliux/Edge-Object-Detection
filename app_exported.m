classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        TabGroup                     matlab.ui.container.TabGroup
        GradientTab                  matlab.ui.container.Tab
        GradientSigmaField           matlab.ui.control.NumericEditField
        GradientSigmaLabel           matlab.ui.control.Label
        GradientT2Field              matlab.ui.control.NumericEditField
        GradientT2Label              matlab.ui.control.Label
        GradientTLabel               matlab.ui.control.Label
        GradientComputeButton        matlab.ui.control.Button
        GradientTField               matlab.ui.control.NumericEditField
        SegmentationResultPanel      matlab.ui.container.Panel
        GridLayout3_5                matlab.ui.container.GridLayout
        GradientSegmentationImage    matlab.ui.control.Image
        GradientOperatorDropDown     matlab.ui.control.DropDown
        OperatorDropDownLabel        matlab.ui.control.Label
        EdgeDetectionResultPanel     matlab.ui.container.Panel
        GridLayout3_4                matlab.ui.container.GridLayout
        GradientEdgeDetectionImage   matlab.ui.control.Image
        OriginalImagePanel           matlab.ui.container.Panel
        GridLayout4_4                matlab.ui.container.GridLayout
        GradientOriginalImage        matlab.ui.control.Image
        GradientBrowseButton         matlab.ui.control.Button
        LaplacianTab                 matlab.ui.container.Tab
        LaplacianComputeButton       matlab.ui.control.Button
        LaplacianSigmaLabel          matlab.ui.control.Label
        LaplacianSigmaField          matlab.ui.control.NumericEditField
        LaplacianThresholdLabel      matlab.ui.control.Label
        LaplacianThresholdField      matlab.ui.control.NumericEditField
        LaplacianOperatorDropDown    matlab.ui.control.DropDown
        OperatorDropDownLabel_2      matlab.ui.control.Label
        LaplacianBrowseButton        matlab.ui.control.Button
        SegmentationResultLabel      matlab.ui.control.Label
        EdgedetectionResultLabel     matlab.ui.control.Label
        OriginalImageLabel           matlab.ui.control.Label
        LaplacianMethodLabel         matlab.ui.control.Label
        LaplacianSegmentationImage   matlab.ui.control.Image
        LaplacianEdgeDetectionImage  matlab.ui.control.Image
        LaplacianOriginalImage       matlab.ui.control.Image
    end

    
    properties (Access = private)
        img % Description
        tab = 'gradient' % Description
    end
    
    methods (Access = private)

        function generateTabContent(app)
            if isempty(app.img)
                return
            end

            switch app.tab
                case 'gradient'
                    app.generateGradientTab();
                case 'laplacian'
                    app.generateLaplacianTab();
            end
        end

        function generateGradientTab(app)
            if isempty(app.img)
                return
            end
            
            % Edge detection
            op = app.GradientOperatorDropDown.Value;
            T = app.GradientTField.Value;
            T2 = app.GradientT2Field.Value;
            sigma = app.GradientSigmaField.Value;
            [edges, edgeImage] = grdGetEdgeImage(app.img, op, T, T2, sigma); 

            app.GradientEdgeDetectionImage.ImageSource = edgeImage;

            % Image segmentation
            segmentedImage = getSegmentedImage(app.img, edges);
            app.GradientSegmentationImage.ImageSource = segmentedImage;
        end

        function generateLaplacianTab(app)
            if isempty(app.img)
                return
            end
            
            % Laplacian Method
            % Edge detection
            op = app.LaplacianOperatorDropDown.Value;
            T = app.LaplacianThresholdField.Value;
            sigma = app.LaplacianSigmaField.Value;
            [edges, edgeImage] = lpcGetEdgeImage(app.img, op, T, sigma);
            
            % Display Edge-detection result
            app.LaplacianEdgeDetectionImage.ImageSource = edgeImage;
            
            % Image segmentation
            segmentedImage = getSegmentedImage(app.img, edges);
            app.LaplacianSegmentationImage.ImageSource = segmentedImage;
        end
        
      
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button down function: GradientTab
        function GradientTabButtonDown(app, event)
            app.tab = 'gradient';
            app.img = app.GradientOriginalImage.ImageSource;
            app.generateTabContent();
        end

        % Button pushed function: GradientBrowseButton
        function GradientBrowseButtonPushed(app, event)
            extensions = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [filename, path] = uigetfile(extensions, 'Open file');

            if (isequal(filename, 0))
                return
            end

            image = imread(fullfile(path, filename));
            app.GradientOriginalImage.ImageSource = image;
            
            app.img = image;
            app.generateTabContent();
        end

        % Value changed function: GradientOperatorDropDown
        function GradientDropDownOnChanged(app, event)
            value = app.GradientOperatorDropDown.Value;
            
            if (strcmp(value, "Canny"))
                app.GradientT2Label.Visible = "on";
                app.GradientT2Field.Visible = "on";

                app.GradientSigmaLabel.Visible = "on";
                app.GradientSigmaField.Visible = "on";
            else
                app.GradientT2Label.Visible = "off";
                app.GradientT2Field.Visible = "off";

                app.GradientSigmaLabel.Visible = "off";
                app.GradientSigmaField.Visible = "off";
            end
        end

        % Button down function: LaplacianTab
        function LaplacianTabButtonDown(app, event)
            app.tab = 'laplacian';
            app.img = app.LaplacianOriginalImage.ImageSource;
            app.generateTabContent();
        end

        % Button pushed function: GradientComputeButton, 
        % ...and 1 other component
        function ComputeButtonPushed(app, event)
            app.generateTabContent();
        end

        % Button pushed function: LaplacianBrowseButton
        function LaplacianBrowseButtonPushed(app, event)
            extensions = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [filename, path] = uigetfile(extensions, 'Open file');

            if (isequal(filename, 0))
                return
            end

            image = imread(fullfile(path, filename));
            app.LaplacianOriginalImage.ImageSource = image;
            
            app.img = image;
            app.generateTabContent();
        end

        % Value changed function: LaplacianOperatorDropDown
        function LaplacianOperatorDropDownValueChanged(app, event)
value = app.LaplacianOperatorDropDown.Value;

        end

        % Value changed function: LaplacianThresholdField
        function LaplacianThresholdFieldValueChanged(app, event)
value = app.LaplacianThresholdField.Value;

        end

        % Value changed function: LaplacianSigmaField
        function LaplacianSigmaFieldValueChanged(app, event)
value = app.LaplacianSigmaField.Value;

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 711 598];
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create GradientTab
            app.GradientTab = uitab(app.TabGroup);
            app.GradientTab.Title = 'Gradient';
            app.GradientTab.ButtonDownFcn = createCallbackFcn(app, @GradientTabButtonDown, true);

            % Create OriginalImagePanel
            app.OriginalImagePanel = uipanel(app.GradientTab);
            app.OriginalImagePanel.Title = 'Original Image';
            app.OriginalImagePanel.Position = [24 245 194 299];

            % Create GridLayout4_4
            app.GridLayout4_4 = uigridlayout(app.OriginalImagePanel);
            app.GridLayout4_4.ColumnWidth = {'1x'};
            app.GridLayout4_4.RowHeight = {'1x', 'fit'};

            % Create GradientBrowseButton
            app.GradientBrowseButton = uibutton(app.GridLayout4_4, 'push');
            app.GradientBrowseButton.ButtonPushedFcn = createCallbackFcn(app, @GradientBrowseButtonPushed, true);
            app.GradientBrowseButton.Layout.Row = 2;
            app.GradientBrowseButton.Layout.Column = 1;
            app.GradientBrowseButton.Text = 'Browse';

            % Create GradientOriginalImage
            app.GradientOriginalImage = uiimage(app.GridLayout4_4);
            app.GradientOriginalImage.Layout.Row = 1;
            app.GradientOriginalImage.Layout.Column = 1;

            % Create EdgeDetectionResultPanel
            app.EdgeDetectionResultPanel = uipanel(app.GradientTab);
            app.EdgeDetectionResultPanel.Title = 'Edge Detection Result';
            app.EdgeDetectionResultPanel.Position = [238 245 212 299];

            % Create GridLayout3_4
            app.GridLayout3_4 = uigridlayout(app.EdgeDetectionResultPanel);
            app.GridLayout3_4.ColumnWidth = {'1x'};
            app.GridLayout3_4.RowHeight = {'1x'};

            % Create GradientEdgeDetectionImage
            app.GradientEdgeDetectionImage = uiimage(app.GridLayout3_4);
            app.GradientEdgeDetectionImage.Layout.Row = 1;
            app.GradientEdgeDetectionImage.Layout.Column = 1;

            % Create OperatorDropDownLabel
            app.OperatorDropDownLabel = uilabel(app.GradientTab);
            app.OperatorDropDownLabel.HorizontalAlignment = 'right';
            app.OperatorDropDownLabel.Position = [237 184 53 22];
            app.OperatorDropDownLabel.Text = 'Operator';

            % Create GradientOperatorDropDown
            app.GradientOperatorDropDown = uidropdown(app.GradientTab);
            app.GradientOperatorDropDown.Items = {'Sobel', 'Roberts', 'Prewitt', 'Canny'};
            app.GradientOperatorDropDown.ValueChangedFcn = createCallbackFcn(app, @GradientDropDownOnChanged, true);
            app.GradientOperatorDropDown.Position = [327 184 100 22];
            app.GradientOperatorDropDown.Value = 'Sobel';

            % Create SegmentationResultPanel
            app.SegmentationResultPanel = uipanel(app.GradientTab);
            app.SegmentationResultPanel.Title = 'Segmentation Result';
            app.SegmentationResultPanel.Position = [469 245 212 299];

            % Create GridLayout3_5
            app.GridLayout3_5 = uigridlayout(app.SegmentationResultPanel);
            app.GridLayout3_5.ColumnWidth = {'1x'};
            app.GridLayout3_5.RowHeight = {'1x'};

            % Create GradientSegmentationImage
            app.GradientSegmentationImage = uiimage(app.GridLayout3_5);
            app.GradientSegmentationImage.Layout.Row = 1;
            app.GradientSegmentationImage.Layout.Column = 1;

            % Create GradientTField
            app.GradientTField = uieditfield(app.GradientTab, 'numeric');
            app.GradientTField.Limits = [0 255];
            app.GradientTField.Position = [298 141 170 22];
            app.GradientTField.Value = 30;

            % Create GradientComputeButton
            app.GradientComputeButton = uibutton(app.GradientTab, 'push');
            app.GradientComputeButton.ButtonPushedFcn = createCallbackFcn(app, @ComputeButtonPushed, true);
            app.GradientComputeButton.Position = [300 36 100 22];
            app.GradientComputeButton.Text = 'Compute';

            % Create GradientTLabel
            app.GradientTLabel = uilabel(app.GradientTab);
            app.GradientTLabel.Position = [224 141 25 22];
            app.GradientTLabel.Text = 'T';

            % Create GradientT2Label
            app.GradientT2Label = uilabel(app.GradientTab);
            app.GradientT2Label.Visible = 'off';
            app.GradientT2Label.Position = [224 108 25 22];
            app.GradientT2Label.Text = 'T2';

            % Create GradientT2Field
            app.GradientT2Field = uieditfield(app.GradientTab, 'numeric');
            app.GradientT2Field.Limits = [0 255];
            app.GradientT2Field.Visible = 'off';
            app.GradientT2Field.Position = [299 108 170 22];
            app.GradientT2Field.Value = 80;

            % Create GradientSigmaLabel
            app.GradientSigmaLabel = uilabel(app.GradientTab);
            app.GradientSigmaLabel.Visible = 'off';
            app.GradientSigmaLabel.Position = [224 76 40 22];
            app.GradientSigmaLabel.Text = 'Sigma';

            % Create GradientSigmaField
            app.GradientSigmaField = uieditfield(app.GradientTab, 'numeric');
            app.GradientSigmaField.Visible = 'off';
            app.GradientSigmaField.Position = [299 76 170 22];
            app.GradientSigmaField.Value = 1.5;

            % Create LaplacianTab
            app.LaplacianTab = uitab(app.TabGroup);
            app.LaplacianTab.Title = 'Laplacian';
            app.LaplacianTab.ButtonDownFcn = createCallbackFcn(app, @LaplacianTabButtonDown, true);

            % Create LaplacianOriginalImage
            app.LaplacianOriginalImage = uiimage(app.LaplacianTab);
            app.LaplacianOriginalImage.Position = [79 221 235 228];

            % Create LaplacianEdgeDetectionImage
            app.LaplacianEdgeDetectionImage = uiimage(app.LaplacianTab);
            app.LaplacianEdgeDetectionImage.Position = [382 275 279 257];

            % Create LaplacianSegmentationImage
            app.LaplacianSegmentationImage = uiimage(app.LaplacianTab);
            app.LaplacianSegmentationImage.Position = [392 0 259 256];

            % Create LaplacianMethodLabel
            app.LaplacianMethodLabel = uilabel(app.LaplacianTab);
            app.LaplacianMethodLabel.HorizontalAlignment = 'center';
            app.LaplacianMethodLabel.FontSize = 30;
            app.LaplacianMethodLabel.FontWeight = 'bold';
            app.LaplacianMethodLabel.Position = [68 486 261 37];
            app.LaplacianMethodLabel.Text = 'Laplacian Method';

            % Create OriginalImageLabel
            app.OriginalImageLabel = uilabel(app.LaplacianTab);
            app.OriginalImageLabel.HorizontalAlignment = 'center';
            app.OriginalImageLabel.FontWeight = 'bold';
            app.OriginalImageLabel.Position = [154 451 89 22];
            app.OriginalImageLabel.Text = 'Original Image';

            % Create EdgedetectionResultLabel
            app.EdgedetectionResultLabel = uilabel(app.LaplacianTab);
            app.EdgedetectionResultLabel.HorizontalAlignment = 'center';
            app.EdgedetectionResultLabel.FontWeight = 'bold';
            app.EdgedetectionResultLabel.Position = [452 531 132 22];
            app.EdgedetectionResultLabel.Text = 'Edge-detection Result';

            % Create SegmentationResultLabel
            app.SegmentationResultLabel = uilabel(app.LaplacianTab);
            app.SegmentationResultLabel.HorizontalAlignment = 'center';
            app.SegmentationResultLabel.FontWeight = 'bold';
            app.SegmentationResultLabel.Position = [459 255 125 22];
            app.SegmentationResultLabel.Text = 'Segmentation Result';

            % Create LaplacianBrowseButton
            app.LaplacianBrowseButton = uibutton(app.LaplacianTab, 'push');
            app.LaplacianBrowseButton.ButtonPushedFcn = createCallbackFcn(app, @LaplacianBrowseButtonPushed, true);
            app.LaplacianBrowseButton.Position = [113 186 172 25];
            app.LaplacianBrowseButton.Text = 'Browse';

            % Create OperatorDropDownLabel_2
            app.OperatorDropDownLabel_2 = uilabel(app.LaplacianTab);
            app.OperatorDropDownLabel_2.HorizontalAlignment = 'center';
            app.OperatorDropDownLabel_2.FontWeight = 'bold';
            app.OperatorDropDownLabel_2.Position = [79 143 77 22];
            app.OperatorDropDownLabel_2.Text = 'Operator';

            % Create LaplacianOperatorDropDown
            app.LaplacianOperatorDropDown = uidropdown(app.LaplacianTab);
            app.LaplacianOperatorDropDown.Items = {'Laplacian Normal', 'Laplacian Diagonal', 'LoG'};
            app.LaplacianOperatorDropDown.ValueChangedFcn = createCallbackFcn(app, @LaplacianOperatorDropDownValueChanged, true);
            app.LaplacianOperatorDropDown.Position = [163 143 143 22];
            app.LaplacianOperatorDropDown.Value = 'Laplacian Normal';

            % Create LaplacianThresholdField
            app.LaplacianThresholdField = uieditfield(app.LaplacianTab, 'numeric');
            app.LaplacianThresholdField.Limits = [0 255];
            app.LaplacianThresholdField.ValueChangedFcn = createCallbackFcn(app, @LaplacianThresholdFieldValueChanged, true);
            app.LaplacianThresholdField.Position = [163 108 143 22];
            app.LaplacianThresholdField.Value = 30;

            % Create LaplacianThresholdLabel
            app.LaplacianThresholdLabel = uilabel(app.LaplacianTab);
            app.LaplacianThresholdLabel.HorizontalAlignment = 'center';
            app.LaplacianThresholdLabel.FontWeight = 'bold';
            app.LaplacianThresholdLabel.Position = [86 108 64 22];
            app.LaplacianThresholdLabel.Text = 'Threshold';

            % Create LaplacianSigmaField
            app.LaplacianSigmaField = uieditfield(app.LaplacianTab, 'numeric');
            app.LaplacianSigmaField.Limits = [0 255];
            app.LaplacianSigmaField.ValueChangedFcn = createCallbackFcn(app, @LaplacianSigmaFieldValueChanged, true);
            app.LaplacianSigmaField.Position = [163 74 143 22];
            app.LaplacianSigmaField.Value = 30;

            % Create LaplacianSigmaLabel
            app.LaplacianSigmaLabel = uilabel(app.LaplacianTab);
            app.LaplacianSigmaLabel.HorizontalAlignment = 'center';
            app.LaplacianSigmaLabel.FontWeight = 'bold';
            app.LaplacianSigmaLabel.Position = [97 74 42 22];
            app.LaplacianSigmaLabel.Text = 'Sigma';

            % Create LaplacianComputeButton
            app.LaplacianComputeButton = uibutton(app.LaplacianTab, 'push');
            app.LaplacianComputeButton.ButtonPushedFcn = createCallbackFcn(app, @ComputeButtonPushed, true);
            app.LaplacianComputeButton.Position = [149 35 100 22];
            app.LaplacianComputeButton.Text = 'Compute';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end