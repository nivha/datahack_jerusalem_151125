function frame_struct = FindFrames (orig_points, index_size_list, interesting_points, interesting_direction, accuracy)
% Finds the file index and frame of each interesting point

[orig_points,~,direction] = PointsFloor(orig_points,accuracy);

fileidx = [];
fileframe = [];
for i = 1:numel(index_size_list)
    fileidx = [fileidx;zeros(index_size_list(i),1)+i];
    fileframe = [fileframe;(1:index_size_list(i))'];
end

frame_struct = [];

for i = 1:size(interesting_points,1)
    st.p = interesting_points(i,:);
    d = interesting_direction(i);
    idx = find(orig_points(1:end-1,1) == st.p(:,1) & orig_points(1:end-1,2)== st.p(:,2) & direction == d);
    st.file = fileidx(idx);
    st.frame = fileframe(idx);
    
    frame_struct = [frame_struct; st];
end


