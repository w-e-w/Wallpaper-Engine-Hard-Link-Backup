# Wallpaper-Engine-Hard-Link-Backup
Preventing Steam from deleting Wallpaper Engine's workshop wallpapers by using hard links as backup

防止Steam刪除壁紙的工具

[English](README.md), [繁體中文](README.zh-TW.md), [简体中文](README.zh-CN.md)

在`疑難排解指南與常見問題集`介紹到一個問題
https://help.wallpaperengine.io/zh-tw/steam/backup.html
> 因故刪除 Steam 中的桌布時，Steam 也會將桌布從電腦中刪除。 Wallpaper Engine 無法防止這點，如果會對您造成困擾，您可以備份桌布。

官方提供的應對方式是自己建立壁紙備份，但這麼做的缺點是會占用一倍的儲存空間

雖然可以備份後再取消壁紙的訂閱但這麼做麻煩，而且無法收到壁紙的更新

---
## 這個項目的目標是
 1. 防止Steam刪除壁紙
 2. 在不浪費儲存空間的前提
- 使用`硬連結`實現

---
## 硬連結是什麼 (簡化說明)
硬連結（英語：hard link）
我們在檔案系統中看到的`檔案物件`其實並不是`檔案資料`本身

這個`檔案物件`其實是一個告訴電腦`檔案資料`存在裝置的哪裡的一份資訊

這個`檔案物件`叫做`硬連結`

一個`檔案資料`必須只少有一個對應的`硬連結`，`硬連結`可以同時存在多個

一個`檔案資料`只有在它所有的`硬連結`都被刪除後才會被刪除

注:

1. 多個`硬連結`不會增加你的儲存空間使用量，但因為Windows計算檔案大小的方式看能會看似佔用了大量空間，若要確認可以查看至裝置的使用量確認空間使用狀況
2. 假設`file A`和`file B`是同一個`檔案資料`的`硬連結`, 若對`file A`進行編輯，`file B`也會一同變化，因為這兩個是同一個`file data`
3. 嚴格上來說所有的`檔案物件`都是`硬連結`但一般不會稱這個稱互，尤其是當`檔案物件`和`硬連結`是一對一對應時不會這麼稱互.

### 若慾了解更詳細關於`硬連結`的資訊請找其他資訊

---

## 工作原理
將壁紙檔案額外建立一份`硬連結`，當Steam嘗試刪除原檔案後，檔案因為還存在額外的`硬連結`所以不會真的刪除

---
## 腳本功能/作用
- 建立`Steam Workshop下載`的`硬連結`備份
- 對`硬連結 (Hard Link copy)`和`Steam Workshop下載`進行比對，找出缺失的壁紙
- 如果發現有缺失的壁紙，則會將該壁紙移動到`資料夾`中
  - 腳本會嘗試判斷是`"使用者刪除"`或是`"Steam刪除"`
    1. 如果壁紙是在`Wallpaper Engine介面`關閉1分鐘內被刪除的，腳本會判斷為`"使用者刪除"`
    2. 若是在`Wallpaper Engine介面`啟動前被刪除的，腳本會判斷為`"Steam刪除"`
    3. 根據是`"使用者刪除"`或`"Steam刪除"`腳本會則會將該壁紙移動到不同的`資料夾`中
    - 這個判斷方式有缺陷
      1. 如果再`Wallpaper Engine介面`未啟動期間使用者使用網路瀏覽器`退訂`了壁紙，腳本會判斷為`"Steam刪除"`
      2. 或在`Wallpaper Engine介面`啟動期間`"Steam刪除"`某個壁紙，腳本會判斷為`"使用者刪除"`
      - 更進階的判斷方式有
        1. 透過網路獲取Steam Workshop資訊
        2. 確認壁紙是否存在
        - 以後可能會使用此方案
  - 若判斷為`"Steam刪除"`壁紙，會將壁紙移動到`備份 (Backups)`資料夾中，然後重新匯入Wallpaper Engine
  - 若判斷為`"使用者刪除"`壁紙，會將壁紙移動到`移除 (Removed)`資料夾中
    - 可以將`移除 (Removed)`當成類似"資源回收桶"的概念，確認內容確實是不需要的後手動刪除
    - 這麼做的原因是判斷可能有誤判的可能性
- 若有壁紙被誤判斷移動到`移除 (Removed)`資料夾中，你可以手動的移動到`備份 (Backups)`資料夾中以復原壁紙，反過來也是
    
---
## 腳本流程
1. 腳本會在背景執行
2. 定時性的確認`Wallpaper Engine介面`使否開啟，(預設每5秒檢查一次)
3. 若發現`Wallpaper Engine介面`啟動後
   1. 比對`硬連結 (Hard Link)`和`Steam Workshop下載`中的壁紙，是否有卻失
      1. 若發現缺失則會將壁紙移動到`備份 (Backups)`資料夾中
      2. 然後將`備份 (Backups)`資料夾中的壁紙匯入到Wallpaper engiene內
   2. `Wallpaper Engine介面`關閉後，開始`倒數計時`。(預設倒數1分鐘)
      1. `倒數計時`可被`Wallpaper Engine介面`的再度開啟打斷，若被打斷則會回到先期的步驟
      2. 到`倒數計時`完畢後
         1. 比對`硬連結 (Hard Link)`和`Steam Workshop下載`中的壁紙，是否有卻失
            1. 若發現缺失則會將壁紙移動到`移除 (Removed)`資料夾中
         2. 對`Steam Workshop下載`中的壁紙進行`硬連結 (Hard Link copy)`備份到`硬連結 (Hard links)`資料夾中
4. 循環

`倒數計時`的原應是給Steam足夠的時間刪除最近下載然後立刻刪除的壁紙，因為使用者可能下載壁紙後發現不喜歡力可刪除。

若`硬連結 (Hard Link copy)`是在`Wallpaper Engine介面`關閉後立可執行，則所以的壁紙包含不要的都會被備份。

---

## 使用方是
### 普通模式
1. 下載release page中的執行黨(exe)
2. 將exe存放在資料夾中然猴執行，有些生成某些檔案
   1. 其中會有個`config.ini`，這檔案是設定黨，用來調適功能的。
   2. 若你的Wallpaper Engine 不是安裝在預設的安裝位址，你會需要選取對應的自位置
      1. 你可能還會需要到`config.ini`進行額外的確認
   3. 你對被詢存防備份檔案的位置或使用預設位置
      - ( User\USER_NAME\Steam Workshop Backup\Wallpaper Engine\ )
      - **必須與`Steam Workshop下載`在同一碟上**
3. 你詢問您是否希望腳本在啟動時運行
   - 可以之後手動啟用`啟動時運行`
4. 確認`config.ini`設定正確後，再度執行exe
5. 腳本將在背景執行，更多資訊參考`腳本流程`

### Advance mode
下載
1. 複製整個repository
2. 若要自動化請安裝AutoHotkey
   
自動模式
- 使用AutoHotkey執行`Wallpaper Engine - Hard Links Backup.ahk`
  - 腳本會立刻在背景執行不會進行設定/確認`config.ini`是否正確
    - 如果你只打算這使用不進行修改，建議使用發布的exe
    - 
手動執行
- 在`Wallpaper Engine module`含有預先組合好的流程
- 根據需求使用

隨你怎麼用

---
## Steam Workshop 和 Wallpaper Engine behaviors 觀察
1. Steam 在任何時候都可以下載workshop當按
2. Steam 只會在`Wallpaper Engine介面`非執行時刪除檔案
3. 使用者使用`Wallpaper Engine介面`訂閱壁紙時，壁紙會被立刻下載
4. 使用者使用`Wallpaper Engine介面`退訂壁紙時，退訂的壁紙要等`Wallpaper Engine介面`關閉後才會被Steam刪除
---

## 警告
- 此腳本是設計給使用NTFS檔案系統的Windows電腦
  - 大部分使用Wallpaper Engine的電腦依該都適用
- 我曾在上面多次使用的到**`備份 或 Backup`**但這個不是個真正的備份工具
  - 這部不會對數據丟失有任何保護
  - 你的黨案只存在有一份
  
- Steam可能改變它們刪除檔案的方式
  - 某些刪除方式可以完全刪除掉有多硬連結的檔案
  - 如果Steam使用了改種類的刪除方式，此項目將會完全無用

- this tool is not designed for you to keep multiple versions of wallpaper
- 這個工具不是設計來進行多版本壁紙保存的
  - 隨然在某些條件下會有此作用
