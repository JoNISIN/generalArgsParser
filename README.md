# 一個簡單的通用程式語言參數解析框架
<!--# A simple argument parser framework for general programming languages-->

## 專案簡介

這是一個玩具性質參數解析框架，其源自於自身對於腳本撰寫的需求。雖然Haskell的hackage已經有了不少相關的實現，python3標準庫中也已經有`argparse`。這些實現雖然功能強大且完善，但是對於純粹的讀入參數作為變數以建構當前執行環境的需求上這些實現都過於複雜而且帶有強烈的語言特徵。

這個框架功能上的目的旨在以最小的程式語言特性實現*字串參數列表*到*key->value*的函數映射，並提供足以拓展為複雜框架的基礎設施。

另一方面，這項專案原先是Haskell語言版本，而後拓展為python物件導向版本。雖然這倆程式語言不論是程式語言本身風格或者大眾印象上差距都極大，但在這個拓展的實現過程中卻都以極其相似的方式實現了相仿的功能。這使我注意到這個框架本身也是現代程式語言常用資料結構(list與dict/Map)的操作示例。

因此，此專案發布在Github上的主要目的是提供在學習新程式語言的人可以藉由此專案內的源碼更加直觀地了解到程式語言之間邏輯上的異同。除了Haskell與Python之外，未來也可能會再提供其他語言的實現版本。

## 功能簡介

這個框架在python與haskell上操作都十分的相似，先是使用*值對*定義要解析器(設定)和其初始值，解析器(函數)再分析參數的字串列表為專用的*key-value*結構，最終使用特定函數取得*key-value*結果。

接下來是Hasekll版本與python版本的簡單演示，該演示同樣存在於原始碼中的`main`與`if __name__='__main__' :`中測試。

### Haskell
```haskell
args <- getArgs -- haskell讀取參數
let parser  = setParser [("-v",0),("--echo",1)] -- 定義key名稱與key所需的參數數量
let parser' = setDefaultFromList parser [("-v",Nothing),("--echo",Just ["Hello, workd!"])] -- 定義key的初始值
let parsed = parseArgsList parser' args -- 解析參數
print $ parsedSeq parsed                -- 未被特定key接收的有序列表(剩餘參數)
print $ isTrigger parsed "-v"           -- 不需要額外參數，僅確認是否啟用選項
print $ parsedArgOf parsed "hi"         -- 不存在的key回傳空字串
print $ parsedArgOf parsed "--echo"     -- 存在的key回傳指定字串
```

### Python
```python
p = argpaser ({'--echo':1,'-v':0})  # 定義key名稱與key所需的參數數量
p.setDefaultFrom({'--echo':'HI'})   # 定義key的初始值
p.parsingArgs(sys.argv)             # 解析參數
print(p.parsedSeq())                # 未被特定key接收的有序列表(剩餘參數)
print (p.isTrigger('-v'))           # 不需要額外參數，僅確認是否啟用選項
print (p.parsedArgOf('--echo'))     # 存在的key回傳指定字串
print (p.parsedArgOf('hi'))         # 不存在的key回傳空字串
```