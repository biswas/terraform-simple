from time import time
import logging, logging.config

def load_logging_config():
    """Basic logging config, customizable."""
    logconf = logging.getLogger()
    logconf.setLevel(logging.INFO)
    return logconf

# Create logger
logger = load_logging_config()

def handler(event, context):
    logger.debug("""***Lambda function starting...***""")
    logger.info(f"\n\nCurrent timestamp: {time()}\n\n")