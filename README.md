# SuS-X: Training-Free Name-Only Transfer of Vision-Language Models [![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/release/python-360/) [![PyTorch](https://img.shields.io/badge/PyTorch-grey.svg?logo=PyTorch)](https://pytorch.org/blog/pytorch-1.9-released/) [![Paper](http://img.shields.io/badge/paper-arxiv.2211.16198-B31B1B.svg)](https://arxiv.org/abs/2211.16198)

Official code for the ICCV'23 paper ["SuS-X: Training-Free Name-Only Transfer of Vision-Language Models"](https://vishaal27.github.io/SuS-X-webpage/). Authors: [Vishaal Udandarao](http://vishaal27.github.io/), [Ankush Gupta](https://ankushgupta.org/) and [Samuel Albanie](http://samuelalbanie.com/).

## About this fork
In this repo we introduce some changes to further evaluate SuS-X especially for Domain Adaptation:
- [Code adaptation](https://github.com/halixness/SuS-X/blob/68ea1e91a9d866ecd77f7394f54609a51a495617/dataloader.py#L409) to use run evals on [DomainNet](http://ai.bu.edu/M3SDA/)
- [Modifications](https://github.com/halixness/SuS-X/blob/68ea1e91a9d866ecd77f7394f54609a51a495617/tipx.py#L143C28-L143C44) to evaluate SuS-X with few shot learning (K-shots)
- [Per-class](https://github.com/halixness/SuS-X/blob/main/tipx_classes.py) valuation across distribution shifts with [DomainNet](http://ai.bu.edu/M3SDA/)

## Introduction
Contrastive Language-Image Pre-training (CLIP) has emerged as a simple yet effective way to train large-scale vision-language models. CLIP demonstrates impressive zero-shot classification and retrieval on diverse downstream tasks. However, to leverage its full potential, fine-tuning still appears to be necessary. Fine-tuning the entire CLIP model can be resource-intensive and unstable. Moreover, recent methods that aim to circumvent this need for
fine-tuning still require access to images from the target distribution. We pursue a different approach and explore the regime of training-free "name-only transfer" in which the only knowledge we possess about the downstream task comprises the names of downstream target categories. We propose a novel method, SuS-X, consisting of two key building blocks: "SuS" and "TIP-X", that requires neither intensive fine-tuning nor costly labelled data. SuS-X achieves state-of-the-art zero-shot classification results on 19 benchmark datasets. We further show the utility of TIP-X in the training-free few-shot setting, where we again achieve state-of-the-art results over strong training-free baselines.
![SuS-X diagram](https://github.com/vishaal27/SuS-X/blob/main/figs/cvpr-susx-diagram.png)

## Getting started
All our code was tested on Python 3.6.8 with Pytorch 1.9.0+cu111. Ideally, our scripts require access to a single GPU (uses `.cuda()` for inference). Inference can also be done on CPUs with minimal changes to the scripts.

#### Setting up environments
We recommend setting up a python virtual environment and installing all the requirements. Please follow these steps to set up the project folder correctly:

```bash
git clone https://github.com/vishaal27/SuS-X.git
cd SuS-X

python3 -m venv ./env
source env/bin/activate

pip install -r requirements.txt
```

#### Setting up datasets
We provide detailed instructions on how to set up our datasets in [`data/DATA.md`](https://github.com/vishaal27/SuS-X/blob/main/data/DATA.md).

#### Directory structure
After setting up the datasets and the environment, the project root folder should look like this:
```
SuS-X/
|–– data
|–––– ucf101
|–––– ... 18 other datasets
|–– features
|–– gpt3_prompts
|–––– CuPL_prompts_ucf101.json
|–––– ... 18 other dataset json files
|–– README.md
|–– clip.py
|–– ... all other provided python scripts
```

## Running the baselines

#### Zero-shot CLIP
You can run Zero-shot CLIP inference using:
```bash
python run_zs_baseline.py --dataset <dataset> --backbone <CLIP_visual_backbone>
```
The `backbone` parameter can be one of [`RN50`, `RN101`, `ViT-B/32`, `ViT-B/16`].

#### CALIP
You can run our re-implementation of the CALIP baseline using:
```bash
python run_calip_baseline.py --dataset <dataset> --backbone <CLIP_visual_backbone>
```

#### CuPL
You can run the CuPL and CuPL+e baselines using:
```bash
python run_cupl_baseline.py --dataset <dataset> --backbone <CLIP_visual_backbone>
```
This script will also save the CuPL and CuPL+e text classifier weights into `features/`.

## SuS Construction
We provide scripts for both SuS-SD generation and SuS-LC retrieval.

#### *Photo* prompting strategy
The prompts used for the *Photo* prompting strategy can be found in [`utils/prompts_helper.py`](https://github.com/vishaal27/SuS-X/blob/main/utils/prompts_helper.py).

#### *CuPL* prompting strategy
To generate customised *CuPL* prompts using GPT-3, we require access to an OpenAI token. Please create an account on OpenAI and find your key under the [keys tab](https://beta.openai.com/account/api-keys). Please ensure that the key is in the format `sk-xxxxxxxxx`.
You can then run the following command to generate *CuPL* prompts for any dataset:
```bash
python generate_gpt3_prompts.py --dataset <dataset> --openai_key <openai_key>
```
For ensuring reproducibility, we provide all 19 dataset *CuPL* prompt files generated by us (and used for SuS generation and CuPL inference) in [`gpt3-prompts`](https://github.com/vishaal27/SuS-X/tree/main/gpt3_prompts).

#### SuS-SD generation
For generating images using the [Stable-Diffusion v1-4 checkpoint](https://huggingface.co/CompVis/stable-diffusion-v1-4), we need a huggingface token. Please create an account on huggingface and find your token under the [access tokens tab](https://huggingface.co/settings/tokens). Please ensure that the token is in the format `hf_xxxxxxxxx`.
You can then generate the support set images using the command:
```bash
python generate_sd_sus.py --dataset <dataset> --num_images <number_of_images_per_class> --prompt_shorthand <prompting_strategy> --huggingface_key <huggingface_token>
```
`<prompting_strategy>` is `photo` for the *Photo* strategy and `cupl` for the *CuPL* strategy (refer Sec. 3.1 of the paper for more details).The generated support set is saved in `data/sus-sd/<dataset>/<prompting_strategy>`.

#### SuS-LC retrieval
There are two steps for correctly creating the SuS-LC support sets: 
1. Downloading the URLs of the top-ranked images from LAION-5B. You can download the URLs for the images in the support set using:
```bash
python retrieve_urls_lc.py --dataset <dataset> --num_images <number_of_image_urls_per_class> --prompt_shorthand <prompting_strategy>
```
This will download all the URLs for the images to be downloaded in `data/sus-lc/download_urls/<dataset>/<prompting_strategy>`.

2. Downloading the top-ranked images using the downloaded URLs. You can download the support set images using:
```bash
python retrieve_images_lc_sus.py --dataset <dataset> --num_images <number_of_images_per_class> --prompt_shorthand <prompting_strategy>
```
The generated support set is saved in `data/sus-lc/<dataset>/<prompting_strategy>`.

## Constructing the features

#### Test, validation and few-shot features
You can create the test and validation image features using:
```bash
python encode_datasets.py --dataset <dataset>
```
This script will save the test, validation and few-shot features in `features/`.

#### SuS features
You can create the curated SuS features using:
```bash
# for SuS-LC
python encode_sus_lc.py --dataset <dataset> --prompt_shorthand <prompting_strategy>
# for SuS-SD
python encode_sus_sd.py --dataset <dataset> --prompt_shorthand <prompting_strategy>
```
These scripts will save the respective SuS image features in `features/`.

#### Text classifier weights
You can create the different text classifier weights using:
```bash
python generate_text_classifier_weights.py --dataset <dataset>
```
This script will again save all the text classifier weights in `features/`.

For ensuring reproducibility, we release the features used for all our baselines and our best performing SuS-X-LC-P model [here](https://drive.google.com/drive/u/0/folders/1nzRf13Ha1gvKP_n_4a_JreplA0QkHGBh). We further provide detailed descriptions of the naming of the feature files in [`features/FEATURES.md`](https://github.com/vishaal27/SuS-X/blob/main/features/FEATURES.md).

## TIP-X Inference
Once you have correctly saved all the feature files, you can run TIP-X using:
```bash
python tipx.py --dataset <dataset> --backbone <CLIP_visual_backbone> --prompt_shorthand <prompting_strategy> --sus_type <SuS_type>
```
The `sus_type` parameter is `lc` for SuS-LC and `sd` for SuS-SD.

### Few-shot inference
It is possible to run evals with a support set composed by few samples from the target distribution. To achieve this, set `sus_type` to a parameter in `[sd, lc, k1, k2, k4, k8, k16]`.
```
python tipx.py --dataset <dataset> --backbone <visualBackbone> --prompt_shorthand <promptStrategy> --sus_type <mode>
```

### DomainNet evaluation
Firstly you need to download the zip files from [here](http://ai.bu.edu/M3SDA/) (cleaned version) and extract them under `data/`. Please include the annotation `.txt` files under the subset folder, e.g. `data/clipart/clipart_train.txt`. You will need to generate the splits `.json` file like the other datasets (don't put the "domainnet_" prefix here):
```
python generate_splits.py --dataset clipart
```
Encoding the dataset features and generating a support set with stable diffusion is achievable in the same way as originally defined in this repo. Pipeline scripts can be found under `scripts/run_*`.
Subsets with different domains can be tested by setting `dataset` to one of the following: `[domainnet_sketch, domainnet_quickdraw, domainnet_infograph, domainnet_real, domainnet_clipart]`.
```
python tipx.py --dataset <dataset> --backbone <visualBackbone> --prompt_shorthand <promptStrategy> --sus_type <mode>
```
## Citation
If you found this work useful, please consider citing it as:
```
@inproceedings{udandarao2022sus-x,
  title={SuS-X: Training-Free Name-Only Transfer of Vision-Language Models},
  author={Udandarao, Vishaal and Gupta, Ankush and Albanie, Samuel},
  booktitle={ICCV},
  year={2023}
}
```

## Acknowledgements
We build on several previous well-maintained repositories like [CLIP](https://github.com/openai/CLIP/tree/main/clip), [CoOp](https://github.com/KaiyangZhou/CoOp/), [CLIP-Adapter](https://github.com/gaopengcuhk/CLIP-Adapter), [TIP-Adapter](https://github.com/gaopengcuhk/Tip-Adapter/) and [CuPL](https://github.com/sarahpratt/CuPL). We thank the authors for providing such amazing code, and enabling further research towards better vision-language model adaptation. We also thank the authors of the amazing [Stable-Diffusion](https://stability.ai/blog/stable-diffusion-public-release) and [LAION-5B](https://laion.ai/blog/laion-5b/) projects, both of which are pivotal components of our method.

## Contact
Please feel free to open an issue or email us at [vu214@cam.ac.uk](mailto:vu214@cam.ac.uk).
