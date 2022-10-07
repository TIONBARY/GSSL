from typing import Union

from fastapi import FastAPI

import os
os.environ['KMP_DUPLICATE_LIB_OK']='True'

import dlcmm

app = FastAPI()

@app.get("/action")
def action_reg():
    result = dlcmm.action_recognition('DOG')
    dic = {}
    for action in result.keys() :
        dic[action] = result[action]
    return dic
