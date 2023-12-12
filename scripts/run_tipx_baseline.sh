dataset=cifar10
backbone=RN50

python run_zs_baseline.py --dataset $dataset --backbone $backbone
python run_calip_baseline.py --dataset $dataset --backbone $backbone
python run_cupl_baseline.py --dataset $dataset --backbone $backbone