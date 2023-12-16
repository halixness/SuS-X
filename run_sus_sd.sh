promptStrategy=photo
HFKEY=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
nSupportImages=25 # batch size is 5, it must be higher
visualBackbone=RN50

# Diego
python generate_sd_sus.py --dataset domainnet_clipart --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3
python generate_sd_sus.py --dataset domainnet_infograph --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3

# Egidia
python generate_sd_sus.py --dataset domainnet_sketch --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3
python generate_sd_sus.py --dataset domainnet_quickdraw --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3

# Chris
python generate_sd_sus.py --dataset domainnet_real --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3
python generate_sd_sus.py --dataset domainnet_painting --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3

# ---- SuS-SD
# generate support set
# python generate_gpt3_prompts.py --dataset $dataset --openai_key $OAIKEY
# python generate_sd_sus.py --dataset $dataset --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3
# encode dataset features
# python encode_sus_sd.py --dataset $dataset --prompt_shorthand $promptStrategy
# inference
# python generate_text_classifier_weights.py --dataset $dataset
# python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd > benchmark_sussd_$dataset.log
# python encode_datasets.py --dataset $dataset
# python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd --support_set_type k1