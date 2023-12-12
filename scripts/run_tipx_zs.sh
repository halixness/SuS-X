# Run TIP-X on a dataset with zero-shot examples
promptStrategy=cupl
dataset=caltech101
visualBackbone=RN50

if echo $dataset* &>/dev/null
then
    echo [-] $dataset features found.
else
    echo [-] Generating $dataset features.
    python encode_datasets.py --dataset $dataset
fi

python run_cupl_baseline.py --dataset $dataset --backbone $visualBackbone
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --support_set_type k1
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --support_set_type k2
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --support_set_type k4
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --support_set_type k8
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --support_set_type k16
