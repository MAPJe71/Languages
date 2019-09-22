# Fix the "In Python the variable "def" not working correctly in Function List"
# i've tested it with following files:

USER_DEF = 1000

def test2():
pass

def test():
print("hello")
def a():
pass

# there is the same problem
USER_CLASS = 67

class Test:

USER_DEF = 1000

def test2():
	pass

def test():
	print("hello")

def a():
	pass

def b():
pass

USER_DEF = 1000

class Test:

def test2():
	pass

def test():
	print("hello")

def a():
	pass

def b():

USER_CLASS = 1000

class Test:

def test2():
	pass

def test():
	print("hello")

def a():
	pass

def b():