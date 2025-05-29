from flask import Flask, request, jsonify, send_from_directory
import tensorflow as tf
import numpy as np
import json
import os

app = Flask(__name__, static_folder='frontend', static_url_path='')

# Load your ML model
MODEL_PATH = 'best_model_single_frame.h5'
model = tf.keras.models.load_model(MODEL_PATH)

# Load class mapping
with open('dataset_structure.json', 'r') as f:
    class_mapping = json.load(f)

@app.route('/')
def serve_frontend():
    # Serve Flutter's index.html
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/<path:path>')
def serve_static(path):
    # Serve other frontend static files (JS, CSS, etc)
    return send_from_directory(app.static_folder, path)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    # Example: input data should have "frame" key with the image/frame data (processed)
    # Here you need to adjust preprocessing based on your model input requirements

    frame = data.get('frame')
    if frame is None:
        return jsonify({'error': 'No frame data provided'}), 400

    # Convert frame data to numpy array and preprocess (dummy example)
    # frame_np = np.array(frame)  # shape & dtype must match your model input
    # frame_np = frame_np.reshape((1, height, width, channels))  # adapt shape

    # For example purposes, let's assume frame_np is ready to predict:
    # preds = model.predict(frame_np)
    # pred_class_idx = np.argmax(preds, axis=1)[0]
    # pred_class = class_mapping.get(str(pred_class_idx), "Unknown")

    # Since real preprocessing depends on your data, here is dummy response:
    pred_class = "dummy_prediction"

    return jsonify({'prediction': pred_class})


if __name__ == '__main__':
    app.run(debug=True)
