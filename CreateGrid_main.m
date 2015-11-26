BASE_DIR = 'c:\DataHack\Mobileye\all_drives';

files = dir(fullfile(BASE_DIR,'*.mat'));

gps_list = [];
fileindex = [];
for f = files'
    gf = GetGPSFromFile(fullfile(BASE_DIR,f.name));
    gps_list = [gps_list; gf];
    fileindex = [fileindex; size(gf,1)];
end

ACCURACY = 0.0002;

THICKNESS = 3;
[grid,orig] = CreateGridFromPairs(gps_list,ACCURACY,THICKNESS);

%{
% Save
max_val = max(grid(:));
imwrite(uint8(grid/max_val*255),'img_routes.png');
imwrite(uint8(min(1,grid)*255),'img_routes_binary.png');
save('routes_sum.mat','grid');
%}

%4d points
[grid4d,orig,xy_size] = GetPairPoints(gps_list, ACCURACY);

% Remove the points of cars that did not move (i.e. (0,0) or 5 in the
% direction)
grid4d(:,5) = [];

% Find the interesting points
[high4dPoints,high_direction] = find(grid4d>20);
[lat,lon] = ind2sub(xy_size,high4dPoints);
good_points = bsxfun(@plus,[lat lon],orig-1)*ACCURACY;

% Plot
figure,imagesc(min(1,grid));
hold on
colormap gray
for i = 1:8
    plot(lon(high_direction == i),lat(high_direction == i),'*')
end

frame_struct = FindFrames (gps_list, fileindex, [lat,lon], high_direction, ACCURACY);

% Save the frame list
fid = fopen('frame_list.csv','w');
fwrite(fid,sprintf('type,lat,lon,data\n'));

for st = frame_struct'
    p = (st.p+orig)*ACCURACY;
    fwrite(fid,sprintf('file,%g,%g,',p(:,1),p(:,2)));
    for idx = st.file'
        fwrite(fid,sprintf('%s,',files(idx).name));
    end
    fwrite(fid,sprintf('\nfile,%g,%g,',p(:,1),p(:,2)));
    fwrite(fid,sprintf('%g,',st.frame));
    fwrite(fid,sprintf('\n'));
end

fclose(fid);