# -*- coding: utf-8 -*-

from logging import getLogger

from PIL import Image

from detect_mosaic.controllers.file_process_utils import get_all_file_path_in_dir
from detect_mosaic.dir_path import TEST_ANNOT_DIR_NAME, TEST_IMG_DIR_NAME, TRAIN_ANNOT_DIR_NAME, TRAIN_IMG_DIR_NAME,\
    VALID_ANNOT_DIR_NAME, VALID_IMG_DIR_NAME
logger = getLogger(__name__)

if __name__ == '__main__':
    dir_list = [
        TRAIN_IMG_DIR_NAME,
        TRAIN_ANNOT_DIR_NAME,
        TEST_IMG_DIR_NAME,
        TEST_ANNOT_DIR_NAME,
        VALID_IMG_DIR_NAME,
        VALID_ANNOT_DIR_NAME
    ]
    for dir_name in dir_list:
        file_list = get_all_file_path_in_dir(dir_name)
        for file_path in file_list:
            img = Image.open(file_path)
            img_resize = img.resize((640, 360))
            # img_resize.save(file_path.replace('.png', '_resize.png'))
            img_resize.save(file_path)
