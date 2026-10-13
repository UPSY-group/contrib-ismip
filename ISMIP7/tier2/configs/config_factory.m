clc
clear all
close all

delete_existing_config_files()

filename_PPE_table = 'IMAUKNMI_UFEMISM_PPE_table.txt';

core_experiments = {
  'C001'   % Historical, CESM
  'C002'   % Historical, MRI
  'C003'   % SSP3-7.0, CESM
  'C007'   % SSP5-8.5, CESM
  'C008'   % SSP5-8.5, MRI
  };
model_versions = {
  'm001','Default';
  'm002','GIA: no uplift';
  'm003','GIA: relaxation time = 3000 yr';
  'm004','GIA: relaxation time = 200 yr';
  'm005','LADDIE: top-drag-coeff = 0.0014';
  'm006','LADDIE: top-drag-coeff = 0.0005';
  'm007','Fracture: not applied';
  'm008','Fracture: apply to all floating ice';
  'm009','No thermodynamics (constant ice temperature)';
  'm010','Calving: threshold thickness = 50 m';
  'm011','Calving: threshold thickness = 100 m';
  'm012','Calving: threshold thickness = 200 m';
  };
forcing_versions = {
  'f001','Default';
  'f002','dSMB/dz = 0';
  };

% Create text file listing all the PPE experiments
if exist( filename_PPE_table,'file')
  delete( filename_PPE_table)
end
fid = fopen( filename_PPE_table,'w');
list_forcing_and_model_versions( fid, forcing_versions, model_versions);

ppi = 0;
opts_historical_CESM = [];
opts_historical_MRI  = [];
opts_historical      = [];

for fi = 1: size( forcing_versions,1)
  for ci = 1: length( core_experiments)

    filename_config_template = ['../../tier1/configs/config_' core_experiments{ ci} '.cfg'];
    c = read_config_template( filename_config_template);

    ppi = ppi + 1;
  
    opts.core_experiment = core_experiments{ ci};
    opts.model_version   = model_versions{ 1,1};
    opts.forcing_version = forcing_versions{ fi,1};
    opts.ppi             = ppi;

    if strcmpi( opts.core_experiment,'C001')
      opts_historical_CESM = opts;
    elseif strcmpi( opts.core_experiment,'C002')
      opts_historical_MRI = opts;
    elseif strcmpi( opts.core_experiment,'C003') || ...
           strcmpi( opts.core_experiment,'C005') || ...
           strcmpi( opts.core_experiment,'C007') || ...
           strcmpi( opts.core_experiment,'C009')
      opts_historical = opts_historical_CESM;
    elseif strcmpi( opts.core_experiment,'C004') || ...
           strcmpi( opts.core_experiment,'C006') || ...
           strcmpi( opts.core_experiment,'C008') || ...
           strcmpi( opts.core_experiment,'C010')
      opts_historical = opts_historical_MRI;
    end

    opts.opts_historical = opts_historical;

    add_simulation_to_list( fid, opts)
  
    cc = setup_config( c, opts);
  
    config_filename = ['config_P' ppi2str( opts.ppi) '.cfg'];
  
    write_config_to_file( cc, config_filename)
  
  end
end

for mi = 1: size( model_versions,1)
  for ci = 1: length( core_experiments)

    filename_config_template = ['../../tier1/configs/config_' core_experiments{ ci} '.cfg'];
    c = read_config_template( filename_config_template);

    ppi = ppi + 1;
  
    opts.core_experiment   = core_experiments{ ci};
    opts.model_version   = model_versions{ mi,1};
    opts.forcing_version = forcing_versions{ 1,1};
    opts.ppi               = ppi;

    if strcmpi( opts.core_experiment,'C001')
      opts_historical_CESM = opts;
    elseif strcmpi( opts.core_experiment,'C002')
      opts_historical_MRI = opts;
    elseif strcmpi( opts.core_experiment,'C003') || ...
           strcmpi( opts.core_experiment,'C005') || ...
           strcmpi( opts.core_experiment,'C007') || ...
           strcmpi( opts.core_experiment,'C009')
      opts_historical = opts_historical_CESM;
    elseif strcmpi( opts.core_experiment,'C004') || ...
           strcmpi( opts.core_experiment,'C006') || ...
           strcmpi( opts.core_experiment,'C008') || ...
           strcmpi( opts.core_experiment,'C010')
      opts_historical = opts_historical_MRI;
    end

    opts.opts_historical = opts_historical;

    add_simulation_to_list( fid, opts)
  
    cc = setup_config( c, opts);
  
    config_filename = ['config_P' ppi2str( opts.ppi) '.cfg'];
  
    write_config_to_file( cc, config_filename)
  
  end

end

fclose( fid);

function delete_existing_config_files()

henk = dir();

for i = 1: length( henk)
  if endsWith( henk(i).name,'.cfg')
    delete( henk(i).name)
  end
end

end

function list_forcing_and_model_versions( fid, forcing_versions, model_versions)

fprintf( fid,'%s\n', 'List of all the ISMIP7 PPE experiments');
fprintf( fid,'%s\n', 'that were done by the IMAU/KNMI group with UFEMISM');
fprintf( fid,'%s\n', '');
fprintf( fid,'%s\n', '=== Forcing versions ===');
fprintf( fid,'%s\n', '========================');
fprintf( fid,'%s\n', '');

for fi = 1: size( forcing_versions,1)
  fprintf( fid,'%s\n', [forcing_versions{ fi,1} ': ' forcing_versions{ fi,2}]);
end

fprintf( fid,'%s\n', '');
fprintf( fid,'%s\n', '=== ISM versions ===');
fprintf( fid,'%s\n', '====================');
fprintf( fid,'%s\n', '');

for mi = 1: size( model_versions,1)
  fprintf( fid,'%s\n', [model_versions{ mi,1} ': ' model_versions{ mi,2}]);
end

fprintf( fid,'%s\n', '');
fprintf( fid,'%s\n', '=== PPE simulations ===');
fprintf( fid,'%s\n', '=======================');
fprintf( fid,'%s\n', '');

end

function add_simulation_to_list( fid, opts)

  fprintf( fid, '%s\n', ['P' ppi2str( opts.ppi) ': ' ...
    'based on Core experiment ' opts.core_experiment ...
    ' with forcing version ' opts.forcing_version ...
    ' and ISM version ' opts.model_version]);

end

function ppi_str = ppi2str( ppi)
if ppi < 10
  ppi_str = ['00' num2str( ppi)];
elseif ppi < 100
  ppi_str = ['0' num2str( ppi)];
elseif ppi < 1000
  ppi_str = num2str( ppi);
else
  error('ppi is too large!')
end
end

function c = read_config_template( filename)

if ~exist( filename,'file')
  error(['Config template "' filename '" not found'])
end

fid = fopen( filename);
temp = textscan( fid,'%s','delimiter','\n');
c = temp{1};
fclose( fid);

end

function c = setup_config( c, opts)

for li = 1: size( c,1)
  c{li} = setup_config_line( c{li}, opts);
end

end

function write_config_to_file( cc, config_filename)

if exist( config_filename,'file')
  delete( config_filename)
end

fid = fopen( config_filename,'w');
for li = 1: size( cc,1)
  fprintf( fid,'%s\n', cc{li});
end
fclose( fid);

end

%% Individual config variables
function single_line = setup_config_line( single_line, opts)


if     startsWith( single_line, 'fixed_output_dir_config')
  single_line = fixed_output_dir_config( opts);

elseif startsWith( single_line, 'ismip_member_id_config')
  single_line = ismip_member_id_config( opts);

elseif startsWith( single_line, 'ismip_forcing_member_id_config')
  single_line = ismip_forcing_member_id_config( opts);

elseif startsWith( single_line, 'ismip_counter_config')
  single_line = ismip_counter_config( opts);

elseif startsWith( single_line, 'filename_refgeo_init_ANT_config')
  single_line = filename_refgeo_init_ANT_config( opts);

elseif startsWith( single_line, 'filename_initial_velocity_ANT_config')
  single_line = filename_initial_velocity_ANT_config( opts);

elseif startsWith( single_line, 'filename_pc_initialise_ANT_config')
  single_line = filename_pc_initialise_ANT_config( opts);

elseif startsWith( single_line, 'filename_laddie_restart_config')
  single_line = filename_laddie_restart_config( opts);

elseif startsWith( single_line, 'filename_initial_ice_temperature_ANT_config')
  single_line = filename_initial_ice_temperature_ANT_config( opts);

elseif startsWith( single_line, 'choice_GIA_model_config')
  single_line = choice_GIA_model_config( opts);

elseif startsWith( single_line, 'SMB_ISMIP7_apply_SMB_lapse_rate_config')
  single_line = SMB_ISMIP7_apply_SMB_lapse_rate_config( opts);

elseif startsWith( single_line, 'choice_GIA_ELRA_relaxation_time_config')
  single_line = choice_GIA_ELRA_relaxation_time_config( opts);

elseif startsWith( single_line, 'ELRA_bedrock_relaxation_time_config')
  single_line = ELRA_bedrock_relaxation_time_config( opts);

elseif startsWith( single_line, 'laddie_drag_coefficient_top_config')
  single_line = laddie_drag_coefficient_top_config( opts);

elseif startsWith( single_line, 'do_apply_ISMIP7_fracture_mask_config')
  single_line = do_apply_ISMIP7_fracture_mask_config( opts);

elseif startsWith( single_line, 'ISMIP7_fracture_only_from_front_config')
  single_line = ISMIP7_fracture_only_from_front_config( opts);

elseif startsWith( single_line, 'choice_thermo_model_config')
  single_line = choice_thermo_model_config( opts);

elseif startsWith( single_line, 'choice_calving_law_config')
  single_line = choice_calving_law_config( opts);

elseif startsWith( single_line, 'calving_threshold_thickness_shelf_config')
  single_line = calving_threshold_thickness_shelf_config( opts);

end

end



function single_line = fixed_output_dir_config( opts)

single_line = ['fixed_output_dir_config = "/projects/einf1499/tijn/' ...
  'ISMIP7/results/tier2/results_P' ppi2str( opts.ppi) '"'];

end

function single_line = ismip_member_id_config( opts)

single_line = ['ismip_member_id_config = ''' opts.model_version ''''];

end

function single_line = ismip_forcing_member_id_config( opts)

single_line = ['ismip_forcing_member_id_config = ''' opts.forcing_version ''''];

end

function single_line = ismip_counter_config( opts)

single_line = ['ismip_counter_config = ''P' ppi2str( opts.ppi) ''''];

end

function single_line = filename_refgeo_init_ANT_config( opts)

switch opts.core_experiment
  case {'C007', 'C008'}
    single_line = ['filename_refgeo_init_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/tier1/results_P' ppi2str( opts.opts_historical.ppi) '/main_output_ANT_00001.nc'''];
  otherwise
    single_line = ['filename_refgeo_init_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/initial_states/s18p1/main_output_ANT_00001.nc'''];
end

end

function single_line = filename_initial_velocity_ANT_config( opts)

switch opts.core_experiment
  case {'C007', 'C008'}
    single_line = ['filename_initial_velocity_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/tier1/results_P' ppi2str( opts.opts_historical.ppi) '/restart_ice_velocity_DIVA_00001.nc'''];
  otherwise
    single_line = ['filename_initial_velocity_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/initial_states/s18p1/restart_ice_velocity_DIVA_00001.nc'''];
end

end

function single_line = filename_pc_initialise_ANT_config( opts)

switch opts.core_experiment
  case {'C007', 'C008'}
    single_line = ['filename_pc_initialise_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/tier1/results_P' ppi2str( opts.opts_historical.ppi) '/restart_pc_scheme_00001.nc'''];
  otherwise
    single_line = ['filename_pc_initialise_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/initial_states/s18p1/restart_pc_scheme_00001.nc'''];
end

end

function single_line = filename_laddie_restart_config( opts)

switch opts.core_experiment
  case {'C007', 'C008'}
    single_line = ['filename_laddie_restart_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/tier1/results_P' ppi2str( opts.opts_historical.ppi) '/restart_BMB_ANT_00001.nc'''];
  otherwise
    single_line = ['filename_laddie_restart_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/initial_states/s18p1/restart_BMB_ANT_00001.nc'''];
end

end

function single_line = filename_initial_ice_temperature_ANT_config( opts)

switch opts.core_experiment
  case {'C007', 'C008'}
    single_line = ['filename_initial_ice_temperature_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/tier1/results_P' ppi2str( opts.opts_historical.ppi) '/restart_thermodynamics_00001.nc'''];
  otherwise
    single_line = ['filename_initial_ice_temperature_ANT_config = ''/projects/einf1499/tijn/ISMIP7/' ...
      'results/initial_states/s18p1/restart_thermodynamics_00001.nc'''];
end

end

function single_line = SMB_ISMIP7_apply_SMB_lapse_rate_config( opts)
  switch opts.forcing_version
    case 'f001'
      single_line = 'SMB_ISMIP7_apply_SMB_lapse_rate_config = .true.';
    case 'f002'
      single_line = 'SMB_ISMIP7_apply_SMB_lapse_rate_config = .false.';
    otherwise
      error(['invalid forcing_version ' opts.forcing_version])
  end
end

function single_line = choice_GIA_model_config( opts)

switch opts.model_version
  case 'm002'
    single_line = "choice_GIA_model_config = 'none'";
  otherwise
    single_line = "choice_GIA_model_config = 'ELRA'";
end

end

function single_line = choice_GIA_ELRA_relaxation_time_config( opts)

switch opts.model_version
  case {'m003','m004'}
    single_line = "choice_GIA_ELRA_relaxation_time_config = 'uniform'";
  otherwise
    single_line = "choice_GIA_ELRA_relaxation_time_config = 'read_from_file'";
end

end

function single_line = ELRA_bedrock_relaxation_time_config( opts)

switch opts.model_version
  case 'm002'
    single_line = 'ELRA_bedrock_relaxation_time_config = 3000.0';
  case 'm003'
    single_line = 'ELRA_bedrock_relaxation_time_config = 200.0';
  otherwise
    single_line = 'ELRA_bedrock_relaxation_time_config = 300.0';
end

end

function single_line = laddie_drag_coefficient_top_config( opts)

switch opts.model_version
  case 'm005'
    single_line = 'laddie_drag_coefficient_top_config = 0.0014';
  case 'm006'
    single_line = 'laddie_drag_coefficient_top_config = 0.0005';
  otherwise
    single_line = 'laddie_drag_coefficient_top_config = 0.0009';
end

end

function single_line = do_apply_ISMIP7_fracture_mask_config( opts)

switch opts.model_version
  case 'm007'
    single_line = 'do_apply_ISMIP7_fracture_mask_config = .false.';
  otherwise
    single_line = 'do_apply_ISMIP7_fracture_mask_config = .true.';
end

end

function single_line = ISMIP7_fracture_only_from_front_config( opts)

switch opts.model_version
  case 'm008'
    single_line = 'ISMIP7_fracture_only_from_front_config = .false.';
  otherwise
    single_line = 'ISMIP7_fracture_only_from_front_config = .true.';
end

end

function single_line = choice_thermo_model_config( opts)

switch opts.model_version
  case 'm009'
    single_line = "choice_thermo_model_config = 'none'";
  otherwise
    single_line = "choice_thermo_model_config = '3D_heat_equation'";
end

end

function single_line = choice_calving_law_config( opts)

switch opts.model_version
  case {'m010','m011','m012'}
    single_line = 'choice_calving_law_config = ''threshold_thickness_front_iterative''';
  otherwise
    single_line = 'choice_calving_law_config = ''threshold_thickness''';
end

end

function single_line = calving_threshold_thickness_shelf_config( opts)

switch opts.model_version
  case 'm010'
    single_line = 'calving_threshold_thickness_shelf_config = 50.0';
  case 'm011'
    single_line = 'calving_threshold_thickness_shelf_config = 100.0';
  case 'm012'
    single_line = 'calving_threshold_thickness_shelf_config = 200.0';
  otherwise
    single_line = 'calving_threshold_thickness_shelf_config = 1.0';
end

end

