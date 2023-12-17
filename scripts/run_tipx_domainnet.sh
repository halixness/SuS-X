promptStrategy=photo
HFKEY=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
nSupportImages=4
batchSize=2
inferenceSteps=20
visualBackbone=RN50
# encode standard dataset
python encode_datasets.py --dataset $1
# generate support set
python generate_sd_sus.py --dataset $1 --num_images $nSupportImages --prompt_shorthand $promptStrategy --huggingface_key $HFKEY
# encode dataset features
python encode_sus_sd.py --dataset $1 --prompt_shorthand $promptStrategy
# inference
python generate_text_classifier_weights.py --dataset $1
# benchmarking
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --text_prompt_type ensemble > benchmark_sussd_$1.log
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --text_prompt_type ensemble --support_set_type k1  > benchmark_susk1_$1.log
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --text_prompt_type ensemble --support_set_type k2  > benchmark_susk2_$1.log
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --text_prompt_type ensemble --support_set_type k4  > benchmark_susk4_$1.log
python tipx.py --dataset $1 --backbone $visualBackbone --prompt_shorthand $promptStrategy --sus_type sd --text_prompt_type ensemble --support_set_type k8  > benchmark_susk8_$1.log