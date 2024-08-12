FROM pytorch/pytorch:2.1.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -yq build-essential git ca-certificates ninja-build python3-opencv
RUN conda env create -n eva_sdfusion -f environment.yml
RUN echo "source activate eva_sdfusion" > ~/.bashrc

# set dataset path, I put in "SDFusion/data"
ENV DETECTRON2_DATASETS /app/SDFusion/data
ENV PATH /opt/conda/envs/eva_sdfusion/bin:$PATH


# install mmcv-full
RUN mim install mmcv-full==1.7.2

# install pytorch & pytorch3d
RUN pip install "git+https://github.com/facebookresearch/pytorch3d.git"

# install apex 
RUN git clone https://github.com/NVIDIA/apex && cd apex && \
    pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --global-option="--cpp_ext" --global-option="--cuda_ext" ./

# build EVA-02/det/Detectron2 from source:
RUN cd EVA && python -m pip install -e .

# Combined (beta)
# CMD [ "cd", "EVA", "&&", "python", "tools/lazyconfig_train_net.py", "--config-file",\ 
#       "projects/ViTDet/configs/eva2_mim_to_coco/eva2_coco_cascade_mask_rcnn_vitdet_b_4attn_1024_lrd0p7.py",\
#       "--eval-only",  "train.init_checkpoint=./ckpt/eva02_B_coco_bsl.pth", "&&",\
#       "cd", "../SDFusion", "&&", "python", "test.py"]
CMD [ "/bin/bash", "-c", "cd EVA && python tools/lazyconfig_train_net.py \
      --config-file projects/ViTDet/configs/eva2_mim_to_coco/eva2_coco_cascade_mask_rcnn_vitdet_b_4attn_1024_lrd0p7.py \
      --eval-only train.init_checkpoint=./ckpt/eva02_B_coco_bsl.pth && cd ../SDFusion && \
      python test.py --save_result --out_dir demo_results"]

# About running docker:
# Please use volume to access your local dataset: -v /Host/path/to/dataset:/Docker/path/to/dataset
# Also use volume to access your mesh output: -v /Host/path/to/results:/Docker/path/to/results
# docker run --gpus all -it -v ~/dataDisk/Dataset:/app/SDFusion/data\
#   -v ~/dataDisk/EVA_SDFusion/SDFusion/demo_results:/app/SDFusion/demo_results sdfusion

# Note: For EVA
# python tools/lazyconfig_train_net.py --config-file projects/ViTDet/configs/eva2_mim_to_coco/eva2_coco_cascade_mask_rcnn_vitdet_b_4attn_1024_lrd0p7.py --eval-only train.init_checkpoint=./ckpt/eva02_B_coco_bsl.pth

# Note: For SDFusion
# python test.py