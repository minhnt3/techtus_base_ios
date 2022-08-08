## Naming convention
**1. Setup swiftlint:**

Để sử dụng được swiftlint chúng ta sẽ cài đặt qua brew theo câu lệnh sau:
```swift   
brew install swiftlint
```    
- **Tích hợp với Xcode: **

Ta sẽ cần tích hợp với Xcode để SwiftLint phân tích code và hiển thị các cảnh báo và lỗi trên IDE khi build code. Ta sẽ thêm "“Run Script Phase” với nội dung như sau:
```swift
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
``` 
- **Các quy tắc của swiftlint**

* Các quy tắc của swiftlint sẽ được quy định ở file .swiftlint.yml

* Cấu hình luật bao gồm:
```swift
disabled_rules: danh sách các luật không sử dụng
opt_in_rules: danh sách các luật sử sụng
analyzer_rules: các luật cho bộ phân tích cú pháp
```
* Note: Có thể tham khảo qua đường dẫn sau https://realm.github.io/SwiftLint/rule-directory.html
* Cuối cùng chúng ta build để xem kết quả phân tích của swiftlint

**2. Đặt tên trong file Localizable**

- Quy tắc đặt tên cho cho các control/title/message của các màn hình cụ thể: {Tên screen/Tên Custom View}.{Loại control/message/title}.snake_case_key
```swift
      ex: "loginscreen.label.user_name" = "Username";
          "loginscreen.title.login" = "LOGIN";
          "loginscreen.message.login_success" = "Login successfull";
          "registerscreen.button.register" = "Register";
          "countryPopup.label.country_name" = "Country name";
```

- Quy tắc đặt tên cho cho các control/title/message của không thuộc màn hình nào: common.{message/title}.snake_case_key
```swift
      ex: "common.title.error" = "Error
          "common.title.ok"  = "OK"
          "common.message.service_nointernet" = "ServiceError: Network not conected!";
```
**3. Đặt tên cho Model**
* Quy tắc đối với Model từ Backend: Object + Data
```swift
ex: UserData
```
* Quy tắc đối với Model hiển thị lên UI: Object + Model
```swift
ex: UserModel
```
* Quy tắc đặt tên cho class mapper: Model từ backend + Mapper
```swift
ex: UserData+Mapper
```
