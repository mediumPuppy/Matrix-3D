#!/bin/bash
set -e  # Exit on error

# Verify CUDA is available
if ! command -v nvcc &> /dev/null; then
    echo "Error: nvcc not found. Please install CUDA toolkit first."
    exit 1
fi
echo "CUDA version: $(nvcc --version | grep release)"

echo "[1/6] Installing Submodules..."
cd ./submodules/nvdiffrast/
pip install . --no-build-isolation

cd ../simple-knn/
python setup.py install
cd ../../

echo "[2/6] Installing diff-gaussian-rasterization..."
pip install git+https://github.com/rmurai0610/diff-gaussian-rasterization-w-pose.git --no-build-isolation

echo "[3/6] Cloning and installing ODGS..."
if [ ! -d "ODGS" ]; then
    git clone --recursive https://github.com/esw0116/ODGS.git
fi
cd ODGS
pip install ./submodules/odgs-gaussian-rasterization --no-build-isolation
cd ..

echo "[4/6] Installing DiffSynth-Studio..."
cd code/DiffSynth-Studio/     # Fixed path
pip install -e .
cd ../..

echo "[5/6] Installing Python dependencies..."
# Fix for RunPod: blinker is pre-installed via distutils and blocks pip uninstall
pip install --ignore-installed blinker
pip install plyfile decord ffmpeg trimesh pyrender xfuser diffusers open3d py360convert
pip install "git+https://github.com/facebookresearch/pytorch3d.git@v0.7.9" --no-build-isolation
pip install peft easydict torchsde open-clip-torch==2.7.0 fairscale natsort
pip install realesrgan
pip install flash-attn==2.7.4.post1 --no-build-isolation
pip install git+https://github.com/EasternJournalist/utils3d.git#egg=utils3d --no-build-isolation
pip install xformers==0.0.27.post2 --no-build-isolation
pip install jaxtyping==0.3.2
pip install modelscope==1.28.2
pip install diffusers==0.34.0
pip install matplotlib==3.8.4
pip install transformers==4.56.0
pip install torchmetrics==0.7.0
pip install OmegaConf==2.1.1
pip install imageio-ffmpeg==0.6.0
pip install pytorch-lightning==2.4.0
pip install omegaconf==2.1.1
pip install webdataset==0.2.5
pip install kornia==0.6
pip install streamlit==1.12.1
pip install einops==0.8.0
pip install open_clip_torch
pip install SwissArmyTransformer==0.4.12
pip install wandb==0.21.1
pip install -e git+https://github.com/CompVis/taming-transformers.git@master#egg=taming-transformers
pip uninstall -y basicsr
pip install openai-clip

echo "[6/6] Installation complete!"
