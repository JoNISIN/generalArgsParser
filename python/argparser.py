import sys

class argpaser () :
    def __init__(self, dict_key_argc):
        self.key_argc = dict_key_argc
        self.key_argv = {k:None for k in self.key_argc}
        self.arglst = []

    def setDefaultFrom(self,keyargc) :
        for k in keyargc :
            if k in self.key_argc :
                self.key_argv[k] = keyargc[k]

    def parsingArgs (self,args):
        if len(args) > 0 :
            s = args.pop(0)
            take = 0
            if s in self.key_argc :
                self.key_argv[s] = args[:self.key_argc[s]]
                take = self.key_argc[s]
            else :
                self.arglst.append(s)
                take = 0
            self.parsingArgs(args[take:])

    def parsedSeq (self) :
        return self.arglst
    
    def parsedKey (self,key) :
        if key in self.key_argv :
            return self.key_argv[key]
        else :
            return None
    
    def parsedArgOf (self,key) :
        res = self.parsedKey(key)
        if res :
            return res[0]
        else :
            return ''
    
    def isTrigger (self,key) :
        if self.key_argv[key] != None :
            return True
        else :
            return False

if __name__ == '__main__' :
    p = argpaser ({'--echo':1,'-v':0})
    p.setDefaultFrom({'--echo':'HI'})
    p.parsingArgs(sys.argv)
    print(p.parsedSeq())
    print (p.isTrigger('-v'))
    print (p.parsedArgOf('--echo'))
    print (p.parsedArgOf('hi'))
