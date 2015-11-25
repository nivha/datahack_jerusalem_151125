import scipy.io as spio
import matplotlib.pyplot as plt
import numpy as np

BASE_DIR = "D:\Users\Mojo\workspace\datahack_jerusalem_112015\mobileye\mobileye_data"

p = "D:\Users\Mojo\workspace\datahack_jerusalem_112015\mobileye\mobileye_data\JET_58_425_73_D_CL_MX_3.9_1_26490_0.mat"

data_fields = ['frameIdx', 'vehicleData', 'laneDecision', 'road', 'signs', 'ego_motion', 'gps']
gps_fields = ['lon', 'time', 'lat', 'speed', 'heading']

def add_gps2_to_data(raw_data, data):

    data_length = len(raw_data['frameIdx'])
    gps_lon = np.zeros(shape=data_length)
    gps_time = np.zeros(shape=(data_length, 4))
    gps_lat = np.zeros(shape=data_length)
    gps_speed = np.zeros(shape=data_length)
    gps_heading = np.zeros(shape=data_length)

    gps_frameIdx = raw_data['gps'].frameIdx
    cur_gps_i = 0
    for i, frameIdx in enumerate(raw_data['frameIdx']):

        if frameIdx == gps_frameIdx[cur_gps_i]:
            if cur_gps_i < len(gps_frameIdx)-2:
                cur_gps_i += 1

        gps_lon[i] = raw_data['gps'].lon[cur_gps_i]
        gps_time[i] = raw_data['gps'].time[cur_gps_i]
        gps_lat[i] = raw_data['gps'].lat[cur_gps_i]
        gps_speed[i] = raw_data['gps'].speed[cur_gps_i]
        gps_heading[i] = raw_data['gps'].heading[cur_gps_i]

    data['gps_lon'] = gps_lon
    data['gps_time'] = gps_time
    data['gps_lat'] = gps_lat
    data['gps_speed'] = gps_speed
    data['gps_heading'] = gps_heading


def flat_data(data):

    new_data = {}

    new_data['frameIdx'] = data['frameIdx']

    new_data['timeStamp'] = data['vehicleData'].timeStamp
    new_data['speed'] = data['vehicleData'].speed

    new_data['laneTotal'] = data['laneDecision'].lanesTotal
    new_data['laneIndex'] = data['laneDecision'].laneIndex

    new_data['signs_H'] = data['signs'].H
    new_data['signs_W'] = data['signs'].W
    new_data['signs_age'] = data['signs'].age
    new_data['signs_signType'] = data['signs'].signType
    new_data['signs_sysType'] = data['signs'].sysType

    return new_data


class Interval():
    def __init__(self):
        pass


class GPSGrid():

    def __init__(self, pixel_size):
        self.pixel_size = pixel_size
        self.grid = {}

    def mark_point(self, x, y, data):
        ix = x / self.pixel_size
        iy = y / self.pixel_size
        self.grid[ix, iy] = data


def add_mat2grid(mat_path):

    # Flatten data
    raw_data = spio.loadmat(p, struct_as_record=False, squeeze_me=True)
    data = flat_data(raw_data)
    add_gps2_to_data(raw_data, data)

    # add to grid



if __name__=="__main__":

    pixel_size = 5
    grid = GPSGrid(pixel_size=pixel_size)


