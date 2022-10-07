from typing import Union

from fastapi import FastAPI

import os
os.environ['KMP_DUPLICATE_LIB_OK']='True'

import dlcmm

@app.get("/action")
def action_reg():
    result = dlcmm.action_recognition('DOG')
    return result



def main():
    # dlcmm.skeleton_train('cat', './model/trained_model')
    # dlcmm.skeleton_train('dog', './model/trained_model')
    
    result = dlcmm.action_recognition('DOG')
    print("\n\n-----------------------------------------------\n")
    for action in result.keys() :
        print(action, result[action])

if __name__ == "__main__":
    main()
