function gps_points = GetGPSFromFile (filename)
% Returns a list of (lat,lon) pairs
data = load(filename);
gps_points = [data.gps.lat,data.gps.lon];