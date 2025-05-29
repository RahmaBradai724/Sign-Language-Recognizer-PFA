import tensorflow as tf
import numpy as np

interpreter = tf.lite.Interpreter(model_path='tunisian_sign_single_frame_model.tflite')
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("Input shape:", input_details[0]['shape'])  # Should be [1, 224, 224, 3]
print("Output shape:", output_details[0]['shape'])  # Should be [1, 257]

# Test with random input
input_data = np.random.random((1, 224, 224, 3)).astype(np.float32)
interpreter.set_tensor(input_details[0]['index'], input_data)
interpreter.invoke()
output_data = interpreter.get_tensor(output_details[0]['index'])
print("Prediction shape:", output_data.shape)  # Should be [1, 257]
print("Prediction sample:", output_data[0][:5])  # Print first 5 probabilities