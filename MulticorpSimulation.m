clear;
clc;
% Load assembly
asm_mc_base = NET.addAssembly('C:\Users\sarkara1\Documents\MATLABMulticorp\mc-base.dll');
asm_mc_corrosioncase = NET.addAssembly('C:\Users\sarkara1\Documents\MATLABMulticorp\mc-corrosioncase.dll');
asm_mc_util = NET.addAssembly('C:\Users\sarkara1\Documents\MATLABMulticorp\mc-util.dll');
asm_mc_modeling = NET.addAssembly('C:\Users\sarkara1\Documents\MATLABMulticorp\mc-modeling.dll');
asm_mc_corrosion = NET.addAssembly('C:\Users\sarkara1\Documents\MATLABMulticorp\mc-corrosion.dll');

% Import namespace
import edu.ohiou.icmt.multicorp.factory.*
import edu.ohiou.icmt.modeling.globalresources.*
import edu.ohiou.icmt.modeling.controller.*
import edu.ohiou.icmt.multicorp.factory.*
import edu.ohiou.icmt.multicorp.postprocessing.*

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

% choose BLC as Corrosion Type 
corrosionType = newCase.getParameter(NameList.CORROSION_TYPE);
corrosionType.setOption(1);
newCase.onCorrosionTypeChanged();

% choose Gas-Water Flow as Flow type
flowType = newCase.getParameter(NameList.FLOW_TYPE);
flowType.setOption(3);
newCase.onFlowTypeChanged();

%choose point run
simuType = newCase.getParameter(NameList.SIMU_TYPE);
corrosionType.setOption(1);
newCase.onSimulationTypeChanged();

%Calculate composition
composition = newCase.getModel(NameList.MODEL_NAME_COMPOSITION);
composition.doCalculation();

%Calculate flow
flow = newCase.getModel(NameList.MODEL_NAME_FLOW_MODEL);
flow.doCalculation();

%get result manager
corrosionResult = newCase.getModel(NameList.MODEL_NAME_CORROSION_RESULT);

simulation = newCase.getModel(NameList.MODEL_NAME_CORROSION_MODEL);
simulation.makeOutputOptionList();

