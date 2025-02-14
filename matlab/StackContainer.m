classdef StackContainer < handle
    % Stack container implements a stack with many slots and a maximum
    % number of entries per slot.
    
    % Florian Raudies, 09/07/2014, Boston University.
    properties
        nSlot       % Number of slots.
        nMaxEntry   % Number of maximum entries per slot.
        Counter     % Counter for each slot.
        Container   % These are the buffers that hold the data.
    end
    methods
        % Constructor.
        function obj = StackContainer(varargin)
            % nSlot, nMaxEntry
            if numel(varargin)==2,
                obj.nSlot       = varargin{1};
                obj.nMaxEntry   = varargin{2};
                obj.Counter     = zeros(obj.nSlot,1);
                obj.Container   = zeros(obj.nSlot,obj.nMaxEntry);
            else
                obj.nSlot       = 0;
                obj.nMaxEntry   = 0;
                obj.Counter     = 0;
                obj.Container   = 0;
            end                
        end
        % Does not work for object handles because it requires some sort of
        % recursion. Is also problematic if there are circular pointers
        % toward this object.
        function new = copy(obj)
            % Instantiate new object of the same class.
            new = feval(class(obj)); 
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end
        function e = numel(obj,iSlot)
            e = obj.Counter(iSlot);
        end
        function b = empty(obj,iSlot)
            b = obj.Counter(iSlot)==0;
        end
        function obj = push(obj,iSlot,data)
            if obj.Counter(iSlot)==obj.nMaxEntry,
                error('StackContainer:CapacityLimit','Full!');
            end
            obj.Counter(iSlot) = obj.Counter(iSlot) + 1;
            obj.Container(iSlot,obj.Counter(iSlot)) = data;
        end
        function data = pop(obj,iSlot)
            if obj.Counter(iSlot)==0,
                error('StackContainer:CapacityLimit','Empty!');
            end            
            data = obj.Container(iSlot,obj.Counter(iSlot));
            obj.Counter(iSlot) = obj.Counter(iSlot) - 1;
        end        
    end
end