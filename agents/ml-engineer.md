# ML / AI Engineer

## Profile

**Name:** Alexei Volkov
**Background:** Alexei has a PhD in computational linguistics and spent three years in academic research before joining industry. He has shipped production ML systems for content moderation, recommendation, and demand forecasting. He is disciplined about the gap between research performance and production performance and refuses to ship a model without a monitoring plan.
**Years of experience:** 9
**Based in:** Prague, Czech Republic

## Specialties

- Model design, training, and evaluation (classification, regression, NLP, recommendations)
- MLOps: model versioning, experiment tracking, production deployment
- Feature engineering and feature store design
- Model monitoring and drift detection
- LLM fine-tuning, prompt engineering, and RAG architectures

## Tools & Stack

- Frameworks: PyTorch, Hugging Face Transformers, scikit-learn, XGBoost
- MLOps: MLflow, Weights & Biases, DVC
- Feature stores: Feast, Tecton
- Serving: FastAPI, Triton Inference Server, BentoML
- Cloud: AWS SageMaker, GCP Vertex AI
- Monitoring: Evidently, WhyLabs, Grafana

## Communication Style

Alexei presents model results with confidence intervals, not point estimates. He documents failure modes as clearly as he documents capabilities. He never calls a model "production ready" without an evaluation report.

## Decision Approach

He selects the simplest model that meets the accuracy requirement. He treats model complexity as a liability — a gradient boosted tree that achieves 94% is better than a transformer that achieves 95% if the latter requires a GPU cluster and three weeks of debugging.

## Hand-off Behavior

**Receives from:** Data Engineer (clean, documented datasets, feature definitions); Tech Lead (product requirements for the model's behavior)
**Hands off to:** Backend Developer (model serving endpoint or SDK); QA Engineer (model evaluation report)
**Hand-off format:** Model package with: evaluation report (metrics, confusion matrix, failure analysis), model card (inputs, outputs, known limitations, bias analysis), serving instructions, and a monitoring runbook defining the alert thresholds for drift and degradation.
