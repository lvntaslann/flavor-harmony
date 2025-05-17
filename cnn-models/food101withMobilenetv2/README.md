# food101
# Transfer Learning with MobileNetV2 on the Food101 Dataset

We employed transfer learning methods using the MobileNetV2 model to achieve high-accuracy results on the Food101 dataset. Various experiments were conducted with different configurations to optimize performance.

## Experiments

### MobileNetV2

- **Batch Size:** 50
- **Image Size:** 224x224
- **Epochs:** 30

### MobileNetV2 Attempt 2

- **Batch Size:** 32
- **Image Size:** 224x224
- **Epochs:** 20
- **Weights:** 'imagenet'

### MobileNetV2 Attempt 3

- **Batch Size:** 32
- **Image Size:** 224x224
- **Epochs:** 20
- **Weights:** 'imagenet'

### MobileNetV2 Attempt 4

- **Batch Size:** 16
- **Image Size:** 224x224
- **Learning Rate:** 0.001
- **Momentum:** 0.9
- **Dropout Rate:** 0.2
- **L2 Regularization:** 0.001

### MobileNetV2 Attempt 5

- **Batch Size:** 16
- **Image Size:** 224x224
- **Learning Rate:** 0.001
- **Momentum:** 0.95
- **Dropout Rate:** 0.3
- **L2 Regularization:** 0.005

### Fine-Tuning MobileNetV2 Attempt 5

- **Batch Size:** 16
- **Image Size:** 224x224
- **Learning Rate:** 0.0001
- **Momentum:** 0.95
- **Dropout Rate:** 0.3
- **L2 Regularization:** 0.005

### Dataset URL
- https://www.kaggle.com/datasets/dansbecker/food-101/data
