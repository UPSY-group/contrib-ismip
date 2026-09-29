clc
clear all
close all

experiments = {
  'C001'
  'C007'
  };
model_variations = {
  'm001',...
  'm002',...
  'm003',...
  'm004',...
  'm005',...
  'm006',...
  'm007',...
  'm008',...
  'm009',...
  'm010'};
forcing_variations = {
  'f001'
  'f002'
  };

ppi = 0;

for fi = 1: length( forcing_variations)
  for xi = 1: length( experiments)

    filename_config_template = ['../../tier1/configs/config_' experiments{ xi} '.cfg'];
    c = read_config_template( filename_config_template);

    ppi = ppi + 1;
  
    opts.experiment        = experiments{ xi};
    opts.model_variation   = model_variations{ 1};
    opts.forcing_variation = forcing_variations{ fi};
    opts.ppi               = ppi;

    disp(['Simulation P' ppi2str( opts.ppi) ' - ' opts.forcing_variation ' - ' opts.model_variation])
  
    cc = setup_config( c, opts);
  
    config_filename = ['config_P' ppi2str( opts.ppi) '.cfg'];
  
    write_config_to_file( cc, config_filename)
  
  end
end

for mi = 1: length( model_variations)
  for xi = 1: length( experiments)

    filename_config_template = ['../../tier1/configs/config_' experiments{ xi} '.cfg'];
    c = read_config_template( filename_config_template);

    ppi = ppi + 1;
  
    opts.experiment        = experiments{ xi};
    opts.model_variation   = model_variations{ mi};
    opts.forcing_variation = forcing_variations{ 1};
    opts.ppi               = ppi;

    disp(['Simulation P' ppi2str( opts.ppi) ' - ' opts.forcing_variation ' - ' opts.model_variation])
  
    cc = setup_config( c, opts);
  
    config_filename = ['config_P' ppi2str( opts.ppi) '.cfg'];
  
    write_config_to_file( cc, config_filename)
  
  end

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

elseif startsWith( single_line, 'calving_threshold_thickness_shelf_config')
  single_line = calving_threshold_thickness_shelf_config( opts);

end

end



function single_line = fixed_output_dir_config( opts)

single_line = ['fixed_output_dir_config = "/projects/einf1499/tijn/' ...
  'ISMIP7/results/tier2/results_P' ppi2str( opts.ppi) '"'];

end

function single_line = ismip_member_id_config( opts)

single_line = ['ismip_member_id_config = ''' opts.model_variation ''''];

end

function single_line = ismip_forcing_member_id_config( opts)

single_line = ['ismip_forcing_member_id_config = ''' opts.forcing_variation ''''];

end

function single_line = ismip_counter_config( opts)

single_line = ['ismip_counter_config = ''P' ppi2str( opts.ppi) ''''];

end

function single_line = SMB_ISMIP7_apply_SMB_lapse_rate_config( opts)
  switch opts.forcing_variation
    case 'f001'
      single_line = 'SMB_ISMIP7_apply_SMB_lapse_rate_config = .true.';
    case 'f002'
      single_line = 'SMB_ISMIP7_apply_SMB_lapse_rate_config = .false.';
    otherwise
      error(['invalid forcing_variation ' opts.forcing_variation])
  end
end

function single_line = choice_GIA_ELRA_relaxation_time_config( opts)

switch opts.model_variation
  case {'m002','m003'}
    single_line = "choice_GIA_ELRA_relaxation_time_config = 'uniform'";
  otherwise
    single_line = "choice_GIA_ELRA_relaxation_time_config = 'read_from_file'";
end

end

function single_line = ELRA_bedrock_relaxation_time_config( opts)

switch opts.model_variation
  case 'm002'
    single_line = 'ELRA_bedrock_relaxation_time_config = 3000.0';
  case 'm003'
    single_line = 'ELRA_bedrock_relaxation_time_config = 200.0';
  otherwise
    single_line = 'ELRA_bedrock_relaxation_time_config = 300.0';
end

end

function single_line = laddie_drag_coefficient_top_config( opts)

switch opts.model_variation
  case 'm004'
    single_line = 'laddie_drag_coefficient_top_config = 0.0014';
  case 'm005'
    single_line = 'laddie_drag_coefficient_top_config = 0.0005';
  otherwise
    single_line = 'laddie_drag_coefficient_top_config = 0.0009';
end

end

function single_line = do_apply_ISMIP7_fracture_mask_config( opts)

switch opts.model_variation
  case 'm006'
    single_line = 'do_apply_ISMIP7_fracture_mask_config = .false.';
  otherwise
    single_line = 'do_apply_ISMIP7_fracture_mask_config = .true.';
end

end

function single_line = ISMIP7_fracture_only_from_front_config( opts)

switch opts.model_variation
  case 'm007'
    single_line = 'ISMIP7_fracture_only_from_front_config = .false.';
  otherwise
    single_line = 'ISMIP7_fracture_only_from_front_config = .true.';
end

end

function single_line = choice_thermo_model_config( opts)

switch opts.model_variation
  case 'm008'
    single_line = "choice_thermo_model_config = 'none'";
  otherwise
    single_line = "choice_thermo_model_config = '3D_heat_equation'";
end

end

function single_line = calving_threshold_thickness_shelf_config( opts)

switch opts.model_variation
  case 'm009'
    single_line = 'calving_threshold_thickness_shelf_config = 100.0';
  case 'm010'
    single_line = 'calving_threshold_thickness_shelf_config = 200.0';
  otherwise
    single_line = 'calving_threshold_thickness_shelf_config = 1.0';
end

end

