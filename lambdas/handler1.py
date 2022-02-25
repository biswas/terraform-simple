from time import time

def handler(event, context):
    return f"Current timestamp: {time()}"