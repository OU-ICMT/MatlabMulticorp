clear;
clc;
% Load assembly
asm_mc_base = NET.addAssembly('C:\Users\sarkara1\Documents\MATLAB\mc-base.dll');
asm_mc_corrosioncase = NET.addAssembly('C:\Users\sarkara1\Documents\MATLAB\mc-corrosioncase.dll');
asm_mc_util = NET.addAssembly('C:\Users\sarkara1\Documents\MATLAB\mc-util.dll');
asm_mc_modeling = NET.addAssembly('C:\Users\sarkara1\Documents\MATLAB\mc-modeling.dll');

% Import namespace
import edu.ohiou.icmt.multicorp.factory.*
import edu.ohiou.icmt.modeling.globalresources.*
import edu.ohiou.icmt.modeling.controller.*
import edu.ohiou.icmt.multicorp.factory.*

%Display class names in this assembly. Test only.
%asm_mc_modeling.Classes

try
    %Call static method: Namespace.ClassName.MethodName(arguments)
    edu.ohiou.icmt.MulticorpRunner.initialize();
catch e
    disp(e.message)
end
% Create corrosion case.

caseFactory = AbstractModelFactory.getFactory(0);
newCase = caseFactory.createModel();

% Create composition model and add it to corrosion case.
compositionFactory = AbstractModelFactory.getFactory(1);
compositionModel = compositionFactory.createModel(newCase);

% Create flow model and add it to corrosion case.
flowFactory = AbstractModelFactory.getFactory(3);
flowType = 1; % Water Flow.
newCase.getParameter(NameList.FLOW_TYPE).setValue(flowType);
newCase.onFlowTypeChanged()
flowModel = newCase.getModel(NameList.MODEL_NAME_FLOW_MODEL);

% Flow model gets pipe profile data from pipeline model.
pipeFactory = AbstractModelFactory.getFactory(5);
pipeLineModel = pipeFactory.createModel(newCase);
% The required parameters are imported to flowmodel so that we can access them from Flow Model itself.
flowModel.importParamGroups(pipeLineModel, 'Pipe Properties');

try
    % How to set parameter value.
    compositionModel.getParameter(NameList.CO2_GAS_CONTENT).setValue(20)
catch e
    disp(e.message)
end

try
    % DO calculation
    compositionModel.doCalculation()
    flowModel.doCalculation()
catch e
    disp(e.message)
end

% Retrieve value from calculated model.
h2oGasContent = compositionModel.getParameter(NameList.H2O_GAS_CONTENT).getDoubleValue()





