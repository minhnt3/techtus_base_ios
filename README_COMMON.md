## Hướng dẫn sử dụng lib, Services trong template
###1. PullLoader cho UITableView, UICollectionView, UIScrollVIew
   * Pull to refresh
     - Chỉ cần sử dụng lệnh tableView.pullLoader.addPullToRefresh và chúng ta sẽ handle refresh ở đây
     - Sau khi refresh thành công chỉ cần stopPullToRefresh
   * Load more
     - Chỉ cần sử dụng lệnh tableView.pullLoader.addInfiniteScrolling và chúng ta sẽ handle loadmore ở đây
     - Sau khi loadmore thành công sẽ có 2 trường hợp, nếu còn tiếp tục loadmore thì add lệnh stopLoadingMore. còn lại nếu đã hết bản ghi không loadmore nữa thì add lệnh noticeNoMoreData
   * Customize UIView cho header và footer
     - Nếu muốn customize incaditor cho phần header và footer thì chúng ta có thể tạo 1 UIView extends 2 protocol PullLoaderRefreshType, PullLoaderRefreshAnimatorType, lúc đó có thể thoả sức thích làm gì cũng dc ở đây.Lúc đó khi addPullToRefresh, addInfiniteScrolling chỉ cần truyền nó vô qua param animator là dc

###2. Service Networking
* Define app apis:
    ```swift
    enum AppAPI: APIRequestInfo {
        case login
        case logout
        case successWithErrorResponse
    
        var baseURL: URL {
            return URL(string: "your_base_url")!
        }
    
        var path: String {
            switch self {
            case .login:
                return "/login"
            case .logout:
                return "/logout"
            case .successWithErrorResponse:
                return "/successWithErrorResponse"
            }
        }
    
        var task: APITask {
            return .requestPlain
        }
    
        var method: APIMethod {
            return .POST
        }
    
        var headers: [String : String]? {
            return nil
        }
    }
    ```

* Implement an api call:
    ```swift
    let apiService: APIService = MoyaAPIService()
    
    _ = apiService.request(info: AppAPI.login,
                           completion: { (result: Result<BaseResponse, Error>) in
        switch result {
        case .success(_):
            print("login success")
        case .failure(_):
            print("login failure")
        }
    })
    ```

* Support retry, refresh token:
    ```swift
    let apiService: APIService = MoyaAPIService(retryCount: 1,
                                                refreshTokenService: APIRefreshTokenInterceptor())
    ```

* Support refresh token by interval:
Example:
The interceptor will refresh if within 5 minutes of expiration.
Token expiration: 1 hour
Refresh interval: 5 minutes
    ```swift
    class APIRefreshTokenInterceptor: RefreshTokenInterceptor {
        var expiration: Date? {
            // the token is expired after 1 hour
            return Date(timeIntervalSinceNow: 60 * 60)
            
            // return nil to disable
            // return nil
        }
    
        var refreshInterval: Double? {
            // require refresh if within 5 minutes of expiration
            return 5 * 60
            
            // return nil to disable 
            // return nil
        }
    }
    ```

* Receive error returned as a response:
    ```swift
    struct ErrorData: Decodable, Error {
        let id: Int
        let message: String
    }
    struct ErrorResponse: Decodable, Error {
        let statusCode: Int
        let data: ErrorData
    }
    
    _ = apiService.request(info: AppAPI.successWithErrorResponse,
                           errorResponseType: ErrorResponse.self, //(1)
                           completion: { (result: Result<DataResponse<Message>, Error>) in
        switch result {
        case .success(let response):
            print("message: \(response.data?.message ?? "")")
        case .failure(let error):
            if let error = error as? ErrorResponse { //(2)
                print("error status code: \(error.statusCode)")
                print("error message: \(error.data.message)")
            } else {
                print(error)
            }
        }
    })
    ```
    (1): The error model
    (2): Check error model in case failure

###3. Image Loading
   * Có các thành phần chính để sử dụng cho Image Loading :
     - **Url**: được truyền vào là kiểu string của đường dẫn ảnh
     - **Placeholder**: truyền vào để đặt mặc định ảnh trước lúc ảnh được tải thành công
     - **Indicator**: hiển thị indicator loading để thông báo đang tải ảnh
     - **LoadingImageOptions**: chứa các tùy chọn để tương tác với ảnh như tạo bo góc của ảnh, tạo hiệu ứng khi load ảnh, thêm token để tải ảnh về nếu server có yêu cầu, tạo độ ưu tiên để tải ảnh trước hoặc sau...
   * **Ví dụ**:
        ```swift   
        let url = "https://wallpaperaccess.com/full/1947781.jpg"
        let roundCornerImage = RoundCornerLoadingImage(cornerRadius: 100)
        let imageTransition = LoadingImageTransition.flipFromTop(1)
        let modifier: LoadingImageModifierBlock = { urlRequest in
            var request = urlRequest
            request.setValue("Bearer fbzi5u0f5kyajdcxrlnhl3zwl1t2wqao", forHTTPHeaderField: "Authorization")
            return request
        }
        let options = LoadingImageOptions(roundCornerImage: roundCornerImage, 
                                        imageTransition: imageTransition, 
                                        scaleFactorValue: CGFloat(2), 
                                        requestModifier: modifier)
         self.wallpaperImageView.setImage(url: url,
                                        placeholder: UIImage.imgPlaceholder,
                                        indicatorType: .activity,
                                        options: options,
                                        imageProgressBlock: { _, _, percent in
                                                    print("Image loading percent: \(percent)%")
        })
        ```
###4. Theme:
  * Đầu tiên muốn sử dụng được theme thì chúng ta cần cấu hình ở file AppDelegate :
    - Đối với sử dụng dark mode :
        ``` swift
        DarkModeManager.shared.configDarkMode()
        ThemeManager.shared.applyTheme(theme: DarkModeManager.shared.theme)
        ```
    - Nếu không sử dụng dark mode mà sử dụng nhiều theme thì cần sửa những thông tin sau:
      - Sửa ở file ThemeManager:
        ```swift
        func currentTheme() -> Theme {
             switch AppData.themeType {
                case Theme.light.rawValue:
                    return LightTheme()
                case Theme.dark.rawValue:
                    return DarkTheme()
                default return LightTheme()
            }
        }
        ```
      - Sửa ở file AppDelegate:
        ```swift
         ThemeManager.shared.applyTheme(theme: ThemeManager.shared.currentTheme())
        ```
  * Tiếp theo, mỗi ViewModel chúng ta cần inject 2 class:  ThemeUseCase, ThemeManager
  * Ở ViewController chúng ta cần đăng ký nhận sự kiện  ở ViewDidLoad khi theme thay đổi:
    - Ví dụ:
    ```swift
    self.viewModel.themeManager.addThemeObserver(self)
    ```
###5. ERROR COMMON HANDLE
   * Note: 
   - Đối với ServiceError (thêm mới) cần tạo extension Error đó conform BaseErrorServiceConformType implement tiêu chuẩn chung, Hoặc phải tạo MapperToServiceError -> ErrorService chung
   - Đối với LocalError (thêm mới) cần tạo  extension Error đó conform BaseErrorLocalConformType implement tiêu chuẩn chung, Hoặc phải tạo MapperToLocalError -> ErrorLocal chung
   - Cách sử dụng đối ErrorCommon(error chung của dự án):
   + Sử Dụng ErrorCommonMapper truyền vào error để khởi tạo một ErrorCommon với error truyền vào là một Error
   
   Example: let errorCommon = ErrorCommonMapper(error: exampleError)
   -> khởi tạo thành công ErrorCommon
   nếu tạo không thành công xem lại note error của bạn đã conform chưa
   
   * Sử dụng mặc định alert:
   - Ở ViewModel gọi hàm handleOnReceivedError(error: ErrorCommon).
   - tự động show popup alert default
   - Example: 
   ở viewmodel ta request và nhận đc error
   func request(completion: { error in
        let errorCommon = ErrorCommonMapper(error: error) 
           self.handleOnReceivedError(error: errorCommon)
   })
   hàm này từ động show 1 popup alert hiển thị popup 
   
   * Custome for Handle, không muốn dùng action mặc định thì :
   - Ở ViewModel thì override func handleOnReceivedError(error: ErrorConform)
   - hoặc muốn thay đổi alert hoặc tracking error thì có thể edit hoặc override func showMessageFromError(error: ErrorConform)
   - thêm các func hoặc xử lý mong muốn cho hàm
   
###6. Localized String and language
   * Note: Nếu muốn sử dụng auto switch multiple language với mặc định là japan thì không cần điều chỉnh gì cả, app tự động điều chỉnh ngôn ngữ theo language device
   - Đối với trường hợp muốn điều chỉnh ngôn ngữ app thành mặc định 1 ngôn ngữ bất kỳ đã được define sẵn thì ở AppDelegate tại func func application(_ application:, didFinishLaunchingWithOptions launchOptions:) , set thuộc tính AppAppearance.countryConstantApp = language bạn muốn cố định duy nhất trong APP
   - Đối với trường hợp muốn auto switch multiple language với mặc định là ngôn ngữ nào thì vào AppConstants thay đổi giá trị kDefaultLanguage = language muốn điều chỉnh

###7. Crashlytics:
   * Note Thay đổi file Google info plits theo project bundle identifier (firebase tương ứng)

###8. Supported local database(Realm)
1. Define your app model that you want to save to databse
    ```swift
    struct AnimalModel {
        let id: Int
        let name: String
        let weigh: Int
    }
    ```
2. Define Realm object for that app model
    ```swift
    import RealmSwift
    class LocalDBAnimal: RealmSwift.Object {
        @Persisted(primaryKey: true) var id = 0
        @Persisted var name = ""
        @Persisted var weigh = 0
    }
    ```
3. Creare a mapper to map your app model to realm object or vice versa
    ```swift
    class LocalDbAnimalMapper: LocalDbMapper {
        typealias LocalObjectType = LocalDBAnimal
        typealias AppObjectType = AnimalModel
        
        func mapToAppObject(_ object: LocalObjectType) -> AppObjectType {
            return AnimalModel(id: object.id, name: object.name, weigh: object.weigh)
        }
        
        func mapToAppObjects(_ objects: [LocalObjectType]) -> [AppObjectType] {
            return objects.map({ AnimalModel(id: $0.id, name: $0.name, weigh: $0.weigh) })
        }
        
        func mapToLocalObject(_ appObject: AppObjectType) -> LocalObjectType {
            let localObject = LocalDBAnimal()
            localObject.id = appObject.id
            localObject.name = appObject.name
            localObject.weigh = appObject.weigh
            return localObject
        }
        
        func mapToLocalObjects(_ appObjects: [AppObjectType]) -> [LocalObjectType] {
            return appObjects.map({ appObject in
                let localObject = LocalDBAnimal()
                localObject.id = appObject.id
                localObject.name = appObject.name
                localObject.weigh = appObject.weigh
                return localObject
            })
        }
    }
    ```
4. Create, update, delete, find object
    ```swift
    let localDBService: LocalDatabaseService = RealmDatabaseService()
    let mapper = LocalDbAnimalMapper()
    let animal = AnimalModel(id: 0, name: "hello", weigh: 10)
    
    // create an object asynchronously
    localDBService?.create(animal, withMapper: mapper, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message ?? "error without message")
        case .success(_):
            print("create successfully")
        }
    })
    ```
    ```swift
    // find an object with predicate
    localDBService?.find(withMapper: mapper,
                         predicate: NSPredicate(format: "weigh == \(10)"),
                         completion: { result in
        if let result = result {
            print(result)
        } else {
            print("can not find")
        }
    })
    ```
    ```swift
    // update an object asynchronously by primary key
    localDBService?.update("AAAAAA",
                           forKey: "name",
                           primaryKey: 0,
                           mapper: mapper,
                           completion: { result in
        switch result {
        case .failure(let error):
            print(error.message ?? "error without message")
        case .success(_):
            print("update successfully")
        }
    })
    ```
    ```swift
    // update an object asynchronously for multiple values
    localDBService?.update(["name": "BBBBB", "weigh": 20],
                           predicate: NSPredicate(format: "id == \(0)"),
                           mapper: mapper,
                           completion: { result in
        switch result {
        case .failure(let error):
            print(error.message ?? "error without message")
        case .success(_):
            print("update successfully")
        }
    })
    ```
    ```swift
    // find an object by primary key
    localDBService?.find(primaryKey: 0,
                         mapper: mapper,
                         completion: { result in
        if let result = result {
            print(result)
        } else {
            print("can not find")
        }
    })
    ```
    ```swift
    // delete an object asynchronously
    localDBService?.delete(primaryKey: 0, withMapper: mapper, completion: { result in
        switch result {
        case .success(_):
            print("delete successfully")
        case .failure(let error):
            print(error.message ?? "error without message")
        }
    })
    ```

## Những kiểu json response đang được support sẵn
```swift
1. DataResponse
{
    "status": 200,
    "success": true,
    "data": Decodable
}
```
```swift
2. UserResponse
{
    "status": 200,
    "success": true,
    "user": Decodable
}
```
```swift
3. DataUserResponse
{
    "status": 200,
    "success": true,
    "data": {
        "user": Decodable
    }
}
```
```swift
Ví dụ:
struct UserData: Decodable {
    let name: String
    let email: String
}

let apiService: APIService

_ = apiService.request(
        info: APIRequestInfo_instance,
        completion: { (result: Result<DataResponse<UserData>, Error>) in
    switch result {
    case .success(let response):
        print(response.data?.name)
    case .failure(_):
        print("failure")
    }
})

_ = apiService.request(
        info: APIRequestInfo_instance,
        completion: { (result: Result<UserResponse<UserData>, Error>) in
    switch result {
    case .success(let response):
        print(response.user?.name)
    case .failure(_):
        print("failure")
    }
})

_ = apiService.request(
        info: APIRequestInfo_instance,
        completion: { (result: Result<DataUserResponse<UserData>, Error>) in
    switch result {
    case .success(let response):
        print(response.data?.user?.name)
    case .failure(_):
        print("failure")
    }
})
```
