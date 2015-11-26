BASE_DIR = 'c:\DataHack\Mobileye\all_drives';

files = dir(fullfile(BASE_DIR,'*.mat'));

gps_list = [];
for f = files'
    gps_list = [gps_list; GetGPSFromFile(fullfile(BASE_DIR,f.name))];
end

ACCURACY = 0.0001;
[grid,orig] = CreateGridFromPairs(gps_list,ACCURACY);

% Save
max_val = max(grid(:));
imwrite(uint8(grid/max_val*255),'img_routes.png');
imwrite(uint8(min(1,grid)*255),'img_routes_binary.png');
save('routes_sum.mat','grid');