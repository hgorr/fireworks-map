%% Plot fireworks displays on a map
% Get list of fireworks display times in major cities across US from:
% https://www.travelandleisure.com/holiday-travel/best-fourth-of-july-fireworks-in-america?slide=576941#576941
% If time wasn't listed, assumed 9:30 (dusk)
% Get latitude and longitude data from https://simplemaps.com/data/world-cities
% Merge (using outerjoin) and save to a .mat file
load fireworks

%%
% Create basemap and set limits
h = geoscatter(40.7,-73.9,'filled');
geobasemap('grayland')
geolimits([4.8 65.2],[-160.8 -56.7])
colormap(hsv)
ax = gca;
ax.CLim = [0 1];

% Loop by time zone and start time
t = ["9:00 PM","9:15 PM","9:20 PM","9:30 PM",...
    "9:35 PM","10:00 PM","10:15 PM","10:30 PM","11:00 PM"];
g = 1:5;
zones = ["EST","CST","MST","PST","AKST","HST"];

% Save video file
clear frame
v = VideoWriter('fireworksmap.avi');
open(v)
for ii = 1:length(g)
    group = fireworks(fireworks.Group == g(ii),:);
    for jj = 1:length(t)
        x = group(group.Time == t(jj),:);
        if ~isempty(x)
            % Add to plot
            h = geoscatter(x.Lat,x.Lon,'filled');
            geobasemap('grayland')
            title("Fireworks Time: "+t(jj))
            hold on
            ax = gca;
            ax.CLim = [0 1];
            geolimits([4.8 65.2],[-160.8 -56.7])
            % Change marker colors and sizes in a loop to make it look like
            % flashes of light
            sizechg = [-25,-20,-10,-5,0,-5,-10,-20,-25];
            s_orig = h.SizeData;
            for k = 1:length(sizechg)
                % Update size and color
                h.SizeData = s_orig + sizechg(k);
                h.CData = rand(height(x),3);
                pause(.2)
                % Write to video
                frame = getframe(gcf);
                writeVideo(v,frame);
            end
        end
        pause(0.05)
    end
    pause(0.05)
end
close(v)
hold off

