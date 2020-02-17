#Face Recognition with AWS Rekognition
This repository is a python implementation of the below github repo. 
https://github.com/leodsti/AWS_Tutorials/tree/master/Rekognition

## AWS Credentials
Copy and paste your AWS credentials into the file ~/.aws/credentials

## Setup Virtual environment
Run the below commands in windows powershell. The commands will install/upgrade pi create a virtual environment 'env'. Activate the environment and install 3 python packages needed for the application server to run.

python -m pip install --upgrade pip
py -m venv env
.\env\Scripts\activate
pip install boto3
pip install flask
pip install Flask-Cors

## Start the Flask application
From the command prompt run the following command:

python server.py

- This flask app has two endpoints, and accepts requests on port 5000:
/register
/rekognition

The 'register' endpoint saves the image in S3 bucket and indexes the face.
The 'rekognition' endpoint save the image in S3 bucket and invokes the search_faces_by_image method to get a similarity score.

## Run face compare
The DSTIFamily.html html file can be run directly in the browser or in a web server. Use the register button to save the webcam image capture on an S3 bucket. After the image has been save the rekognition method index_faces is used to index the face. Clicking on the 'Rekognize' button/feature will send another image to S3 and then the search_faces_by_image method is used to a comparison. A  json object is returned by the flask app to the UI to indicate the similarity.
