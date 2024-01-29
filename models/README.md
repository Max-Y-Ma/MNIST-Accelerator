# Setup
- Run `pip install -r requirements.txt`

# Usage
- Run `mnist_feed_forward.py` to test the feed forward neural network.
    - A output directory with exported weights and biases will be generate.

# About
- The feed forward neural network consists of three input layers.
    - 784 input `Linear Layer`, consisting of 20 output nodes.
    - 20 input `ReLU Layer`, consisting of 20 output nodes.
    - 20 input `Linear Layer`, consisting of 10 output nodes.
- An argmax is applied to the output vector, producing the predicted digit.