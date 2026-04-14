import os.path
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torch.utils.data.dataloader import DataLoader
import torchvision
from PIL import Image
import PIL
import numpy as np
import matplotlib.pyplot as plt
from torch.utils.data import Dataset
import math
from tqdm.auto import tqdm
from torchvision.transforms.functional import to_pil_image
import random

import http.server
import socketserver
import os
from http import HTTPStatus
from io import BytesIO
from flask import Flask, render_template, request, send_file
# import js2py

# #Super-Resolution model
# class VDSR(nn.Module):
#   def __init__(self):
#     super(VDSR, self).__init__()
#     self.input = nn.Conv2d(3, 64 ,3, padding=1, bias=False)
#     self.conv = nn.ModuleList([
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#       nn.Conv2d(64, 64, 3, padding=1, bias=False),
#     ])
#     self.output = nn.Conv2d(64, 3, 3, padding=1, bias=False)

#     for m in self.modules():
#       if isinstance(m, nn.Conv2d):
#         torch.nn.init.kaiming_uniform_(m.weight)

#   def forward(self, data):
#     x = F.relu(self.input(data))
#     for conv_layer in self.conv:
#       x = F.relu(conv_layer(x))
#     x = self.output(x)
#     return torch.add(x, data)
  
PATH = '/Users/hyeon-seongkim/Desktop/2-2/Computernetwork/Project/Honor Project/'

# criterion = nn.MSELoss()
# net = VDSR().to('mps')
# optimizer = optim.Adam(net.parameters(), lr=1e-4)
# checkpoint = torch.load(PATH+'VDSR_ep_79.pt', map_location=torch.device('mps'))
# net.load_state_dict(checkpoint['model_state_dict'])

app = Flask(__name__, template_folder=PATH)

# Use Flask for handling image upload and display
@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        if file:
            image_data = file.read()
            image = Image.open(BytesIO(image_data))
            # PIL_tensor = torchvision.transforms.ToTensor()
            # image_tensor = PIL_tensor(image).to('mps')
            # print(image_tensor.shape)
            # from torchvision.transforms.functional import to_pil_image
            # image_tensor = torchvision.transforms.RandomCrop(size=64)(image_tensor)
            # enhanced_image = to_pil_image(net(image_tensor).detach().cpu())
            temp_path = 'temp.jpeg'
            # enhanced_image.save(temp_path)

            return render_template('display.html', image_path=temp_path)

    return render_template('upload.html')

if __name__ == '__main__':
    app.run(port=8000)