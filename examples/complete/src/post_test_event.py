# -*- coding: utf-8 -*-

# Copyright 2023 The Littlebirdie Authors.
"""Post Test Event."""

import json

from aws_lambda_powertools import Logger, Metrics, Tracer
from aws_lambda_powertools.metrics import MetricUnit
from aws_lambda_powertools.utilities import parameters
from aws_lambda_powertools.utilities.typing import LambdaContext

tracer = Tracer()
metrics = Metrics()
logger = Logger(log_uncaught_exceptions=True)


@logger.inject_lambda_context()
@tracer.capture_lambda_handler
def handler(event: dict, context: LambdaContext) -> str:

    logger.set_correlation_id(context.aws_request_id)

    logger.info(f"Serviced called with event: {event}")

    return {
        "statusCode": 200,
        "body": json.dumps(event, indent=4)
    }
