import json
import os
import argparse
from tqdm import tqdm
import random

parser = argparse.ArgumentParser()
parser.add_argument('--dataset', type=str, required=True)
args = parser.parse_args()
train_labels_txt = os.path.join("data", f"{args.dataset}_train.txt")
test_labels_txt = os.path.join("data", f"{args.dataset}_test.txt")
dataset = {"train": [], "val": [], "test": []}

def read_splitfile(path:str, dataset:dict, split:str):
    with open(path, "r") as f:
        lines = f.readlines()
        for l in tqdm(lines):
            path, label = l.split(" ")[0], int(l.split(" ")[1])
            classname = path.split("/")[1]
            path = "/".join(path.split("/")[1:])
            dataset[split].append([path, label, classname])

read_splitfile(train_labels_txt, dataset, "train")
read_splitfile(test_labels_txt, dataset, "test")
val_idx =  random.sample(range(0, len(dataset["test"])-1), int(0.1*len(dataset["test"])))
dataset["val"] = [dataset["test"][idx] for idx in val_idx]

with open(os.path.join("data", f"{args.dataset}", f"split_{args.dataset}.json"), 'w') as f:
    json.dump(dataset, f)