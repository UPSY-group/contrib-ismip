clc
clear all
close all

foldername_tier1 = '/Volumes/External/ISMIP7/results/tier1';

experiments = {
  'C001', 'Historical (CESM)', 'C001', 'blue'  ,  '-' ;    
  'C002', 'Historical (MRI)' , 'C002', 'blue'  ,  ':';     
  'C011', 'OCX (ERA5)'       , 'C011', 'green' ,  '-' ;     
  'C009', 'Ctrl (CESM)'      , 'C001', 'brown' ,  '-' ;     
  'C010', 'Ctrl (MRI)'       , 'C002', 'brown' ,  ':';      
  'C005', 'SSP1-2.6 (CESM)'  , 'C001', 'yellow',  '-' ;      
  'C006', 'SSP1-2.6 (MRI)'   , 'C002', 'yellow',  ':';       
  'C003', 'SSP3-7.0 (CESM)'  , 'C001', 'orange',  '-' ;      
  'C004', 'SSP3-7.0 (MRI)'   , 'C002', 'orange',  ':';       
  'C007', 'SSP5-8.5 (CESM)'  , 'C001', 'red'   ,  '-' ;   
  'C008', 'SSP5-8.5 (MRI)'   , 'C002', 'red'   ,  ':';    
  };
nx = size( experiments,1);

linewidth = 4;

wa = 800;
ha = 500;
margins_hor = [300,80];
margins_ver = [50,100];
H = setup_multipanel_figure( wa, ha, margins_hor, margins_ver);

set( H.Ax{1,1},'xlim',[2000,2300],'ylim',[-1,5],'fontsize',25,...
  'yaxislocation','right');
xlabel( H.Ax{1,1},'Time (yr)')
ylabel( H.Ax{1,1},'Sea level contribution (m)')

% Zoom-in axeses
H.Ax{1,2} = axes('parent',H.Fig,'units','pixels',...
  'position',[80,420,250,200],'fontsize',25,...
  'xgrid','on','ygrid','on','box','on',...
  'xlim',[2000,2025],'xtick',2000:5:2025,...
  'ylim',[-0.012,0.012]);%,'ytick',-0.02:0.01:0.02);

H.Ax{1,3} = axes('parent',H.Fig,'units','pixels',...
  'position',[410,420,250,200],'fontsize',25,...
  'xgrid','on','ygrid','on','box','on',...
  'xlim',[2000,2100],'xtick',2000:20:2100,...
  'ylim',[-0.02,0.12]);

% Empty GUI objects for legend
line('parent',H.Ax{1,1},'xdata',[],'ydata',[],...
  'color','k','linewidth',linewidth)
for xi = 1: nx
  xp        = experiments{ xi,1};
  name      = experiments( xi,2);
  col_code  = experiments{ xi,4};
  linestyle = experiments{ xi,5};

  colour = code2colour( col_code);

  line('parent',H.Ax{1,1},'xdata',[],'ydata',[],...
    'linewidth',linewidth,'color',colour,'linestyle',linestyle)
end

% Plot IMBIE data
IMBIE = read_IMBIE();
line('parent',H.Ax{1,2},'xdata',IMBIE.time,'ydata',IMBIE.SL,...
  'color','k','linewidth',linewidth)

for xi = 1: nx

  xp        = experiments{ xi,1};
  name      = experiments{ xi,2};
  ref       = experiments{ xi,3};
  col_code  = experiments{ xi,4};
  linestyle = experiments{ xi,5};
  colour    = code2colour( col_code);
  foldername_xp = [foldername_tier1 '/results_' xp];

  % Check if this experiment is available
  if ~exist( foldername_xp,'dir'); continue; end

  % Read model output
  filename_scalar = [foldername_xp '/scalar_output_ANT_00001.nc'];
  time = ncread( filename_scalar,'time');
  VAF  = ncread( filename_scalar,'ice_volume_af');

  % Read VAF at the end of the reference historical simulation
  foldername_ref      = [foldername_tier1 '/results_' ref];
  filename_scalar_ref = [foldername_ref '/scalar_output_ANT_00001.nc'];
  VAF_ref = ncread( filename_scalar_ref,'ice_volume_af');

  SL = VAF_ref( end) - VAF;

  % Plot
  line('parent',H.Ax{1,1},'xdata',time,'ydata',SL,...
    'linewidth',linewidth,'color',colour,'linestyle',linestyle)
  line('parent',H.Ax{1,2},'xdata',time,'ydata',SL,...
    'linewidth',linewidth,'color',colour,'linestyle',linestyle)
  line('parent',H.Ax{1,3},'xdata',time,'ydata',SL,...
    'linewidth',linewidth,'color',colour,'linestyle',linestyle)
  
end

% Legend
pos = get( H.Ax{1,1},'position');
H.Legend = legend( H.Ax{1,1},[{'IMBIE'}; experiments(:,2)],'location','westoutside');
set( H.Ax{1,1},'position',pos);
set( H.Legend,'units','pixels','position',[29.5000   15.2500  219.5000  327.5000]);

function IMBIE = read_IMBIE()

filename_IMBIE = '/Users/Beren017/Documents/imbie_antarctica_2021_mm.csv';

fid = fopen( filename_IMBIE);
temp = textscan( fid,'%f %f %f %f %f','headerlines',1,'delimiter',',');

time = temp{1};
SL   = temp{4} / 1e3; % Conversion from mmsle to msle
dSL  = temp{5} / 1e3; % Conversion from mmsle to msle

SL_min = SL - dSL;
SL_max = SL + dSL;

% Define SL(t=2015) as zero
ti = find( time==2015);
SL = SL - SL( ti);
SL_min = SL_min - SL_min( ti);
SL_max = SL_max - SL_max( ti);

IMBIE.time   = time;
IMBIE.SL     = SL;
IMBIE.SL_min = SL_min;
IMBIE.SL_max = SL_max;

end

function colour = code2colour( col_code)

colours6 = linspecer(6);

c_red    = colours6( 1,:);
c_blue   = colours6( 2,:);
c_green  = colours6( 3,:);
c_orange = colours6( 4,:);
c_yellow = colours6( 5,:);
c_brown  = colours6( 6,:);

switch col_code
  case 'red'
    colour = c_red;
  case 'blue'
    colour = c_blue;
  case 'green'
    colour = c_green;
  case 'orange'
    colour = c_orange;
  case 'yellow'
    colour = c_yellow;
  case 'brown'
    colour = c_brown;
end

end