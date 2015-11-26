function [table,title] = GetFeatures (frame_struct, base_dir, files, accuracy, orig)

table = [];
N_PREV_FRAMES = 60;

for f = 1:numel(files)
    data = load(fullfile(base_dir,files(f).name));
    
    for st = frame_struct'
        point = (st.p+orig)*accuracy;
        direction = st.d + st.d>4;

        idx = st.frame(st.file == f);
        idx (idx<=60) = [];
        if numel(idx) > 0
        
            table_lines = [];
            for i = 0:-1:-N_PREV_FRAMES
                fidx = data.gps.frameIdx(idx+i);
                [~,pidx] = find(bsxfun(@eq,fidx,data.frameIdx'));

                points = repmat(point,[numel(pidx),1]);
                directions = repmat(direction,[numel(pidx),1]);
                fids = repmat(f,[numel(pidx),1]);

                % GPS info
                lat = data.gps.lat(idx+i);
                lon = data.gps.lon(idx+i);

                % Other info
                speed = data.vehicleData.speed(pidx);
                lanes = data.laneDecision.lanesTotal(pidx);
                egx = data.ego_motion.dX(pidx);
                egy = data.ego_motion.dY(pidx);
                egz = data.ego_motion.dZ(pidx);
                egw = data.ego_motion.yaw(pidx);
                egp = data.ego_motion.pitch(pidx);
                egr = data.ego_motion.roll(pidx);
                
                table_lines = [table_lines, speed,lanes,egx,egy,egz,egw,egp,egr];

            end
            table = [table; fids,idx,points,directions,fidx,lat,lon,table_lines]; 
        end
    end
    
    clear data;
end
    
title = 'file_id,gps_frame_pos,lat_floor,lon_floor,direction,frame_idx,lat_real,lon_real,speed,num_lanes,dX,dY,dZ,yaw,pitch,roll';
end