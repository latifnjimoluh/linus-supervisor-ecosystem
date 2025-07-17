from flask import Blueprint, request, jsonify

from services.terraform_service import TerraformService


deploy_bp = Blueprint("deploy", __name__)
terraform_service = TerraformService(template_dir="templates")


@deploy_bp.route("/")
def hello():
    return "✅ Backend Flask opérationnel"


@deploy_bp.route("/deploy", methods=["POST"])
def deploy():
    data = request.get_json() or {}
    try:
        output = terraform_service.apply(data)
        return jsonify({"status": "ok", "output": output})
    except Exception as e:
        return jsonify({"status": "error", "error": str(e)}), 500
