from flask import Blueprint

deploy_bp = Blueprint("deploy", __name__)

@deploy_bp.route("/")
def hello():
    return "✅ Backend Flask opérationnel"
