import pandas as pd
from sklearn import metrics
import os
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator

os.environ["CUDA_VISIBLE_DEVICES"]="8"

animal_name='dog'
# ache_name='유루증'
modelPath = '/home/jupyter-j7a204/pet_eye_code/model_saved/'+animal_name+'/resnet_v1_152_30/'  # 모델이 저장된 경로
# modelPath = './model_saved/train/efficientnet_200/'  # 모델이 저장된 경로
weight = 'model-002-0.544700-0.460239.h5'        # 학습된 모델의 파일이름
test_Path = '/home/jupyter-j7a204/pet_eye_data/validation/'+animal_name+'/eye/general/' # 테스트 이미지 폴더

model = load_model(modelPath + weight)
datagen_test = ImageDataGenerator(rescale=1./255)
generator_test = datagen_test.flow_from_directory(directory=test_Path,
                                                  target_size=(224, 224),
                                                  batch_size=256,
                                                  shuffle=False)

# model로 test set 추론
generator_test.reset()
cls_test = generator_test.classes
cls_pred = model.predict_generator(generator_test, verbose=1, workers=0)
cls_pred_argmax = cls_pred.argmax(axis=1)

# 결과 산출 및 저장
report = metrics.classification_report(y_true=cls_test, y_pred=cls_pred_argmax, output_dict=True)
report = pd.DataFrame(report).transpose()
report.to_csv('./output/'+animal_name+'/resnet_v1_152_30'+f'/report_test_{weight[:-3]}.csv', index=True, encoding='cp949')
print(report)