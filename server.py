import subprocess
from flask import Flask,request
import os
from google.cloud import vision
import io

key_path = 'path-to-your-key.json' #Imp stuff...

app = Flask(__name__)


UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return 'No image part in the request', 400

    file = request.files['image']
    if file.filename == '':
        return 'No selected file', 400

    if file:
        filepath = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(filepath)
        return ocr_with_vision(filepath), 200

@app.route('/compile', methods=['POST'])
def compile_code():
    
    data = request.json
    code = data.get('text')
    with open('code.cpp', 'w') as file:
        file.write(code)
    compile_process = subprocess.run(['g++', 'code.cpp', '-o', 'output'], capture_output=True, text=True)

    if compile_process.returncode != 0:
       return(f'Error:\n{compile_process.stderr}')
    
    run_process = subprocess.run(['./output'], capture_output=True, text=True)

    if run_process.returncode == 0:
        return(f'Output:\n{run_process.stdout}')
    else:
        return(f'Error:\n{run_process.stderr}')


def ocr_with_vision(image_path):        # Using google cloud vision
    try:
        client = vision.ImageAnnotatorClient.from_service_account_file(key_path)

        with io.open(image_path, 'rb') as image_file:
            content = image_file.read()

        image = vision.Image(content=content)

        response = client.text_detection(image=image)
        texts = response.text_annotations

        annotation = response.full_text_annotation

        text_output = []

        for page in annotation.pages:
            for block in page.blocks:
                block_text = ''
                for paragraph in block.paragraphs:
                    paragraph_text = ' '.join(''.join(symbol.text for symbol in word.symbols) for word in paragraph.words)
                    block_text += paragraph_text  # All of this just to make it pleasing to look at
                text_output.append(block_text.strip())

        return '\n'.join(text_output)
    
    except Exception as e:
        return f"Error : {e}. Please try again"
    


if __name__ == '__main__':
    app.run(debug=True)
    #print(ocr_with_tesseract('test.jpg'))
