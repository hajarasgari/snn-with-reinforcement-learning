classdef ManySlotBuffer < handle
    % ManySlotBuffer - Is a buffer with nSlot slots.
    
    % Florian Raudies, 09/07/2014, Boston University.
    properties
        nSlot       % Number of slots.
        nEntry      % Number of maximum entries per slot.
        nData       % Number of dimensions for data.
        Counter     % Counter for each buffer.
        Buffer      % These are the buffers that hold the data.
    end
    methods
        % Constructor.
        function obj = ManySlotBuffer(nSlot,nEntry,nData)
            obj.nSlot       = nSlot;
            obj.nEntry      = nEntry;
            obj.nData       = nData;
            obj.Counter     = zeros(nSlot,1);
            obj.Buffer      = zeros(nSlot,nEntry,nData);
        end
        function obj = clear(obj)
            obj.Counter = zeros(obj.nSlot,1);
            obj.Buffer  = zeros(obj.nSlot,obj.nEntry,obj.nData);
        end
        function obj = addEntryToSlot(obj,iSlot,Data)
            obj.Counter(iSlot) = obj.Counter(iSlot) + 1;
            obj.Buffer(iSlot,obj.Counter(iSlot),1:numel(Data)) = Data;
        end
        function Data = getAllEntryForSlot(obj,iSlot)
            Data = squeeze(obj.Buffer(iSlot,1:obj.Counter(iSlot),:));            
        end
    end
end