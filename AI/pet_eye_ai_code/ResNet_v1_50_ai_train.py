from ResNet_ops_1 import *



# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/cat/eye/general/각막궤양/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/cat/eye/general/각막부골편/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/cat/eye/general/결막염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/cat/eye/general/비궤양성각막염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/cat/eye/general/안검염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/결막염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/궤양성각막염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/백내장/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/비궤양성각막질환/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/색소침착성각막염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/안검내반증/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/안검염/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/안검종양/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/유루증/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# train_path = '/home/jupyter-j7a204/pet_eye_data/training/TL1/dog/eye/general/' #경로 마지막에 반드시 '/'를 기입해야합니다.
# val_path = '/home/mark11/dog&cat/cat/Sequestrum/validation/'
model_name = 'inception_v4'
epoch = 50

if __name__ == '__main__':
    fine_tunning = Fine_tunning(train_path=train_path,
                                model_name=model_name,
                                epoch=epoch)
    history = fine_tunning.training()
    fine_tunning.save_accuracy(history)

