promptStrategy=cupl
HFKEY=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
nSupportImages=101 # batch size is 5, it must be higher
dataset=caltech101
visualBackbone=RN50

# ---- SuS-SD
# generate support set
python generate_sd_sus.py --dataset $dataset --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY
# encode dataset features
python encode_sus_sd.py --dataset $dataset --prompt_shorthand $promptStrategy
# inference
python generate_text_classifier_weights.py --dataset $dataset
# for some reason, this will also generate the combined prompt strategy weights
python run_cupl_baseline.py --dataset $dataset --backbone $backbone
# benchmarking
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd
