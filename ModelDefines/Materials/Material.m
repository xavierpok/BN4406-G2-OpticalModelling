classdef Material
    % Material
    % Class representing material properties
    
    properties
        %% NAME %%
        name = 'DEFAULT'; % Name of the material
        
        %% OPTICAL PROPERTIES %%
        mua = 1e-8; % Absorption coefficient [cm^-1]
        mus = 1e-8; % Scattering coefficient [cm^-1]
        g = 1; % Henyey-Greenstein scattering anisotropy
        n = 1; % Refractive index
        
        %% ACOUSTIC PROPERTIES %%
        sound_speed = 346; % Speed of sound in medium [m/s]
        density = 1.293; % Density of medium [kg/m^3]
    end
    
    methods
        function obj = Material(name, mua, mus, g, n, sound_speed, density)
            % Material Constructor
            % obj = Material(name, mua, mus, g, n, sound_speed, density)
            %
            % Constructs an instance of the Material class with specified properties.
            % 
            % Parameters:
            %   - name: Name of the material (default: 'DEFAULT')
            %   - mua: Absorption coefficient [cm^-1] (default: 1e-8)
            %   - mus: Scattering coefficient [cm^-1] (default: 1e-8)
            %   - g: Henyey-Greenstein scattering anisotropy (default: 1)
            %   - n: Refractive index (default: 1)
            %   - sound_speed: Speed of sound in medium [m/s] (default: 346)
            %   - density: Density of medium [kg/m^3] (default: 1.293)
            
            if exist('name', 'var')
                obj.name = name;
            end
            if exist('mua', 'var')
                obj.mua = mua;
            end
            if exist('mus', 'var')
                obj.mus = mus;
            end
            if exist('g', 'var')
                obj.g = g;
            end
            if exist('n', 'var')
                obj.n = n;
            end
            if exist('sound_speed', 'var')
                obj.sound_speed = sound_speed;
            end
            if exist('density', 'var')
                obj.density = density;
            end
        end
        
       
    end
end
