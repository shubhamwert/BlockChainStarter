from flask import Flask
from flask_cors import CORS
app=Flask(__name__)
CORS(app)

# compiled_code=compile



from app import routes
