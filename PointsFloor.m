function [gps_list,orig,direction] = PointsFloor (gps_list, accuracy)
% Get the list up to accurate point
gps_list = floor(gps_list/accuracy);

% Start from (0,0)
orig = min(gps_list)-1;
gps_list = bsxfun(@minus,gps_list,orig);

if nargout == 3
    direction2p = gps_list(2:end,:)-gps_list(1:end-1,:);
    direction = (abs(direction2p(:,1))> 1 | abs(direction2p(:,2)) > 1)*10;
    direction(direction~=10) = (direction2p(direction~=10,1)+1)*3+direction2p(direction~=10,2)+2;
end

end