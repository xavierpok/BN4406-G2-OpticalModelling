classdef Model
    %MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        materialMatrix
        mcMatlabModel;
        nx = 0;
        ny = 0;
        nz = 0;
        Lx = 0;
        Ly = 0;
        Lz = 0;
    end
    
    methods
        

        
        function obj = simulateOptical(obj)
                        %% Geometry definition
            MCmatlab.closeMCmatlabFigures();
            obj.mcMatlabModel = MCmatlab.model;

            obj.mcMatlabModel.G.nx                = obj.nx; % Number of bins in the x direction
            obj.mcMatlabModel.G.ny                = obj.ny; % Number of bins in the y direction
            obj.mcMatlabModel.G.nz                = obj.nz; % Number of bins in the z direction
            obj.mcMatlabModel.G.Lx                = obj.Lx; % [cm] x size of simulation cuboid
            obj.mcMatlabModel.G.Ly                = obj.Ly; % [cm] y size of simulation cuboid
            obj.mcMatlabModel.G.Lz                = obj.Lz; % [cm] z size of simulation cuboid

            obj.mcMatlabModel.G.mediaPropertiesFunc = ...
                (@(parameters) obj.opticalMediaProperties(parameters));
            % Media properties defined as a function at the end of this file
            
            obj.mcMatlabModel.G.geomFunc = (@(x, y, z, parameters) ...
                obj.getOpticalMatrix); % Function to use for defining the distribution of media in the cuboid. Defined at the end of this m file.

            obj.mcMatlabModel = plot(obj.mcMatlabModel,'G');

            %% Monte Carlo simulation
            obj.mcMatlabModel.MC.simulationTimeRequested  = .1; % [min] Time duration of the simulation
            obj.mcMatlabModel.MC.matchedInterfaces        = true; % Assumes all refractive indices are the same
            obj.mcMatlabModel.MC.boundaryType             = 1; % 0: No escaping boundaries, 1: All cuboid boundaries are escaping, 2: Top cuboid boundary only is escaping, 3: Top and bottom boundaries are escaping, while the side boundaries are cyclic
            obj.mcMatlabModel.MC.wavelength               = 532; % [nm] Excitation wavelength, used for determination of optical properties for excitation light

            obj.mcMatlabModel.MC.lightSource.sourceType   = 0; % 0: Pencil beam, 1: Isotropically emitting line or point source, 2: Infinite plane wave, 3: Laguerre-Gaussian LG01 beam, 4: Radial-factorizable beam (e.g., a Gaussian beam), 5: X/Y factorizable beam (e.g., a rectangular LED emitter)

            % For a pencil beam, the "focus" is just a point that the beam goes
            % through, here set to be the center of the cuboid:
            obj.mcMatlabModel.MC.lightSource.xFocus       = 0; % [cm] x position of focus
            obj.mcMatlabModel.MC.lightSource.yFocus       = 0; % [cm] y position of focus
            obj.mcMatlabModel.MC.lightSource.zFocus       = ...
                obj.mcMatlabModel.G.Lz/2; % [cm] z position of focus

            obj.mcMatlabModel.MC.lightSource.theta        = 0; % [rad] Polar angle of beam center axis
            obj.mcMatlabModel.MC.lightSource.phi          = 0; % [rad] Azimuthal angle of beam center axis


            % These lines will run the Monte Carlo simulation with the provided
            % parameters and subsequently plot the results:
            obj.mcMatlabModel = runMonteCarlo(obj.mcMatlabModel);
            obj.mcMatlabModel = plot(obj.mcMatlabModel,'MC');

        end
        
        function mediaProperties = opticalMediaProperties(obj, parameters)
            % Always leave the following line in place to initialize the
            % mediaProperties array:
            mediaProperties = MCmatlab.mediumProperties;

            uniqueMaterials = unique(obj.materialMatrix);
            for idx = (1 : length(uniqueMaterials)) 
                mat = uniqueMaterials(idx);
                j = idx;
                mediaProperties(j).name = mat.name;
                mediaProperties(j).mua = mat.mua;
                mediaProperties(j).mus = mat.mus;
                mediaProperties(j).g = mat.g;
            end
        end
        

        function opticalMatrix = getOpticalMatrix(obj)
            uniqueMaterials = unique(obj.materialMatrix);
            opticalMatrix = zeros(size(obj.materialMatrix));
            for idx = (1 : length(uniqueMaterials)) 
                mat = uniqueMaterials(idx);
                uniqueMaterials(obj.materialMatrix == mat) = idx;
            end
        end

    end
end

