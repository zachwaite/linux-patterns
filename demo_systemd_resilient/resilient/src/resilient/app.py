import argparse
import json
import logging
import sys
import time

from pydantic import BaseModel
from result import Err, Ok, Result

__version__ = "0.0.1"
_logger = logging.getLogger(__name__)


class AppError(BaseModel):
    kind: str
    msg: str = ""


def read_config(configfile: str) -> Result[dict, AppError]:
    try:
        with open(configfile, "r") as f:
            return Ok(json.load(f))
    except Exception as ex:
        kind = ex.__class__.__name__
        msg = str(ex)
        return Err(AppError(kind=kind, msg=msg))


def print_output(data: dict) -> Result[None, AppError]:
    _logger.info(data)
    return Ok(None)


def mainloop(configfile: str):
    while True:
        rs = read_config(configfile).and_then(print_output)
        if rs.is_err():
            e = rs.unwrap_err()
            _logger.error(f"{e.__class__.__name__}({str(e)})")
            _logger.error("Exiting gracefully")
            sys.exit(1)
        # simulate some delay
        time.sleep(5)


def main():
    # configure argparser
    global __version__
    parser = argparse.ArgumentParser(f"Resilient - { __version__ }\n")
    parser.add_argument("--logfile", default=None)
    requiredNamed = parser.add_argument_group("Required named arguments")
    requiredNamed.add_argument("-c", "--configfile", required=True)
    args = parser.parse_args()

    # configure logging
    try:
        if args.logfile:
            logging.basicConfig(
                format="%(asctime)s %(levelname)-8s %(message)s",
                filename=args.logfile,
                filemode="w",
                level=logging.INFO,
            )
            _logger.info(f"Using logfile: {args.logfile}")
        else:
            ConsoleLogger = logging.StreamHandler()
            _logger.addHandler(ConsoleLogger)
    except:
        raise IOError(f"Unable to open logfile {args.logfile}")
    # run app
    mainloop(args.configfile)
