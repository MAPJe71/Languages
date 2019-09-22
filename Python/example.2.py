# Liste der reservierten Schlüsselwörter in Python
from Tkinter import *

tkroot = Tk()

def die():
    tkroot.destroy()
    sys.exit(0)

def fenster(nachricht):
    tkroot.title("Schlüsselworte in Python")
    w = Label(tkroot, text=nachricht)
    w.grid(row=0,column=0)
    b = Button(tkroot,text="Ende",command=die)
    b.grid(row=1,column=0)
    tkroot.mainloop()



# main!

schluessel = """and, assert, break, class, continue, def, del,
elif, else, except, exec, finally,
for, from, global, if, import, in, is, lambda, not,
or, pass, print, raise, return, try, while
"""
fenster("Liste der Python-Schlüsselworte: \n" + schluessel)