

class caesarEncrypt:
    def __init__(self,shift_value=3):
        self.shift=shift_value
    def encrypt(self,strin : str):
        self.encrypt=''
        for i in strin:
            self.encrypt=self.encrypt+chr(self.shift+ord(i))
        return self.encrypt
    def decrypt(self,estring=None):
        decrypted_string=""
        if estring:
            enc_str=self.encrypt
        else:
            if self.encrypt:
                enc_str=estring
            else:
                print("Object already have a value encrypted\n decrypting given string")
                enc_str=estring
        for i in enc_str:
            decrypted_string=decrypted_string+chr(ord(i)-self.shift)
        return decrypted_string

#rsa and ecc
