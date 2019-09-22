import logging

def createLogger(name):
    logger = logging.getLogger(name)
    hdlr = logging.FileHandler('test.log')
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    hdlr.setFormatter(formatter)
    logger.addHandler(hdlr)
    logger.setLevel(logging.DEBUG)
    return logger

class A():
    def __init__(self):
        self.logger = createLogger(self.__class__.__name__)
        self.logger.info("Elo " + self.__class__.__name__)

class B(A):
    def __init__(self):
        super(B, self).__init__()

a = A()
b = B()