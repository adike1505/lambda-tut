from __future__ import print_function
from config.config_loader import ConfigLoader
import json
import uuid

print('Loading function')


def lambda_handler(event, context):
    config = ConfigLoader().config()
    uuid_val = uuid.uuid4().hex
    return json_doc(uuid_val)
    #raise Exception('Something went wrong')
def json_doc(uuid):
    doc = {"uuid": uuid}
    return json.dumps(doc)

if __name__ == "__main__":
    print(lambda_handler(event, context))