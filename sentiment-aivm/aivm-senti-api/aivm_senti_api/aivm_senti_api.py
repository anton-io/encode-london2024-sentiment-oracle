#!/usr/bin/env python3

import os
import torch

import aivm_client as aic

from flask import Flask, request, jsonify

################################################################################################
# Set-up the model.
MODEL_NAME = "bert-tiny-sentiment-analysis"
resolve = lambda x: "-" if torch.argmax(x) == 0 else "+" if torch.argmax(x) == 2 else "="

path = os.path.join(os.path.dirname(__file__), "twitter_bert_tiny.onnx")
try:
    aic.upload_bert_tiny_model(path, MODEL_NAME)
    print("Model successfully uploaded.")
except:
    pass


################################################################################################
# Sense function
def sense(message):
    tokens = aic.tokenize(message)
    inputs = aic.BertTinyCryptensor(*tokens)
    result = aic.get_prediction(inputs, MODEL_NAME)
    sentiment = resolve(result)
    return sentiment


################################################################################################
# Setup Flask end-points.
app = Flask(__name__)


@app.route("/")
def route_index():
    return "aivm sentiment analysis."


@app.route("/sense", methods=['POST'])
def route_sense():
    data = request.json
    message = data['message']
    sentiment = sense(message)
    return jsonify(sentiment=sentiment)


def main():
    app.run(host="0.0.0.0", port=8888, debug=True)


if __name__ == "__main__":
    main()
