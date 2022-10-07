import mmskeleton
from mmskeleton.utils import call_obj, set_attr
from mmskeleton.processor import recognition 
from mmcv import Config
import deeplabcut
import argparse
import logging
import shutil
import torch
import json
import csv
import cv2
import sys
import os

def action_recognition(species, vid_path = './data/dogwalk2.mp4', model_path = './model') :
    temp_path = './temp'
    if os.path.exists(temp_path) :
        shutil.rmtree(temp_path)
    
    os.mkdir(temp_path)
    os.mkdir(os.path.join(temp_path,"anno_json"))

    anno_path = os.path.join(model_path, 'annotation', species, 'config.yaml')
    act_path = os.path.join(model_path, 'action_recognition')

    vid_annotation(vid_path, anno_path)
    result = skeleton_analysis(species, act_path)

    action_dict = {
        'DOG' : ['걷거나 뜀', '엎드리는 동작', '몸을 긁는 동작', '몸을 터는 동작', '두 앞발을 들어 올리는 동작', '앞발 하나를 들어 올림', '머리를 앞으로 들이미는 동작', '배와 목을 보여주며 눕는 동작', '마운팅하는 동작', '앉는 동작', '꼬리를 위로 올리고 흔드는 동작', '꼬리를 아래로 내리는 동작'],
        'CAT' : ['tailing', 'laydown', 'grooming', 'footpush', 'walkrun', 'sitdown', 'armstretch', 'roll', 'getdown', 'lying', 'heading', 'arch']
    }
    emotion_dict = {
        'DOG' : ['편안_안정', '행복_즐거움', '화남_불쾌', '불안_슬픔']
    }   
    result = result.tolist()
    
    rank = result.copy()
    rank.sort(reverse = True)

    if os.path.exists(temp_path) :
        shutil.rmtree(temp_path)
    
    action_result = dict()
    print(result)
    for value in rank :
        action_result[action_dict[species][result.index(value)%12]+"_"+emotion_dict[species][result.index(value)//12]] = str(value * 100) + '%'

    return action_result

def vid_annotation(vid_path, model_path) :
    temp_path = './temp'
    deeplabcut.DownSampleVideo(vid_path)
    deeplabcut.analyze_videos(model_path, [vid_path], save_as_csv=True, videotype = ".mp4", destfolder = temp_path)

    # video analysis
    vcap = cv2.VideoCapture(vid_path)

    if vcap.isOpened() :
        width  = vcap.get(3)  # float `width`
        height = vcap.get(4)  # float `height`

    video_name = vid_path.split('/')[-1]
    print(video_name)
    resolution = [int(width), int(height)]

    # CSV analysis
    csv_list = os.listdir(temp_path)
    print(csv_list)

    csv_name = ''
    for file_name in csv_list :
        if file_name.split('.')[-1] == 'csv' :
            csv_name = file_name

    csv_data = list()
    with open(os.path.join(temp_path, csv_name)) as f :
        reader = csv.reader(f)
        csv_data = list(reader)

    num_frame = len(csv_data) - 3
    num_keypoints = 15
    keypoint_channels = ['x', 'y', 'score']
    version = '1.0'

    metadata = {
        'width': width,
        'height': height,
        'species': 'DOG',
        'inspect': {
            'action': '엎드리는 동작',
            'emotion': '화남/불쾌'
        }    
        # 'video_name' : video_name,
        # 'resolution' : resolution,
        # 'num_frame' : num_frame,
        # 'num_keypoints' : num_keypoints,
        # 'keypoint_channels' : keypoint_channels,
        # 'version' : version
    }

    annotations = list()

    for ind, rows in enumerate(csv_data) :
        if ind < 4 :
            continue

        frame_index = int(rows[0])
        keypoints = dict()
        for i in range(0, int((len(rows) - 1)/3)) :
            dic = {'x': rows[3*i+1], 'y': rows[3*i+2], 'score': rows[3*i+3]}
            keypoints[str(i+1)] = dic

        person_id = None
        id = 0

        annot = {
            'frame_number' : frame_index,
            # 'id' : id,
            # 'person_id' : person_id,
            'keypoints' : keypoints
        }
        annotations.append(annot)

    category_id = 1
    
    full = {
        'metadata' : metadata,
        # 'category_id' : category_id,
        'annotations' : annotations
    }

    with open(os.path.join(temp_path,'anno_json', video_name + ".json"), 'w') as outfile :
        json.dump(full, outfile)

def skeleton_analysis(species, model_path) : 
    config_path = os.path.join(model_path, species, "test.yaml")
    cfg = Config.fromfile(config_path)

    # replace pre_defined arguments in configuration files
    def replace(cfg, **format_args):
        if isinstance(cfg, str):
            return cfg.format(**format_args)
        if isinstance(cfg, dict):
            for k, v in cfg.items():
                set_attr(cfg, k, replace(v, **format_args))
        elif isinstance(cfg, list):
            for k in range(len(cfg)):
                cfg[k] = replace(cfg[k], **format_args)
        return cfg

    format_args = dict()
    format_args['config_path'] = config_path
    format_args['config_name'] = os.path.basename(format_args['config_path'])
    format_args['config_prefix'] = format_args['config_name'].split('.')[0]
    cfg = replace(cfg, **format_args)

    pcr_cfg = cfg.processor_cfg

    results = recognition.test(pcr_cfg.model_cfg, pcr_cfg.dataset_cfg, pcr_cfg.checkpoint, batch_size=3, gpu_batch_size=3, gpus=1, workers=16)
    
    return results[0]


def skeleton_train(species, model_path) : 
    config_path = os.path.join(model_path, 'train', species + "_train.yaml")
    cfg = Config.fromfile(config_path)

    # replace pre_defined arguments in configuration files
    def replace(cfg, **format_args):
        if isinstance(cfg, str):
            return cfg.format(**format_args)
        if isinstance(cfg, dict):
            for k, v in cfg.items():
                set_attr(cfg, k, replace(v, **format_args))
        elif isinstance(cfg, list):
            for k in range(len(cfg)):
                cfg[k] = replace(cfg[k], **format_args)
        return cfg

    format_args = dict()
    format_args['config_path'] = config_path
    format_args['config_name'] = os.path.basename(format_args['config_path'])
    format_args['config_prefix'] = format_args['config_name'].split('.')[0]
    cfg = replace(cfg, **format_args)
    
    pcr_cfg = cfg.processor_cfg

    recognition.train(pcr_cfg.work_dir, pcr_cfg.model_cfg, pcr_cfg.loss_cfg, pcr_cfg.dataset_cfg, pcr_cfg.optimizer_cfg, pcr_cfg.total_epochs, pcr_cfg.training_hooks, batch_size = 3, gpu_batch_size = 3, workflow = pcr_cfg.workflow, gpus = 1)
    
    print('Train SUCCESED!')

def skeleton_test(species, model_path) : 
    config_path = os.path.join(model_path, 'test', species + "_test.yaml")
    cfg = Config.fromfile(config_path)

    # replace pre_defined arguments in configuration files
    def replace(cfg, **format_args):
        if isinstance(cfg, str):
            return cfg.format(**format_args)
        if isinstance(cfg, dict):
            for k, v in cfg.items():
                set_attr(cfg, k, replace(v, **format_args))
        elif isinstance(cfg, list):
            for k in range(len(cfg)):
                cfg[k] = replace(cfg[k], **format_args)
        return cfg

    format_args = dict()
    format_args['config_path'] = config_path
    format_args['config_name'] = os.path.basename(format_args['config_path'])
    format_args['config_prefix'] = format_args['config_name'].split('.')[0]
    cfg = replace(cfg, **format_args)

    pcr_cfg = cfg.processor_cfg

    results = recognition.test(pcr_cfg.model_cfg, pcr_cfg.dataset_cfg, pcr_cfg.checkpoint, batch_size=3, gpu_batch_size=3, gpus=1, workers=16)
    
    result = results[0]

    action_dict = {
        'DOG' : ['걷거나 뜀', '엎드리는 동작', '몸을 긁는 동작', '몸을 터는 동작', '두 앞발을 들어 올리는 동작', '앞발 하나를 들어 올림', '머리를 앞으로 들이미는 동작', '배와 목을 보여주며 눕는 동작', '마운팅하는 동작', '앉는 동작', '꼬리를 위로 올리고 흔드는 동작', '꼬리를 아래로 내리는 동작'],
        'CAT' : ['tailing', 'laydown', 'grooming', 'footpush', 'walkrun', 'sitdown', 'armstretch', 'roll', 'getdown', 'lying', 'heading', 'arch']
    }
    emotion_dict = {
        'DOG' : ['편안_안정', '행복_즐거움', '화남_불쾌', '불안_슬픔']
    }
    
    result = result.tolist()
    
    rank = result.copy()
    rank.sort(reverse = True)

    action_result = dict()
    for value in rank :
        action_result[action_dict[species.upper()][result.index(value)]] = str(value * 100) + '%'

    return action_result
