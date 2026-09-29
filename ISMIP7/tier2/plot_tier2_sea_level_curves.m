clc
clear all
close all

foldername_tier2 = '/Volumes/External/ISMIP7/results/tier2';

linewidth = 4;

wa = [800,50];
ha = 500;
margins_hor = [80,0,25];
margins_ver = [50,100];
H = setup_multipanel_figure( wa, ha, margins_hor, margins_ver);

set( H.Ax{1,1},'xlim',[2000,2300],'ylim',[-1,5],'fontsize',25);
set( H.Ax{1,2},'xlim',[-1,5],'ylim',[-1,5],'fontsize',25,...
  'xtick',[]);
H.Ax{1,2}.XAxis.Visible = 'off';
H.Ax{1,2}.YAxis.Visible = 'off';
xlabel( H.Ax{1,1},'Time (yr)')
ylabel( H.Ax{1,1},'Sea level contribution (m)')

% Invisible axes for legend
H.Axa = axes('parent',H.Fig,'units','pixels',...
  'position',get(H.Ax{1,1},'position'),'color','none');
H.Axa.XAxis.Visible = 'off';
H.Axa.YAxis.Visible = 'off';

% Legend stuff
legend_entries = {};

% Counter for range bars
rangebari = 0;
dd        = 0.1;

%% Default
legend_entries{ end+1} = 'Default';
default.color = 'black';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( default.color),'linestyle','-');

[default.time, default.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P001', 'P002');

line('parent',H.Ax{1,1},'xdata',default.time,'ydata',default.SLC,...
  'linewidth',linewidth,'color',code2colour( default.color),'linestyle','-');

%% Fracture
legend_entries{ end+1} = 'Fracture';
frac.color = 'red';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( frac.color),'linestyle','-');

[frac_lo.time, frac_lo.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P015', 'P016');
[frac_hi.time, frac_hi.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P017', 'P018');

line('parent',H.Ax{1,1},'xdata',frac_lo.time,'ydata',frac_lo.SLC,...
  'linewidth',linewidth,'color',code2colour( frac.color),'linestyle','-');
line('parent',H.Ax{1,1},'xdata',frac_hi.time,'ydata',frac_hi.SLC,...
  'linewidth',linewidth,'color',code2colour( frac.color),'linestyle','-');

% Plot range in 2300
frac.SLC_max = max( frac_lo.SLC(end), frac_hi.SLC(end));
frac.SLC_min = min( frac_lo.SLC(end), frac_hi.SLC(end));
rangebari = rangebari+1;
xlo = rangebari - 1 + dd;
xhi = rangebari     - dd;
ylo = frac.SLC_min;
yhi = frac.SLC_max;
patch('parent',H.Ax{1,2},'xdata',[xlo,xhi,xhi,xlo],'ydata',[ylo,ylo,yhi,yhi],...
  'facecolor',code2colour( frac.color),'edgecolor','none');

%% LADDIE
legend_entries{ end+1} = 'LADDIE';
LADDIE.color = 'blue';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( LADDIE.color),'linestyle','-');

[LADDIE_hi.time, LADDIE_hi.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P011', 'P012');
[LADDIE_lo.time, LADDIE_lo.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P013', 'P014');

line('parent',H.Ax{1,1},'xdata',LADDIE_hi.time,'ydata',LADDIE_hi.SLC,...
  'linewidth',linewidth,'color',code2colour( LADDIE.color),'linestyle','-');
line('parent',H.Ax{1,1},'xdata',LADDIE_lo.time,'ydata',LADDIE_lo.SLC,...
  'linewidth',linewidth,'color',code2colour( LADDIE.color),'linestyle','-');

% Plot range in 2300
LADDIE.SLC_max = max( LADDIE_lo.SLC(end), LADDIE_hi.SLC(end));
LADDIE.SLC_min = min( LADDIE_lo.SLC(end), LADDIE_hi.SLC(end));
rangebari = rangebari+1;
xlo = rangebari - 1 + dd;
xhi = rangebari     - dd;
ylo = LADDIE.SLC_min;
yhi = LADDIE.SLC_max;
patch('parent',H.Ax{1,2},'xdata',[xlo,xhi,xhi,xlo],'ydata',[ylo,ylo,yhi,yhi],...
  'facecolor',code2colour( LADDIE.color),'edgecolor','none');

%% SMB lapse rate
legend_entries{ end+1} = 'dSMB/dz';
dSMBdz.color = 'green';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( dSMBdz.color),'linestyle','-');

[dSMBdz.time, dSMBdz.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P003', 'P004');

line('parent',H.Ax{1,1},'xdata',dSMBdz.time,'ydata',dSMBdz.SLC,...
  'linewidth',linewidth,'color',code2colour( dSMBdz.color),'linestyle','-');

% Plot range in 2300
dSMBdz.SLC_max = max( default.SLC(end), dSMBdz.SLC(end));
dSMBdz.SLC_min = min( default.SLC(end), dSMBdz.SLC(end));
rangebari = rangebari+1;
xlo = rangebari - 1 + dd;
xhi = rangebari     - dd;
ylo = dSMBdz.SLC_min;
yhi = dSMBdz.SLC_max;
patch('parent',H.Ax{1,2},'xdata',[xlo,xhi,xhi,xlo],'ydata',[ylo,ylo,yhi,yhi],...
  'facecolor',code2colour( dSMBdz.color),'edgecolor','none');

%% Thermodynamics
legend_entries{ end+1} = 'Thermodynamics';
thermo.color = 'orange';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( thermo.color),'linestyle','-');

[thermo.time, thermo.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P019', 'P020');

line('parent',H.Ax{1,1},'xdata',thermo.time,'ydata',thermo.SLC,...
  'linewidth',linewidth,'color',code2colour( thermo.color),'linestyle','-');

% Plot range in 2300
thermo.SLC_max = max( default.SLC(end), thermo.SLC(end));
thermo.SLC_min = min( default.SLC(end), thermo.SLC(end));
rangebari = rangebari+1;
xlo = rangebari - 1 + dd;
xhi = rangebari     - dd;
ylo = thermo.SLC_min;
yhi = thermo.SLC_max;
patch('parent',H.Ax{1,2},'xdata',[xlo,xhi,xhi,xlo],'ydata',[ylo,ylo,yhi,yhi],...
  'facecolor',code2colour( thermo.color),'edgecolor','none');

%% GIA
legend_entries{ end+1} = 'GIA';
GIA.color = 'brown';
line('parent',H.Axa,'xdata',[],'ydata',[],...
  'linewidth',linewidth,'color',code2colour( GIA.color),'linestyle','-');

[GIA_slow.time, GIA_slow.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P007', 'P008');
[GIA_fast.time, GIA_fast.SLC] = read_SLC_hist_and_proj( foldername_tier2, 'P009', 'P010');

line('parent',H.Ax{1,1},'xdata',GIA_slow.time,'ydata',GIA_slow.SLC,...
  'linewidth',linewidth,'color',code2colour( GIA.color),'linestyle','-');
line('parent',H.Ax{1,1},'xdata',GIA_fast.time,'ydata',GIA_fast.SLC,...
  'linewidth',linewidth,'color',code2colour( GIA.color),'linestyle','-');

% Plot range in 2300
GIA.SLC_max = max( GIA_slow.SLC(end), GIA_fast.SLC(end));
GIA.SLC_min = min( GIA_slow.SLC(end), GIA_fast.SLC(end));
rangebari = rangebari+1;
xlo = rangebari - 1 + dd;
xhi = rangebari     - dd;
ylo = GIA.SLC_min;
yhi = GIA.SLC_max;
patch('parent',H.Ax{1,2},'xdata',[xlo,xhi,xhi,xlo],'ydata',[ylo,ylo,yhi,yhi],...
  'facecolor',code2colour( GIA.color),'edgecolor','none');

%% Legend
legend( H.Axa, legend_entries, 'location','northwest','fontsize',25);

%% Default value on top of range bars
xlim = get( H.Ax{1,2},'xlim');
line('parent',H.Ax{1,2},'xdata',xlim,'ydata',[0,0]+default.SLC(end),...
  'color','k','linewidth',linewidth-1,'linestyle',':')

function colour = code2colour( col_code)

colours6 = linspecer(6);

c_red    = colours6( 1,:);
c_blue   = colours6( 2,:);
c_green  = colours6( 3,:);
c_orange = colours6( 4,:);
c_yellow = colours6( 5,:);
c_brown  = colours6( 6,:);

switch col_code
  case 'black'
    colour = [0,0,0];
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

function [time, SLC] = read_SLC_hist_and_proj( foldername_tier2, Pcode_hist, Pcode_proj)

filename = 'scalar_output_ANT_00001.nc';

filename_hist = [foldername_tier2 '/results_' Pcode_hist '/' filename];
filename_proj = [foldername_tier2 '/results_' Pcode_proj '/' filename];

time_hist = ncread( filename_hist, 'time');
time_proj = ncread( filename_proj, 'time');

VAF_hist = ncread( filename_hist,'ice_volume_af');
VAF_proj = ncread( filename_proj,'ice_volume_af');

SLC_hist = VAF_hist( end) - VAF_hist;
SLC_proj = VAF_proj( 1  ) - VAF_proj;

time_raw = [time_hist; time_proj( 2:end)];
SLC_raw  = [SLC_hist;  SLC_proj(  2:end)];

% Remap to regular 1-year grid
time = (2000:2300)';
SLC = interp1( time_raw, SLC_raw, time);

end


