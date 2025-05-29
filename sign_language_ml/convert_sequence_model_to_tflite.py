import tensorflow as tf
import numpy as np
from tensorflow.keras.models import load_model

def representative_dataset_gen():
    """
    Génère des données représentatives pour la quantification
    """
    for _ in range(10):
        # Forme: [batch_size=1, height=224, width=224, channels=3]
        yield [np.random.random((1, 224, 224, 3)).astype(np.float32)]

def convert_model_to_tflite(model_path, output_path):
    """
    Convertir un modèle H5 (TensorFlow/Keras) en format TensorFlow Lite (.tflite)
    """
    try:
        # Charger le modèle .h5
        model = load_model(model_path, compile=False)
        print(f"✅ Input shape: {model.input_shape}")  # Should be (None, 224, 224, 3)
        print(f"✅ Output shape: {model.output_shape}")  # Should be (None, 257)
    except Exception as e:
        print(f"❌ Error loading model: {e}")
        return

    # Créer le convertisseur
    converter = tf.lite.TFLiteConverter.from_keras_model(model)

    # Appliquer l'optimisation
    converter.optimizations = [tf.lite.Optimize.DEFAULT]

    # Supporter les opérations TensorFlow non natives
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS,
        tf.lite.OpsSet.SELECT_TF_OPS
    ]

    # Activer la quantification float
    converter.representative_dataset = representative_dataset_gen
    converter.inference_input_type = tf.float32
    converter.inference_output_type = tf.float32

    try:
        # Convertir le modèle
        tflite_model = converter.convert()

        # Sauvegarder le modèle .tflite
        with open(output_path, 'wb') as f:
            f.write(tflite_model)

        print(f"✅ Modèle converti avec succès : {output_path}")
        print(f"📦 Taille du modèle : {len(tflite_model) / 1024 / 1024:.2f} MB")
    except Exception as e:
        print(f"❌ Error converting model to TFLite: {e}")

if __name__ == "__main__":
    convert_model_to_tflite(
        'best_model_single_frame.h5',
        'tunisian_sign_single_frame_model.tflite'
    )