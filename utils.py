__author__ = 'Mojo'
import numpy as np

# Notice lat and lon are in radians
def lla2ecef(lat, lon, alt):

    # WGS84 ellipsoid constants:
    a = 6378137
    e = 8.1819190842622e-2

    # intermediate calculation
    # (prime vertical radius of curvature)
    N = a / np.sqrt(1 - e**2 * np.sin(lat)**2)

    # results:
    x = (N+alt) * np.cos(lat) * np.cos(lon)
    y = (N+alt) * np.cos(lat) * np.sin(lon)
    z = ((1-e**2) * N + alt) * np.sin(lat)

    return x, y, z


def lla2ned(lat_ref, lon_ref, lat, lon):

    lat_ref = np.radians(lat_ref)
    lon_ref = np.radians(lon_ref)
    lat = np.radians(lat)
    lon = np.radians(lon)

    x0, y0, z0 = lla2ecef(lat_ref, lon_ref, 0)
    x, y, z = lla2ecef(lat, lon, 0)
    r0 = np.matrix([x0, y0, z0]).transpose()

    Rne = np.matrix([[-np.sin(lat_ref)*np.cos(lon_ref), -np.sin(lat_ref)*np.sin(lon_ref), np.cos(lat_ref)],
           [-np.sin(lon_ref), np.cos(lon_ref), 0],
           [-np.cos(lat_ref)*np.cos(lon_ref), -np.cos(lat_ref)*np.sin(lon_ref), -np.sin(lat_ref)]])

    r = np.matrix([x, y, z])
    a = np.tile(r0, (1, np.shape(r)[1]))
    NED = Rne*(r - a)

    return NED
