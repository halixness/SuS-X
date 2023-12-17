promptStrategy=photo
HFKEY=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
nSupportImages=4 # batch size is 5, it must be higher
batchSize=2
inferenceSteps=20
visualBackbone=RN50

python encode_datasets.py --dataset $dataset
python generate_sd_sus.py --dataset $1 --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size $batchSize --num_inference_steps $inferenceSteps
python encode_sus_sd.py --dataset $1 --prompt_shorthand $promptStrategy
python generate_text_classifier_weights.py --dataset $1
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd > benchmark_sussd_$1.log

# ---- SuS-SD
# generate support set
# python generate_gpt3_prompts.py --dataset $dataset --openai_key $OAIKEY
# python generate_sd_sus.py --dataset $dataset --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY --batch_size 3
# encode dataset features
# python encode_sus_sd.py --dataset $dataset --prompt_shorthand $promptStrategy
# inference
# 
# python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd > benchmark_sussd_$dataset.log
# python encode_datasets.py --dataset $dataset
# python tipx.py --dataset $dataset --backbone $visualBackbone --prompt_shorthand $promptStrategy --text_prompt_type ensemble --sus_type sd --support_set_type k1