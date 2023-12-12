promptStrategy=cupl
HFKEY=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
OAIKEY=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
nSupportImages=25 # batch size is 5, it must be higher
dataset=cifar10
visualBackbone=RN50

# ---- SuS-SD
# generate support set
# python generate_gpt3_prompts.py --dataset $dataset --openai_key $OAIKEY
# python generate_sd_sus.py --dataset $dataset --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY
# encode dataset features
# python encode_sus_sd.py --dataset $dataset --prompt_shorthand $promptStrategy
# inference
# python generate_text_classifier_weights.py --dataset $dataset
# python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd > benchmark_sussd_$dataset.log
python encode_datasets.py --dataset $dataset
python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd --support_set_type k1
