from flask import Flask, request, jsonify
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS
import io
import boto3
import base64

app = Flask(__name__)
CORS(app)
api = Api(app)

image_key = 'ak_a19.jpg'
rek_image_key = 'ak_a19.jpg'
#s3_bucket = 'aks-kat-s3-boto-images'
#region_code = 'us-east-1'
s3_bucket = 'node-sdk-sample-leosouquet'
region_code = 'eu-west-1'

class RegisterImage(Resource):
    def post(self):
        print("inside RegisterImage class post METHOD")
        img_data = request.data
        with open("register.jpg", "wb") as fh:
            fh.write(base64.decodebytes(img_data[img_data.find(b',')+1:]))

        s3_client = boto3.client('s3')
        s3_response = s3_client.put_object(Body=base64.decodebytes(img_data[img_data.find(b',')+1:]), Bucket=s3_bucket, Key=image_key) 
        #Adding recognization code
        print(image_key,s3_bucket,region_code)
        rekog_client = boto3.client('rekognition', region_name=region_code)
        rekog_response = rekog_client.index_faces(
                CollectionId='myphotos',
                Image={
                    'S3Object': {
                        'Bucket': s3_bucket,
                        'Name': image_key
                    }
                },
                DetectionAttributes=[]
                    )
        print(rekog_response)
        return {"Status":"RegisterImage"}
        #return jsonify(rekog_response)

class RekognitionImage(Resource):
    def post(self):
        print("inside RekognitionImage class post METHOD")
        img_data = request.data
        with open("rekognition.jpg", "wb") as fh:
            fh.write(base64.decodebytes(img_data[img_data.find(b',')+1:]))

        s3_client = boto3.client('s3')
        s3_response = s3_client.put_object(Body=base64.decodebytes(img_data[img_data.find(b',')+1:]), Bucket=s3_bucket, Key=rek_image_key) 
        #Adding recognization code
        print(image_key,s3_bucket,region_code)
        rekog_client = boto3.client('rekognition', region_name=region_code)
        rekog_response = rekog_client.search_faces_by_image(
                CollectionId='myphotos',
                Image={
                    'S3Object': {
                        'Bucket': s3_bucket,
                        'Name': rek_image_key
                    }
                },
                FaceMatchThreshold = 95,
                MaxFaces = 1
                    )
        response_string = {}
        print(rekog_response)
        if len(rekog_response['FaceMatches']) > 0:
            response_string = {'Similarity' : rekog_response['FaceMatches'][0]['Similarity']}
            print("Similarity : {}".format(rekog_response['FaceMatches'][0]['Similarity']))
        else:
            response_string = {'Similarity' : 0}
            print("face not matched")
        return jsonify(response_string)



api.add_resource(RegisterImage, '/register')
api.add_resource(RekognitionImage, '/rekognition')

if __name__ == '__main__':
    app.run(port=5000, debug=True)