import os
import shutil
import subprocess
import tempfile

from jinja2 import Environment, FileSystemLoader


class TerraformService:
    """Service utility to render Terraform templates and run Terraform commands."""

    def __init__(self, template_dir: str):
        self.template_dir = template_dir
        self.env = Environment(loader=FileSystemLoader(self.template_dir), autoescape=False)

    def _render_template(self, template_name: str, context: dict, dest_path: str) -> None:
        template = self.env.get_template(template_name)
        with open(dest_path, 'w') as f:
            f.write(template.render(context))

    def apply(self, variables: dict) -> str:
        """Render templates, run `terraform init` and `terraform apply`.

        Returns the stdout of the apply command.
        """
        work_dir = tempfile.mkdtemp(prefix="terraform_")
        try:
            self._render_template('main.tf.j2', variables, os.path.join(work_dir, 'main.tf'))
            shutil.copy(os.path.join(self.template_dir, 'variables.tf'), os.path.join(work_dir, 'variables.tf'))
            self._render_template('terraform.tfvars.j2', variables, os.path.join(work_dir, 'terraform.tfvars'))

            init = subprocess.run(['terraform', 'init'], cwd=work_dir, capture_output=True, text=True)
            if init.returncode != 0:
                raise RuntimeError(init.stderr)

            apply = subprocess.run(['terraform', 'apply', '-auto-approve'], cwd=work_dir, capture_output=True, text=True)
            if apply.returncode != 0:
                raise RuntimeError(apply.stderr)
            return apply.stdout
        finally:
            shutil.rmtree(work_dir, ignore_errors=True)
