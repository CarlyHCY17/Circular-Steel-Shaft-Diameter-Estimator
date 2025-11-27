classdef Circular_Steel_Shaft_Diameter_Estimator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TextArea                        matlab.ui.control.TextArea
        TextAreaLabel                   matlab.ui.control.Label
        EstimatedDiameterinEditField    matlab.ui.control.NumericEditField
        EstimatedDiameterinEditFieldLabel  matlab.ui.control.Label
        SutkpsiEditField                matlab.ui.control.NumericEditField
        SutkpsiEditFieldLabel           matlab.ui.control.Label
        ANSWERButton                    matlab.ui.control.Button
        StepDiameterRatioDropDown       matlab.ui.control.DropDown
        StepDiameterRatioDropDownLabel  matlab.ui.control.Label
        ShoulderFilletDropDown          matlab.ui.control.DropDown
        ShoulderFilletDropDownLabel     matlab.ui.control.Label
        ReliabilityDropDown             matlab.ui.control.DropDown
        ReliabilityDropDownLabel        matlab.ui.control.Label
        TemperatureFEditField           matlab.ui.control.NumericEditField
        TemperatureFEditFieldLabel      matlab.ui.control.Label
        SurfaceFinishDropDown           matlab.ui.control.DropDown
        SurfaceFinishDropDownLabel      matlab.ui.control.Label
        MaximumBendinglbinEditField     matlab.ui.control.NumericEditField
        MaximumBendinglbinEditFieldLabel  matlab.ui.control.Label
        MinimumBendinglbinEditField     matlab.ui.control.NumericEditField
        MinimumBendinglbinEditFieldLabel  matlab.ui.control.Label
        MaximumTorquelbinEditField      matlab.ui.control.NumericEditField
        MaximumTorquelbinEditFieldLabel  matlab.ui.control.Label
        MinimumTorquelbinEditField      matlab.ui.control.NumericEditField
        MinimumTorquelbinEditFieldLabel  matlab.ui.control.Label
        FactorofSafetyEditField         matlab.ui.control.NumericEditField
        FactorofSafetyEditFieldLabel    matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ANSWERButton
        function ANSWERButtonPushed(app, event)
            n = app.FactorofSafetyEditField.Value;
            Sut= app.SutkpsiEditField.Value*10^3;
    Tmin=app.MinimumTorquelbinEditField.Value;
    Tmax=app.MaximumTorquelbinEditField.Value;
    Mmin=app.MinimumBendinglbinEditField.Value;
    Mmax=app.MaximumBendinglbinEditField.Value;
    Surface_Finishes= app.SurfaceFinishDropDown.Value;
    T=app.TemperatureFEditField.Value;
    percentage_choice= app.ReliabilityDropDown.Value;
    Shoulder_fillet=app.ShoulderFilletDropDown.Value;
    Dd =str2double(app.StepDiameterRatioDropDown.Value);
    [Ta,Tm]=Torque(Tmin,Tmax);
    [Ma,Mm]=Bending_moment(Mmin,Mmax);
    [ka]=Surface_finish(Surface_Finishes,Sut);
    [kd]= Temperature_Factor(T);
    [ke]=Reliability(percentage_choice);
    [kf,kfs]=Stepped_diameter(Dd,Shoulder_fillet);
    [Se_dash]=Se_dashed(Sut);
    kb=0.85;kc=1;
    Se=ka*kb*kc*kd*ke*kf*Se_dash;
   d = ( (16*n)/pi * ( ...
    ( 1/Se ) * sqrt(4*(kf*Ma).^2 + 3*(kfs*Ta).^2 ) + ...
    ( 1/Sut ) * sqrt(4*(kf*Mm).^2 + 3*(kfs*Tm).^2 ) ) )^(1/3);
    app.EstimatedDiameterinEditField.Value= d;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create FactorofSafetyEditFieldLabel
            app.FactorofSafetyEditFieldLabel = uilabel(app.UIFigure);
            app.FactorofSafetyEditFieldLabel.HorizontalAlignment = 'right';
            app.FactorofSafetyEditFieldLabel.Position = [26 383 90 22];
            app.FactorofSafetyEditFieldLabel.Text = 'Factor of Safety';

            % Create FactorofSafetyEditField
            app.FactorofSafetyEditField = uieditfield(app.UIFigure, 'numeric');
            app.FactorofSafetyEditField.Limits = [1.5 3];
            app.FactorofSafetyEditField.Position = [131 383 100 22];
            app.FactorofSafetyEditField.Value = 1.5;

            % Create MinimumTorquelbinEditFieldLabel
            app.MinimumTorquelbinEditFieldLabel = uilabel(app.UIFigure);
            app.MinimumTorquelbinEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumTorquelbinEditFieldLabel.Position = [26 344 127 22];
            app.MinimumTorquelbinEditFieldLabel.Text = 'Minimum Torque (lb.in)';

            % Create MinimumTorquelbinEditField
            app.MinimumTorquelbinEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinimumTorquelbinEditField.Position = [163 339 100 22];

            % Create MaximumTorquelbinEditFieldLabel
            app.MaximumTorquelbinEditFieldLabel = uilabel(app.UIFigure);
            app.MaximumTorquelbinEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumTorquelbinEditFieldLabel.Position = [26 301 130 22];
            app.MaximumTorquelbinEditFieldLabel.Text = 'Maximum Torque (lb.in)';

            % Create MaximumTorquelbinEditField
            app.MaximumTorquelbinEditField = uieditfield(app.UIFigure, 'numeric');
            app.MaximumTorquelbinEditField.Position = [164 296 100 22];

            % Create MinimumBendinglbinEditFieldLabel
            app.MinimumBendinglbinEditFieldLabel = uilabel(app.UIFigure);
            app.MinimumBendinglbinEditFieldLabel.HorizontalAlignment = 'right';
            app.MinimumBendinglbinEditFieldLabel.Position = [26 258 134 22];
            app.MinimumBendinglbinEditFieldLabel.Text = 'Minimum Bending (lb.in)';

            % Create MinimumBendinglbinEditField
            app.MinimumBendinglbinEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinimumBendinglbinEditField.Position = [170 253 100 22];

            % Create MaximumBendinglbinEditFieldLabel
            app.MaximumBendinglbinEditFieldLabel = uilabel(app.UIFigure);
            app.MaximumBendinglbinEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumBendinglbinEditFieldLabel.Position = [26 215 138 22];
            app.MaximumBendinglbinEditFieldLabel.Text = 'Maximum Bending (lb.in)';

            % Create MaximumBendinglbinEditField
            app.MaximumBendinglbinEditField = uieditfield(app.UIFigure, 'numeric');
            app.MaximumBendinglbinEditField.Position = [179 215 100 22];

            % Create SurfaceFinishDropDownLabel
            app.SurfaceFinishDropDownLabel = uilabel(app.UIFigure);
            app.SurfaceFinishDropDownLabel.HorizontalAlignment = 'right';
            app.SurfaceFinishDropDownLabel.Position = [26 139 82 22];
            app.SurfaceFinishDropDownLabel.Text = 'Surface Finish';

            % Create SurfaceFinishDropDown
            app.SurfaceFinishDropDown = uidropdown(app.UIFigure);
            app.SurfaceFinishDropDown.Items = {'ground', 'as-forged', 'machined', 'cold-drawn', 'hot-rolled'};
            app.SurfaceFinishDropDown.Position = [123 139 100 22];
            app.SurfaceFinishDropDown.Value = 'ground';

            % Create TemperatureFEditFieldLabel
            app.TemperatureFEditFieldLabel = uilabel(app.UIFigure);
            app.TemperatureFEditFieldLabel.HorizontalAlignment = 'right';
            app.TemperatureFEditFieldLabel.Position = [26 177 91 22];
            app.TemperatureFEditFieldLabel.Text = 'Temperature (F)';

            % Create TemperatureFEditField
            app.TemperatureFEditField = uieditfield(app.UIFigure, 'numeric');
            app.TemperatureFEditField.Position = [132 177 100 22];

            % Create ReliabilityDropDownLabel
            app.ReliabilityDropDownLabel = uilabel(app.UIFigure);
            app.ReliabilityDropDownLabel.HorizontalAlignment = 'right';
            app.ReliabilityDropDownLabel.Position = [26 101 56 22];
            app.ReliabilityDropDownLabel.Text = 'Reliability';

            % Create ReliabilityDropDown
            app.ReliabilityDropDown = uidropdown(app.UIFigure);
            app.ReliabilityDropDown.Items = {'50%', '90%', '95%', '99%', '99.9%', '99.99%', '99.999%', '99.9999%'};
            app.ReliabilityDropDown.Position = [97 101 100 22];
            app.ReliabilityDropDown.Value = '50%';

            % Create ShoulderFilletDropDownLabel
            app.ShoulderFilletDropDownLabel = uilabel(app.UIFigure);
            app.ShoulderFilletDropDownLabel.HorizontalAlignment = 'right';
            app.ShoulderFilletDropDownLabel.Position = [26 63 82 22];
            app.ShoulderFilletDropDownLabel.Text = 'Shoulder Fillet';

            % Create ShoulderFilletDropDown
            app.ShoulderFilletDropDown = uidropdown(app.UIFigure);
            app.ShoulderFilletDropDown.Items = {'sharp', 'well-rounded'};
            app.ShoulderFilletDropDown.Position = [123 63 100 22];
            app.ShoulderFilletDropDown.Value = 'sharp';

            % Create StepDiameterRatioDropDownLabel
            app.StepDiameterRatioDropDownLabel = uilabel(app.UIFigure);
            app.StepDiameterRatioDropDownLabel.HorizontalAlignment = 'right';
            app.StepDiameterRatioDropDownLabel.Position = [26 25 113 22];
            app.StepDiameterRatioDropDownLabel.Text = 'Step Diameter Ratio';

            % Create StepDiameterRatioDropDown
            app.StepDiameterRatioDropDown = uidropdown(app.UIFigure);
            app.StepDiameterRatioDropDown.Items = {'1.1', '1.15', '1.2', '1.25', '1.3', '1.33'};
            app.StepDiameterRatioDropDown.Position = [154 25 100 22];
            app.StepDiameterRatioDropDown.Value = '1.2';

            % Create ANSWERButton
            app.ANSWERButton = uibutton(app.UIFigure, 'push');
            app.ANSWERButton.ButtonPushedFcn = createCallbackFcn(app, @ANSWERButtonPushed, true);
            app.ANSWERButton.Position = [360 230 100 22];
            app.ANSWERButton.Text = 'ANSWER';

            % Create SutkpsiEditFieldLabel
            app.SutkpsiEditFieldLabel = uilabel(app.UIFigure);
            app.SutkpsiEditFieldLabel.HorizontalAlignment = 'right';
            app.SutkpsiEditFieldLabel.Position = [26 422 56 22];
            app.SutkpsiEditFieldLabel.Text = 'Sut (kpsi)';

            % Create SutkpsiEditField
            app.SutkpsiEditField = uieditfield(app.UIFigure, 'numeric');
            app.SutkpsiEditField.Limits = [0 Inf];
            app.SutkpsiEditField.Position = [97 422 100 22];

            % Create EstimatedDiameterinEditFieldLabel
            app.EstimatedDiameterinEditFieldLabel = uilabel(app.UIFigure);
            app.EstimatedDiameterinEditFieldLabel.HorizontalAlignment = 'right';
            app.EstimatedDiameterinEditFieldLabel.Position = [334 201 131 22];
            app.EstimatedDiameterinEditFieldLabel.Text = 'Estimated Diameter (in)';

            % Create EstimatedDiameterinEditField
            app.EstimatedDiameterinEditField = uieditfield(app.UIFigure, 'numeric');
            app.EstimatedDiameterinEditField.Limits = [0 Inf];
            app.EstimatedDiameterinEditField.Position = [480 201 100 22];

            % Create TextAreaLabel
            app.TextAreaLabel = uilabel(app.UIFigure);
            app.TextAreaLabel.HorizontalAlignment = 'right';
            app.TextAreaLabel.Position = [347 403 55 22];
            app.TextAreaLabel.Text = 'Text Area';

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.Position = [347 276 286 190];
            app.TextArea.Value = {'Hi Machinist! Here is a short user mannual on how to use this program to find and estimated diameter of a circular steel shaft. We shall be operating in freedom units. '; 'First, pick out the type of steel you want and enter its ultimate strength (Sut) in psi.'; 'Second, enter the maximum and minimum torque and bending that the shaft should endure.'; 'Third, enter the temperature the shaft shall be operating in in fahrenheit .'; 'Lastly, you may pick out the surface finish, reliability, shoulder fillet and step diamter ratio as you like. :)'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Circular_Steel_Shaft_Diameter_Estimator

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