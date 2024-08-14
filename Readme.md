# EVA_SDFusion
## Download
```bash
git clone https://github.com/Kevin-Shih/EVA_SDFusion.git
cd EVA_SDFusion
git submodule update --init --recursive
```

## Prepare data
COCO dataset, please download `2017 Val images` from [COCO official website](https://cocodataset.org/#download). You can put it anywhere you like, just rememeber to specify the path when running the docker.
Overall, the structure of dataset should look like:
```
/Host/path/to/dataset
├── coco
      ├── val2017
```

## Prepare ckpt
### For EVA
Use link below to get the ckpt and put it under `EVA/ckpt/`.
```bash
wget https://huggingface.co/Yuxin-CV/EVA-02/resolve/main/eva02/det/eva02_B_coco_bsl.pth -O EVA/ckpt/eva02_B_coco_bsl.pth
```

### For SDFusion
Use links below to get the ckpt and put it under `SDFusion/saved_ckpt/`.
```bash
mkdir SDFusion/saved_ckpt
# VQVAE's checkpoint
wget https://uofi.box.com/shared/static/zdb9pm9wmxaupzclc7m8gzluj20ja0b6.pth -O SDFusion/saved_ckpt/vqvae-snet-all.pth

# SDFusion
wget https://uofi.box.com/shared/static/ueo01ctnlzobp2dmvd8iexy1bdsquuc1.pth -O SDFusion/saved_ckpt/sdfusion-snet-all.pth

# SDFusion: img2shape
wget https://uofi.box.com/shared/static/01hnf7pbewft4115qkvv9zhh22v4d8ma.pth -O SDFusion/saved_ckpt/sdfusion-img2shape.pth
```

## Build & Run Docker
Your datasets should place at `/Host/path/to/dataset` and the output results will put under `/Host/path/to/save/results`.
```bash
docker build -t sdfusion:latest .
docker run --gpus all -it -v /Host/path/to/dataset:/app/SDFusion/data\
       -v /Host/path/to/save/results:/app/SDFusion/demo_results sdfusion
```
