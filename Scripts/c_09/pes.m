classdef pes
    properties
        Name
        Superpower='Nah��anie cudz�ch cyklistov.';
        Breed='Mie�anec';
        Owner='Nezn�my';
    end
    
    methods
        % Constructor function
        function obj=pes(varargin)
            if nargin==0
                obj.Name='Rexo';
            elseif nargin==1
                obj.Name=varargin{1};
            elseif nargin==2
                obj.Name=varargin{1};
                obj.Superpower=varargin{2};
            elseif nargin==3
                obj.Name=varargin{1};
                obj.Superpower=varargin{2};
                obj.Breed=varargin{3};
            else
                obj.Name=varargin{1};
                obj.Superpower=varargin{2};
                obj.Breed=varargin{3};
                obj.Owner=varargin{4};               
            end
        end
        
        function najdi_ovciaka(obj)
           zoznam_hodnot={'ovciak','ov�iak','ovcak','ov��k','shepherd'};
           if contains(lower(obj.Breed),zoznam_hodnot)
               spy;
               load handel;
               sound(y,Fs)
           else
               disp('Tento pes nie je ov�iak :(')
           end
        end
    end 
end