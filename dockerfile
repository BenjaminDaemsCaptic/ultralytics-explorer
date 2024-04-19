FROM python:3.10.13-bullseye
RUN rm -rf /usr/lib/python* && rm -rf /usr/local/lib/python3.9 \
 && apt-get update -y \
 && apt-get install unzip libgl1 -y \
 && python3 -m pip install --upgrade pip \
 && python3 -m pip install --pre torch torchvision --force-reinstall --index-url https://download.pytorch.org/whl/nightly/cpu
COPY requirements.txt requirements.txt
RUN  pip install -r requirements.txt --no-cache-dir
COPY dataset.zip dataset.zip
RUN unzip /dataset.zip -d / && rm /dataset.zip
# ultralytics dataset path: /usr/local/lib/python3.10/site-packages/ultralytics/cfg/datasets
RUN rm /usr/local/lib/python3.10/site-packages/ultralytics/cfg/datasets/*.yaml \
    && sed -i 's/coco128.yaml/dataset.yaml/g' /usr/local/lib/python3.10/site-packages/ultralytics/data/explorer/gui/dash.py \
    && cp /dataset/dataset.yaml /usr/local/lib/python3.10/site-packages/ultralytics/cfg/datasets \
    && apt remove unzip -y
CMD yolo explorer