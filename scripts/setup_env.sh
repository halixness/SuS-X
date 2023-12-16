eval "$(conda shell.bash hook)"
conda create -n susx python=3.8 -y
conda activate susx
pip install clip_retrieval==2.29.1 diffusers ftfy numpy openai Pillow regex setuptools torch torchvision tqdm