# Forms

Forms is all in one iOS framework

## Import

```swift
import Forms
```

## Dependencies

```
FormsAnchor.framework
FormsInjector.framework
FormsLogger.framework
FormsNetworking.framework
FormsTransition.framework
FormsUtils.framework
FormsValidators.framework
```

## Extensions

```
FormsImagePicker.framework
FormsSideMenu.framework
FormsSocialKit.framework
```

## Usage

### Configuration

In app delegate - right after app starts - you should configure forms.

```swift
Forms.configure()
```

App will register default *configuration*, *theme* and other injections.<br/>
After this you should register your own injections.

```swift
Forms.assemble(assemblies)
```

or doing all in one line

```swift
Forms.configure(Injector.main, assemblies)
```

### Components

All components extend FormsComponent class. Components can be use in FormsTableViewController.<br/>
Component shouldn't be initialized with *init*, but with builder.

```swift
let view = Components.container.view()
    .with(backgroundColor: UIColor.red)
    .with(height: 44)
```

New components or new configuration

```swift
extension Components {
    typealias custom = ComponentsCustom
}

struct ComponentsCustom: ComponentsList {
    private init() { }
        
    public static func someCustomComponent() -> CustomComponent {
        let component = CustomComponent()
        component.marginEdgeInset = UIEdgeInsets(0)
        component.height = UITableView.automaticDimension
        component.paddingEdgeInset = UIEdgeInsets(0)
        return component
    }
}
```

### FormsViewController

FormsViewController should be base for all UIViewControllers. All subviews should be added with Anchor framework.

Lifecycle

```swift
func setupView() {
    self.setupConfiguration()
    self.setupResizerOnKeyboard()
    self.setupKeyboardWhenTappedAround()
    self.setupTheme()
    
    // HOOKS
    self.setupNavigationBar()
    self.setupSearchBar()
    self.setupContent()
    self.setupActions()
    self.setupOther()
}
```

Build

```swift
let view = Components.button.default()
self.view.addSubview(view, witch: [
    Anchor.to(self.view).fill
])
```

### FormsTableViewController

FormsTableViewController extends FormsViewController but basic view is UITableView. Class supports *TableDataSource* and *Direct components*.

Lifecycle

```swift
override func setupView() {
    self.setupConfiguration()
    self.setupResizerOnKeyboard()
    self.setupKeyboardWhenTappedAround()
    self.setupTheme()
    
    self.setupNavigationBar()
    self.setupSearchBar()
    self.setupContent()
    self.setupHeaderView()
    self.setupTableView()
    self.setupDataSource()
    self.setupFooterView()
    self.setupOther()
    self.setupActions()
    
    // HOOKS
    self.setupHeader()   
    self.setupFooter()
    self.setupPagination()
    self.setupPullToRefresh()
}
```

Build

```swift
let view = Components.button.default()
build([view])
```

or 

```swift
let view = Components.button.default()
addComponent(view)
removeComponent(view)
```

Header and Footer

```swift
override func setupHeader() {
    super.setupHeader()
    self.setHeader(
        UIView(), 
        height: 44.0)
}
     
override func setupFooter() {
    super.setupFooter()
    self.addToFooter([
        UIView(),
        UIView()
    ], height: 44.0)
}
```

FormsTableViewController is *Validable* after perform *validate* method all components will be validate.

To enable *Pull to Refresh* You should set *pullToRefreshIsEnabled* flag andd override *pullToRefresh* method. 

```swift
override func pullToRefresh() {
    // some call
    self.pullToRefreshFinish()
}
```

### FormsCollectionViewController

FormsCollectionViewController works like FormsTableViewController but doesn't support direct components.

### FormsTabBarController

FormsTabBarController supports multiple sets

```swift
    enum TabBarKeys: String, TabBarKey {
        case main
        case other
        
        var keys: [TabBarItemKey] {
            switch self {
            case .main: return TabBarMainKeys.allCases
            case .other: return TabBarOtherKeys.allCases
            }
        }
    }
    enum TabBarMainKeys: String, TabBarItemKey, CaseIterable {
        case first
        case second
    }
    enum TabBarOtherKeys: String, TabBarItemKey, CaseIterable {
        case first
        case second
        case third
    }
```

```swift
override func setupItems() {
    super.setupItems()
    self.addSet([
            TabBarItem(
                itemKey: TabBarMainKeys.first,
                viewController: { UIViewController() },
                image: UIImage.from(name: "heart.fill"),
                selectedImage: UIImage.from(name: "heart.fill"),
                title: "First"
            ),
            TabBarItem(
                itemKey: TabBarMainKeys.second,
                viewController: { return UIViewController() },
                image: UIImage.from(name: "heart"),
                selectedImage: UIImage.from(name: "heart"),
                title: "Second",
                isTranslucent: true
            )
        ], forKey: TabBarKeys.main)
```

Select set and item

```swift
select(TabBarKeys.main, itemKey: TabBarMainKeys.second)
```

You can show or hide tab bar

```swift
func showTabBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
func hideTabBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
```


### FormsPagerController

```swift
override func setupItems() {
    super.setupItems()
    self.setItems([
        PagerItem(
            viewController: { UIViewController() }
            title: "First",
            onSelect: { _ in }),
        PagerItem(
            viewController: { UIViewController() }
            title: "Second is longer",
            onSelect: { _ in }),
    ])
```

You can show or hide top bar

```swift
func showTopBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
func hideTopBar(animated: Bool = true,
                completion: ((Bool) -> Void)? = nil) {
```

and page control

```swift
func showPageControl(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
func hidePageControl(animated: Bool = true,
                    completion: ((Bool) -> Void)? = nil) {
```

### FormsSearchController

FormsSearchController extends UISearchController and allows use it in navigation item.

```swift
override func setupSearchBar() {
    super.setupSearchBar()
    self.setSearchBar(self.searchController)
}
```

## Delegates and DataSources

### TableView

FormsTableViewController implements dataSource by default

```swift
let dataSource = TableDataSource()
setDataSource(dataSource)
setItems(items)
```

Cells should conform FormsTableViewCell

```swift
let items: [TableRow] = [
    TableRow(of: DemoTableViewCell.self, data: SomeData()),
    TableRow(of: DemoTableViewCell.self, data: SomeData()),
    TableRow(of: DemoTableViewCell.self, data: SomeData())
]

class DemoTableViewCell: FormsTableViewCell {}
    func fill(_ source: SomeData) { }
}
```

Setup and click cells in FormsTableViewController

```swift
override func setupCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath) { 
    super.setupCell(row: row, cell: cell, indexPath: indexPath)
        cell.cast(row: row, of: SomeData.self, to: FormsTableViewCell.self) { (newData, newCell) in
            newCell.fill(newData)
        }
}

override func selectCell(row: TableRow, cell: FormsTableViewCell, indexPath: IndexPath) {
    super.selectCell(row: row, cell: cell, indexPath: indexPath)
    cell.cast(row: row, of: DemoCellModel.self, to: DemoTableViewCell.self) { [unowned self] (newData, newCell) in }
}
```

### CollectionView

CollectionDataSource works exactly like TableDataSource.

### TextField

TextField delegates helps with managing input text

```swift
TextFieldDelegates.amount()
TextFieldDelegates.default()
TextFieldDelegates.email()
TextFieldDelegates.pesel()
TextFieldDelegates.phone()
TextFieldDelegates.postCode()
```

By default TextFields set properly delegate.

You can extract delegate from *TextField*

```swift
textField.textFieldDelegate(of: TextFieldAmountDelegate.self)?
    .configure(currency: "USD", maxValue: 100_000, maxFraction: 4)
```

### SearchController

SearchDataSource may be used only with *TableView* and *FormsSearchController*

```swift
let dataSource = SearchDataSource<DemoSection>(tableView)
let searchController = FormsSearchController(dataSource)
```

Set search in controller

```swift
navigationItem.searchController = searchController
```

or in FormsViewController

```swift
override func setupSearchBar() {
    super.setupSearchBar()
    setSearchBar(searchController)
}
```

Default items source can be replaced by without changing table source

```swift
var items: [Any] {
    get { return dataSource.items }
    set { dataSource.items = newValue }
}
```

## Utils

### AppStoreReview

```swift
let appStoreReview = AppStoreReview(
    minLaunchCount: 3, // minimum launch count
    minPeriod: 60 * 60 * 24, // after each 1 day
    minPeriodInterval: 60 * 60 * 24 * 30 // each 1 month
)
```

Right after app starts you should notify service. This method will save first launch date for later comparisons.

```swift
appStoreReview.initFirstLaunchIfNeeded()
```

After each launch you should also notify service for changing launch counter. (Notice that init doesn't change launch count)

```swift
appStoreReview.launch()
```

When your app is ready to display review information you can show modal 

```swift
appStoreReview.showIfNeeded()
```

### Keyboard

FormsViewController by default implements lazy Keyboard property that can be controlled by *isResizeOnKeyboard* property.

```swift
lazy var keyboard = Keyboard()
```

In custom controller implementation you should *add* and *remove* observer by yourself

```swift
keyboard.registerKeyboard()
keyboard.unregisterKeyboard()
```

To handle update

```swift
keyboard.onUpdate = { (percent: CGFloat, visibleHeight: CGFloat, animated: Bool) in }
```

### Loader

Loader can be shown on every UIViewController (also UINavigationController)

```swift
Loader.show(in: controller)?
    .with(title: "Loading...")
Loader.hide(in: controller)
```

or

```swift
Loader.show(
    in: controller,
    of: CustomLoaderView.self)
```

Custom configuration

```swift
Injector.main.register(ConfigurationLoaderProtocol.self) { _ in
    Configuration.Loader(
        backgroundColor: UIColor.red(),
        loaderView: { CustomLoaderView() }
    )
}
```

Custom loader implementation

```swift
class CustomLoaderView: LoaderView {
    override func add(to parent: UIView) { }
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
}
```

### Modal

Modal can be shown on every UIViewController (also UINavigationController)

```swift
Modal.show(
    in: controller,
    of: CustomModalView.self)
Modal.hide(
    in: controller,
    of: CustomModalView.self)
```

In modal you can hide by using

```swift
Modal.hide(
    in: self.context,
    of: CustomModalView.self)
```

Custom configuration

```swift
Injector.main.register(ConfigurationModalProtocol.self) { _ in
    Configuration.Modal(
        backgroundColor: UIColor.red()
    )
}
```

Modal implementation

```swift
class CustomModalView: ModalView {
    override func add(to parent: UIView) { }
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
}
```

### Pagination

Pagination works properly with *TableDataSource* and *CollectionDataSource* in FormsTableViewController and FormsCollectionViewController.

```swift
let dataSource = TableDataSource()
    .with(delegate: self)

// or

let dataSource = CollectionDataSource()
    .with(delegate: self)

```

Next page is fetched in *paginationNext* method

```swift
override func paginationNext() {
    // fetch next page
}
```

Pagination should be completed with success or error

```swift
paginationSuccess(delay: 0.5, isLast: false)
paginationError(delay: 3.0, isLast: false)
```

Data provider

```swift
let pagination = Pagination(
    of: DemoCellModel.self, // Any 
    firstPageId: 0, // Page
    onNextPageId: { (pagination, page) in /* returns next id */ })
```

Reset pagination

```swift
pagination.reset()
```

Loading pagination

```swift
let pageId = pagination.startLoading()

let page = Page(
        pageId: pageId,
        data: items,
        isLast: false
pagination.stopLoading(page)

// or

let page = Page(
    pageId: pageId,
    data: [],
    error: error)
pagination.stopLoading(page)
```

Instead of using *TableDataSource* or *CollectionDataSource* you should use *ShimmerTableDataSource* or *ShimmerCollectionDataSource*.

```swift
let dataSource = ShimmerTableDataSource()
    .with(generators: [ShimmerRowGenerator(type: ShimmerTableViewCell.self, count: 3)]
    .with(delegate: self)

// or

let dataSource = CollectionDataSource()
    .with(generators: [ShimmerItemGenerator(type: ShimmerCollectionViewCell.self, count: 3)]
    .with(delegate: self)

```

### ScrollSteps

Allows you update view in certain offsets

```swift
var scrollTopSteps = ScrollStep(0..<200)
var scrollBottomSteps = ScrollStep(200..<800)
var scrollSteps = ScrollSteps([scrollTopSteps, scrollBottomSteps])
```

ScrollContainer has *scrollSteps* property to manage steps and send *onUpdate* callbacks.

For other scroll you can perform *update* method when offset did change

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollSteps.update(scrollView.contentOffset)
}
```

You can use *onUpdateVertical* and *onUpdateHorizontal* callbacks.

```swift
scrollSteps.onUpdateVertical = { (step: ScrollStep, progress: CGFloat) in
    switch step {
    case scrollTopSteps:
        // some changes
    case scrollBottomSteps:
        // some changes
    default: break
    }
}
```

### Shimmer

FormsViewController and other Forms controllers supports Shimmering.

Start / stop shimmering. Views that conform *Shimmerable* in hierarchy will start shimmering. 

```swift
startShimmering()
stopShimmering()
```

By default all views are *Shimmerable*. To prevent shimmering you should implement *UnShimmerable* protocol.

All Forms cells are also *Shimmerable*. You should override implement *prepareForShimmering* method to shimmer table properly.

```swift
override func prepareForShimmering() {
    // prepare view
}
```

Shimmer supports also *TableDataSource*, *CollectionDataSource* and *Pagination*

```swift
let shimmerDataSource = ShimmerTableDataSource()
    .with(generators: [
        ShimmerRowGenerator(type: ShimmerShortDemoTableViewCell.self, count: 6),
        ShimmerRowGenerator(type: ShimmerLongDemoTableViewCell.self, count: 3)
    ])
```

where cells implements Forms cell protocol

```swift
class ShimmerShortDemoTableViewCell: FormsTableViewCell {
    override func prepareForShimmering() { }
}

class ShimmerLongDemoTableViewCell: FormsTableViewCell {
    override func prepareForShimmering() { }
}
```

*FormsTableViewController* and *FormsCollectionViewController* supports shimmering with dataSource

```swift
startShimmering(shimmerDataSource)
```

### Storage

Storage keys

```swift
enum StorageKeys: String, StorageKey {
    case token
}
```

Storage wrappers

```swift
@Storage(StorageKeys.token)
let token: String?

@StorageWithDefault(StorageKeys.token, "some_token")
let token: String

@StorageKeychain(StorageKeys.token)
let token: String?

@StorageKeychainWithDefault(StorageKeys.token)
let token: String
```

Property wrapper read / write

```swift 
let value = token
token = "New value"
```

or standard read / write

```swift
let token = Storage<String>(StorageKeys.token)
let value = token
token.value = "New value"
```

### Theme

Configuration

```swift
Injector.main.register(ThemeColorsProtocol.self, name: ThemeType.light.key) { _ in
    ThemeColors(colors: [
        .blue: UIColor(rgba: 0x007AFFFF),
        .gray: UIColor(rgba: 0x8E8E93FF),
        .green: UIColor(rgba: 0x34C759FF),
        .red: UIColor(rgba: 0xFF3B30FF),
        .primaryText: UIColor(rgba: 0x000000FF),
        .secondaryText: UIColor(rgba: 0x3C3C4399),
        .tertiaryText: UIColor(rgba: 0x3C3C434D),
        .primaryBackground: UIColor(rgba: 0xFFFFFFFF),
        .secondaryBackground: UIColor(rgba: 0xF2F2F7FF),
        .tertiaryBackground: UIColor(rgba: 0xFFFFFFFF)
    ], statusBar: .dark)
}
```

You should always use Theme to resolve color

```swift
Theme.Colors.primaryText
Theme.Fonts.regular(ofSize: 14)
```

instead of

```swift
UIColor.black
UIFont.regular(ofSize: 14)
```

Set app theme (in SceneDelegate)

```swift
Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
```

and

```swift
func sceneWillEnterForeground(_ scene: UIScene) {
    guard let window: UIWindow = self.window else { return }
    Theme.setUserInterfaceStyle(window.traitCollection.userInterfaceStyle)
}
```

Set custom theme

```swift 
Theme.setTheme(.dark)
```

By default FormsViewController observe theme change. You can control registration by using *isThemeAutoRegister* flag. In other classes you have to implement *Themeable* protoco and register class.

```swift
class CustomView: UIView, Themeable {
    func setTheme() {
        // some changes
    }
}

let view = CustomView()
Theme.register(view)
Theme.unregister(view)
```

After theme changed *setTheme* method is performed and update view theme. In component or Themeable classes you can override theme behavior

```swift
override func setTheme() {
    super.setTheme()
    // some changes
}
```

Custom theme

```swift
Injector.main.register(ThemeColorsProtocol.self, name: ThemeType.custom("PINK").key) { _ in 
    ...
}
```

Custom Theme key

```swift
extension ThemeColorsKey {
    static var yellow = ThemeColorsKey("yellow")
}

extension ThemeColorsProtocol {
    var yellow: UIColor {
        return self.color(.yellow)
    }
}

...
ThemeColors(colors: [
    ...
    .yellow: UIColor(rgba: 0xFFFF00)
    ...
])
...
```

Fonts Configuration

```swift
Injector.main.register(ThemeFontsProtocol.self) { _ in
    ThemeFonts(fonts: [
        .bold: { UIFont.boldSystemFont(ofSize: $0) },
        .regular: { UIFont.systemFont(ofSize: $0) }
    ])
}
```

### Toast

Toast can be shown on every UIViewController (also UINavigationController)

```swift
Toast.new()
    .with(title: "Some message"))
    .show(in: controller)
```

or

```swift
Toast.new(of: CustomToastView.self)
    .show(in: controller)
```

Position allows you to change toast position

```swift
enum ToastPosition {
    case top
    case bottom
}
```

```swift
Toast.new()
    .with(position: .bottom))
    .with(title: "Some message"))
    .show(in: controller)
```

Style allows you to change toast presentation style

```swift
enum ToastStyleType {
    case info
    case success
    case error
}
```

```swift
Toast.new()
    .with(style: .info))
    .with(title: "Some message"))
    .show(in: controller)
```

or 

```swift
Toast.error()
    .with(title: "Some message"))
    .show(in: controller)
```

Custom configuration

```swift
Injector.main.register(ConfigurationToastProtocol.self) { _ in
    return Configuration.Toast(
        backgroundColor: .init(
            info: UIColor.black,
            success: UIColor.green,
            error: UIColor.red)
    )
}
```

Custom toast implementation

```swift
class CustomToastView: ToastView {
    override func add(to parent: UIView) { }
    override func show(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
    override func hide(animated: Bool,
                       completion: ((Bool) -> Void)? = nil) { }
}
```

## Demo 

Complete demo is in FormsDemo project