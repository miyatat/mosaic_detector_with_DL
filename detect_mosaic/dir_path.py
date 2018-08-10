# -*- coding: utf-8 -*-

from logging import getLogger
import os

logger = getLogger(__name__)

SRC_DIR_NAME = os.path.dirname(os.path.abspath(__file__))


def join_and_makedirs(*keys):
    path_name = ''
    for key in keys:
        path_name = os.path.join(path_name, key)
    os.makedirs(path_name, exist_ok=True)
    return path_name


STORAGE_DIR_NAME = join_and_makedirs(SRC_DIR_NAME, 'storage')
TRAIN_IMG_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'train_img')
TRAIN_ANNOT_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'train_annot')
TEST_IMG_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'test_img')
TEST_ANNOT_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'test_annot')
VALID_IMG_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'valid_img')
VALID_ANNOT_DIR_NAME = join_and_makedirs(STORAGE_DIR_NAME, 'valid_annot')

SAMPLE_PATH_NAME = os.path.join(STORAGE_DIR_NAME, '0001TP_006690.png')


if __name__ == '__main__':
    pass
