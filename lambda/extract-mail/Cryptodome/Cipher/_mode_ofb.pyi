from typing import Union, overload

from Cryptodome.Util._raw_api import SmartPointer

Buffer = Union[bytes, bytearray, memoryview]

__all__ = ['OfbMode']

class OfbMode(object):
    block_size: int
    iv: Buffer
    IV: Buffer

    def __init__(self,
                 block_cipher: SmartPointer,
                 iv: Buffer) -> None: ...
    @overload
    def encrypt(self, plaintext: Buffer) -> bytes: ...
    @overload
    def encrypt(self, plaintext: Buffer, output: Union[bytearray, memoryview]) -> None: ...
    @overload
    def decrypt(self, plaintext: Buffer) -> bytes: ...
    @overload
    def decrypt(self, plaintext: Buffer, output: Union[bytearray, memoryview]) -> None: ...