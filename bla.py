import scipy.io as spio
import matplotlib.pyplot as plt
import numpy as np

BASE_DIR = "D:\Users\Mojo\workspace\datahack_jerusalem_112015\mobileye\mobileye_data"

'JET_83-108-70_D_CL_MX_3.9_23712_7.mat'
p = "D:\Users\Mojo\workspace\datahack_jerusalem_112015\mobileye\mobileye_data\JET_58_425_73_D_CL_MX_3.9_1_26490_0.mat"


data_fields = ['frameIdx', 'vehicleData', 'laneDecision', 'road', 'signs', 'ego_motion', 'gps']
gps_fields = ['lon', 'time', 'lat', 'speed', 'heading']


class Interval():
    def __init__(self):
        pass


def add_gps2_to_data(raw_data, data):
    gps_lon = []
    gps_time = []
    gps_lat = []
    gps_speed = []
    gps_heading = []

    gps_frameIdx = raw_data['gps'].frameIdx
    cur_gps_i = 0
    for i, frameIdx in enumerate(raw_data['frameIdx']):

        if frameIdx == gps_frameIdx[cur_gps_i]:
            if cur_gps_i < len(gps_frameIdx)-2:
                cur_gps_i += 1

        gps_lon.append(raw_data['gps'].lon[cur_gps_i])
        gps_time.append(raw_data['gps'].time[cur_gps_i])
        gps_lat.append(raw_data['gps'].lat[cur_gps_i])
        gps_speed.append(raw_data['gps'].speed[cur_gps_i])
        gps_heading.append(raw_data['gps'].heading[cur_gps_i])

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


def cut_mat2interval(mat_path):

    raw_data = spio.loadmat(p, struct_as_record=False, squeeze_me=True)
    data = flat_data(raw_data)
    add_gps2_to_data(raw_data, data)
