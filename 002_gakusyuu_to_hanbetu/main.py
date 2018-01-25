import tensorflow as tf
import model

FLAGS = tf.app.flags.FLAGS

tf.app.flags.DEFINE_string('ckpt_for_test', '', """ checkpoint file for test""")
tf.app.flags.DEFINE_string('ckpt_for_finetune', '', """ checkpoint file for finetune""")
tf.app.flags.DEFINE_integer('batch_size', "5", """ batch_size """)
tf.app.flags.DEFINE_float('learning_rate', "0.001", """ initial lr """)
tf.app.flags.DEFINE_string('log_dir', "./Logs", """ dir to store ckpt """)
tf.app.flags.DEFINE_string('train_image_list', "./filelist_train.txt", """ path to CamVid image """)
tf.app.flags.DEFINE_string('test_image_list', "./filelist_test.txt", """ path to CamVid test image """)
tf.app.flags.DEFINE_string('val_image_list', "./filelist_val.txt", """ path to CamVid val image """)
tf.app.flags.DEFINE_integer('iterations', "20000", """ iteration """)
tf.app.flags.DEFINE_integer('image_h', "360", """ image height """)
tf.app.flags.DEFINE_integer('image_w', "480", """ image width """)
tf.app.flags.DEFINE_integer('image_c', "3", """ image channel (RGB) """)
tf.app.flags.DEFINE_boolean('save_image', True, """ whether to save predicted image """)
tf.app.flags.DEFINE_integer('num_classes', "3", """ total class number """)
tf.app.flags.DEFINE_string('loss_weight', '[0.1,0.2,2.0]', """ weight balancing """)

def checkArgs():
    if FLAGS.ckpt_for_test != '':
        print('The mode is set to Testing')
        print("check point file: %s"%FLAGS.ckpt_for_test)
        print("test image file list: %s"%FLAGS.test_image_list)
        print("save image: %s", FLAGS.save_image)
    elif FLAGS.ckpt_for_finetune != '':
        print('The mode is set to Finetune from ckpt')
        print("training Iteration: %d"%FLAGS.iterations)
        print("check point file: %s"%FLAGS.ckpt_for_finetune)
        print("train image file list: %s"%FLAGS.train_image_list)
        print("val image file list: %s"%FLAGS.val_image_list)
    else:
        print('The mode is set to Training')
        print("training Iteration: %d"%FLAGS.iterations)
        print("Initial lr: %f"%FLAGS.learning_rate)
        print("train image file list: %s"%FLAGS.train_image_list)
        print("val image file list: %s"%FLAGS.val_image_list)

    print("Batch Size: %d"%FLAGS.batch_size)
    print("Log dir: %s"%FLAGS.log_dir)
    print("image H: %d"%FLAGS.image_h)
    print("image W: %d"%FLAGS.image_w)
    print("image C: %d"%FLAGS.image_c)
    print("Num Classes: %d"%FLAGS.num_classes)
    print("loss_weight: %s"%FLAGS.loss_weight)


def main(args):
    checkArgs()
    if FLAGS.ckpt_for_test:
        model.test(FLAGS)
    elif FLAGS.ckpt_for_finetune:
        model.training(FLAGS, is_finetune=True)
    else:
        model.training(FLAGS, is_finetune=False)

if __name__ == '__main__':
  tf.app.run()
