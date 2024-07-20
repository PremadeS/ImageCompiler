![Cloud Vision API](https://img.shields.io/badge/Google%20Vision%20API-v1-blue)   	 ![](https://img.shields.io/badge/flutter-v3.22.2-blue)  	  ![python](https://img.shields.io/badge/python-v3.11.9-red)

# ImageCompiler

Pretty mid looking **app** based on [flutter](https://flutter.dev/) and [python](https://www.python.org/) that *supposedly* runs hand written code from an image. Text detection using [Google Cloud Vision](https://cloud.google.com/vision/docs) and execution using g++ compiler *(currently only works on c++ because every other language is bad)*

# How to

## Run the server:

* **Clone** and **cd** into repo 

  ```bash
  git clone https://github.com/PremadeS/ImageCompiler
  cd ImageCompiler
  
  ```

* Install the required libraries

  ```bash
  pip install google-cloud-vision
  pip install Flask
  ```

* Change the `key_path` in `main.py` to your Cloud Vision API key, [How to download your key in json format](https://www.youtube.com/watch?v=hkKKfEqZvn4)

  ```python
  key_path = 'path-to-your-key.json' 
  ```

* Run 

  ```bash
  python3 server.py
  ```

## Run the app:

```bash
cd flutter_app
flutter run
```

## Note:

* The *IP address* for both **app** and **server** is set to `127.0.0.1:5000` by default

# Supports:

* C/C++